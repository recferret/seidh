import { v4 as uuidv4 } from 'uuid';

import { Inject, Injectable, Logger } from '@nestjs/common';
import { ClientProxy } from '@nestjs/microservices';
import { Config } from './main';
import { GameInstance } from './game/game.instance';
import { ServiceName } from '@app/seidh-common';
import { 
  GameplayLobbyGameInfo, 
  GameplayLobbyUpdateGamesMessage, 
  GameplayLobbyUpdateGamesPattern 
} from '@app/seidh-common/dto/gameplay-lobby/gameplay-lobby.update.games.msg';
import { GameplayJoinGameMessage } from '@app/seidh-common/dto/gameplay/gameplay.join.game.msg';
import { Cron, CronExpression } from '@nestjs/schedule';
import { GameType } from '@app/seidh-common/dto/gameplay-lobby/gameplay-lobby.find.game.msg';
import { WsGatewayGameInitMessage, WsGatewayGameInitPattern } from '@app/seidh-common/dto/ws-gateway/ws-gateway.game.init.msg';
import { EventEmitter2, OnEvent } from '@nestjs/event-emitter';
import { EventGameCreateCharacter } from './events/event.game.create-character';
import { EventGameDeleteCharacter } from './events/event.game.delete-character';
import { EventGameCreateProjectile } from './events/event.game.create-projectile';
import { EventGameDeleteProjectile } from './events/event.game.delete-projectile';
import { EventGameGameState } from './events/event.game.state';
import { EventGameCharacterActions } from './events/event.game.character-actions';
import { WsGatewayGameStateMessage, WsGatewayGameStatePattern } from '@app/seidh-common/dto/ws-gateway/ws-gateway.game.state.msg';
import { WsGatewayGameCharacterActionsMessage, WsGatewayGameCharacterActionsPattern } from '@app/seidh-common/dto/ws-gateway/ws-gateway.game.character.actions.msg';
import { WsGatewayGameCreateCharacterMessage, WsGatewayGameCreateCharacterPattern } from '@app/seidh-common/dto/ws-gateway/ws-gateway.game.create.character.msg';
import { WsGatewayGameCreateProjectileMessage, WsGatewayGameCreateProjectilePattern } from '@app/seidh-common/dto/ws-gateway/ws-gateway.game.create.projectile.msg';
import { WsGatewayGameDeleteCharacterMessage, WsGatewayGameDeleteCharacterPattern } from '@app/seidh-common/dto/ws-gateway/ws-gateway.game.delete.character.msg';
import { WsGatewayGameDeleteProjectileMessage, WsGatewayGameDeleteProjectilePattern } from '@app/seidh-common/dto/ws-gateway/ws-gateway.game.delete.projectile.msg';
import { GameplayInputMessage } from '@app/seidh-common/dto/gameplay/gameplay.input.msg';
import { GameplayDisconnectedMessage } from '@app/seidh-common/dto/gameplay/gameplay.disconnected.msg';

@Injectable()
export class GameplayService {

  public static readonly ConnectedPlayers = new Set<string>();

  private readonly playerLastRequestTime = new Map<string, number>();
  private readonly playerDisconnectTimeout = 5 * 1000;

  private readonly gameInstances = new Map<string, GameInstance>();
  private readonly playerGameInstance = new Map<string, string>();
  private readonly playersToInit = new Set<string>();

  private readonly gameInstance: GameInstance;

  constructor(
    private eventEmitter: EventEmitter2,
    @Inject(ServiceName.WsGateway) private wsGatewayService: ClientProxy,
    @Inject(ServiceName.GameplayLobby) private gameplayLobbyService: ClientProxy
  ) {
    // Notify lobby service about current players and games
    setInterval(async () => {
      const games: GameplayLobbyGameInfo[] = [];

      this.gameInstances.forEach(gameInstance => {
        games.push({
          gameId: gameInstance.gameId,
          gameType: gameInstance.gameType,
          playersOnline: 0
        })
      });

      const message: GameplayLobbyUpdateGamesMessage = {
        gameplayServiceId: Config.GAMEPLAY_INSTANCE_ID,
        games,
      }
      this.gameplayLobbyService.emit(GameplayLobbyUpdateGamesPattern, message);
    }, 1000);

    // Dummy game for testing
    this.gameInstance = new GameInstance(this.eventEmitter, uuidv4(), GameType.PublicGame);
    this.gameInstances.set(this.gameInstance.gameId, this.gameInstance);

    Logger.log('GameplayService initialized', Config.GAMEPLAY_INSTANCE_ID);
  }

  // ----------------------------------------------
  // Client -> Server
  // ---------------------------------------------- 

  public disconnected(message: GameplayDisconnectedMessage) {
    this.deletePlayer(message.playerId, 'disconnected');
  }

  public joinGame(message: GameplayJoinGameMessage) {
    this.playerLastRequestTime.set(message.playerId, Date.now());
    
    // let gameInstance: GameInstance = undefined;

    this.gameInstance.addPlayer(message.playerId);

    this.playerGameInstance.set(message.playerId, this.gameInstance.gameId);
    this.playersToInit.add(message.playerId);

    GameplayService.ConnectedPlayers.add(message.playerId);

    // if (message.gameId) {
    //   // TODO impl join game
    //   gameInstance = this.gameInstances.get(message.gameId);
    //   if (!gameInstance) {
    //     Logger.log('Join a game');
    //     this.playerGameInstance.set(message.playerId, gameInstance.gameId);
    //     this.playersToInit.add(message.playerId);
    //     gameInstance.addPlayer(message.playerId);
    //   } else {
    //     Logger.error('Error while joining the game');
    //     // TODO impl error while join game
    //   }
    // } else {
    //   // Create a new game
    //   Logger.log('Create a new game');
    //   gameInstance = new GameInstance(this.eventEmitter, uuidv4(), GameType.PublicGame);
    //   gameInstance.addPlayer(message.playerId);
    //   this.gameInstances.set(gameInstance.gameId, gameInstance);
    //   this.playerGameInstance.set(message.playerId, gameInstance.gameId);
    //   this.playersToInit.add(message.playerId);
    // }
  }

  public input(message: GameplayInputMessage) {
    this.playerLastRequestTime.set(message.playerId, Date.now());
    this.checkPlayerConnected(message.playerId);
    const gameInstance = this.checkAndGetGameInstance(message.gameId);
    gameInstance.input({
      playerId: message.playerId,
      index: message.index,
      actionType: message.actionType,
      movAngle: message.movAngle
    });
  }

  private checkPlayerConnected(playerId: string) {
    if(!GameplayService.ConnectedPlayers.has(playerId)) {
      throw new Error('Player '+ playerId +' is not connected');
    }
  }

  private checkAndGetGameInstance(gameId: string, description?: string) {
    const gameInstance = this.gameInstances.get(gameId);
    if (!gameInstance) {
      throw new Error(`Game '+ gameId +' does not exist.${description && description.length > 0 ? ` (${description})` : ''}`);
    } 
    return gameInstance;
  }

  // ----------------------------------------------
  // Server -> Client
  // ----------------------------------------------

  @OnEvent(EventGameGameState.EventName)
  handleEventGameGameState(payload: EventGameGameState) {
    // Notify new players about full game state
    if (payload.charactersFullStruct.length > 0) {
      this.playersToInit.forEach(playerId => {
        const initMessage: WsGatewayGameInitMessage = {
          targetPlayerId : playerId,
          gameId: payload.gameId,
          charactersFullStruct: payload.charactersFullStruct
        };
        this.wsGatewayService.emit(WsGatewayGameInitPattern, initMessage);
      });
      this.playersToInit.clear();
    }

    // Notify all players about changed game state
    if (payload.charactersMinStruct.length > 0) {
      const message: WsGatewayGameStateMessage = {
        gameId: payload.gameId,
        charactersMinStruct: payload.charactersMinStruct
      }
      this.wsGatewayService.emit(WsGatewayGameStatePattern, message);
    }
  }

  @OnEvent(EventGameCreateCharacter.EventName)
  handleEventGameCreateCharacter(payload: EventGameCreateCharacter) {
    const message: WsGatewayGameCreateCharacterMessage = {
      gameId: payload.gameId,
      characterEntityFullStruct: payload.characterEntityFullStruct,
      excludePlayerId: payload.characterEntityFullStruct.base.ownerId,
    }
    this.wsGatewayService.emit(WsGatewayGameCreateCharacterPattern, message);
  }

  @OnEvent(EventGameDeleteCharacter.EventName)
  handleEventGameDeleteCharacter(payload: EventGameDeleteCharacter) {
    const message: WsGatewayGameDeleteCharacterMessage = {
      gameId: payload.gameId,
      characterId: payload.characterId,
    }
    this.wsGatewayService.emit(WsGatewayGameDeleteCharacterPattern, message);
  }

  @OnEvent(EventGameCreateProjectile.EventName)
  handleEventGameCreateProjectile(payload: EventGameCreateProjectile) {
    const message: WsGatewayGameCreateProjectileMessage = {
      gameId: payload.gameId,
    }
    this.wsGatewayService.emit(WsGatewayGameCreateProjectilePattern, message);
  }

  @OnEvent(EventGameDeleteProjectile.EventName)
  handleEventGameDeleteProjectile(payload: EventGameDeleteProjectile) {
    const message: WsGatewayGameDeleteProjectileMessage = {
      gameId: payload.gameId,
    }
    this.wsGatewayService.emit(WsGatewayGameDeleteProjectilePattern, message);
  }

  @OnEvent(EventGameCharacterActions.EventName)
  handleEventGameCharacterActions(payload: EventGameCharacterActions) {
    const message: WsGatewayGameCharacterActionsMessage = {
      gameId: payload.gameId,
      actions: payload.actions
    }
    this.wsGatewayService.emit(WsGatewayGameCharacterActionsPattern, message);
  }

  // ----------------------------------------------
  // Common
  // ----------------------------------------------

  // @Cron(CronExpression.EVERY_5_SECONDS)
  dropDisconnectedPlayers() {
    const now = Date.now();
    const playersToDrop = [];

    this.playerLastRequestTime.forEach((value, key) => {
      if (now - value > this.playerDisconnectTimeout) {
        playersToDrop.push(key);
      }
    });
  
    playersToDrop.forEach(key => {
      this.playerLastRequestTime.delete(key);
      this.deletePlayer(key, 'drop');
    });
  }

  private deletePlayer(playerId: string, deleteType: string) {
    if (GameplayService.ConnectedPlayers.has(playerId)) {
      GameplayService.ConnectedPlayers.delete(playerId);
      const gameInstance = this.checkAndGetGameInstance(this.playerGameInstance.get(playerId), `${deleteType} ${playerId}`);
      if (gameInstance) {
        gameInstance.deletePlayer(playerId);
        this.playerGameInstance.delete(playerId);
      } else {
        Logger.error('Player '+ playerId +' is not in the game, unable to drop');
      }
    } else {
      Logger.error('Player '+ playerId +' is not connected, unable to drop');
    }
  }

}
