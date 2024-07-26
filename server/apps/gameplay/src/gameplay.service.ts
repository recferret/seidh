import { v4 as uuidv4 } from 'uuid';

import { Inject, Injectable, Logger } from '@nestjs/common';
import { ClientProxy } from '@nestjs/microservices';
import { Config } from './main';
import { GameInstance } from './game/game.instance';
import { ServiceName } from '@app/seidh-common';
import {
  GameplayLobbyGameInfo,
  GameplayLobbyUpdateGamesMessage,
  GameplayLobbyUpdateGamesPattern,
} from '@app/seidh-common/dto/gameplay-lobby/gameplay-lobby.update.games.msg';
import { GameplayJoinGameMessage } from '@app/seidh-common/dto/gameplay/gameplay.join.game.msg';
import { GameType } from '@app/seidh-common/dto/gameplay-lobby/gameplay-lobby.find.game.msg';
import { EventEmitter2, OnEvent } from '@nestjs/event-emitter';
import { EventGameCreateCharacter } from './events/event.game.create-character';
import { EventGameDeleteCharacter } from './events/event.game.delete-character';
import { EventGameCreateProjectile } from './events/event.game.create-projectile';
import { EventGameDeleteProjectile } from './events/event.game.delete-projectile';
import { EventGameLoopState } from './events/event.game.loop-state';
import { EventGameCharacterActions } from './events/event.game.character-actions';
import { EventGameGameState } from './events/event.game.game-state';
import { EventGameCreateConsumable } from './events/event.game.create-consumable';
import { EventGameDeleteConsumable } from './events/event.game.delete-consumable';
import { GameplayInputMessage } from '@app/seidh-common/dto/gameplay/gameplay.input.msg';
import { GameplayDisconnectedMessage } from '@app/seidh-common/dto/gameplay/gameplay.disconnected.msg';
import {
  WsGatewayGameInitMessage,
  WsGatewayGameInitPattern,
} from '@app/seidh-common/dto/ws-gateway/ws-gateway.game.init.msg';
import {
  WsGatewayGameCharacterActionsMessage,
  WsGatewayGameCharacterActionsPattern,
} from '@app/seidh-common/dto/ws-gateway/ws-gateway.game.character.actions.msg';
import {
  WsGatewayGameCreateCharacterMessage,
  WsGatewayGameCreateCharacterPattern,
} from '@app/seidh-common/dto/ws-gateway/ws-gateway.game.create.character.msg';
import {
  WsGatewayGameCreateProjectileMessage,
  WsGatewayGameCreateProjectilePattern,
} from '@app/seidh-common/dto/ws-gateway/ws-gateway.game.create.projectile.msg';
import {
  WsGatewayGameDeleteCharacterMessage,
  WsGatewayGameDeleteCharacterPattern,
} from '@app/seidh-common/dto/ws-gateway/ws-gateway.game.delete.character.msg';
import {
  WsGatewayGameDeleteProjectileMessage,
  WsGatewayGameDeleteProjectilePattern,
} from '@app/seidh-common/dto/ws-gateway/ws-gateway.game.delete.projectile.msg';
import {
  WsGatewayGameLoopStateMessage,
  WsGatewayGameLoopStatePattern,
} from '@app/seidh-common/dto/ws-gateway/ws-gateway.game.loop.state.msg';
import {
  WsGatewayGameGameStateMessage,
  WsGatewayGameGameStatePattern,
} from '@app/seidh-common/dto/ws-gateway/ws-gateway.game.game.state';
import {
  WsGatewayGameCreateConsumableMessage,
  WsGatewayGameCreateConsumablePattern,
} from '@app/seidh-common/dto/ws-gateway/ws-gateway.game.create.consumable.msg';
import {
  WsGatewayGameDeleteConsumableMessage,
  WsGatewayGameDeleteConsumablePattern,
} from '@app/seidh-common/dto/ws-gateway/ws-gateway.game.delete.consumable.msg';
import { EventGameInit } from './events/event.game.init';
import {
  GameplayCreatedRoomMsg,
  GameplayCreateNewRoomMsg,
} from '@app/seidh-common/dto/gameplay/gameplay.createNewRoom.msg';

@Injectable()
export class GameplayService {
  public static readonly ConnectedUsers = new Set<string>();

  private readonly gameInstances = new Map<string, GameInstance>();

  private readonly userLastRequestTime = new Map<string, number>();
  private readonly userDisconnectTimeout = 5 * 1000;
  private readonly userGameInstance = new Map<string, string>();
  private readonly usersToInit = new Set<string>();

  private readonly gameInstance: GameInstance;

  constructor(
    private eventEmitter: EventEmitter2,
    @Inject(ServiceName.WsGateway) private wsGatewayService: ClientProxy,
    @Inject(ServiceName.GameplayLobby)
    private gameplayLobbyService: ClientProxy,
  ) {
    // Notify lobby service about current users and games
    setInterval(async () => {
      const games: GameplayLobbyGameInfo[] = [];

      this.gameInstances.forEach((gameInstance) => {
        console.log('gameInstance', gameInstance.gameId);
        games.push({
          gameId: gameInstance.gameId,
          gameType: gameInstance.gameType,
          usersOnline: 6, // Testing purpose
        });
      });

      const message: GameplayLobbyUpdateGamesMessage = {
        gameplayServiceId: Config.GAMEPLAY_INSTANCE_ID,
        games,
      };
      this.gameplayLobbyService.emit(GameplayLobbyUpdateGamesPattern, message);
    }, 1000);

    // Dummy game for testing
    let id = uuidv4();
    this.gameInstances.set(
      id,
      new GameInstance(this.eventEmitter, id, GameType.PublicGame),
    );
    id = uuidv4();
    this.gameInstances.set(
      id,
      new GameInstance(this.eventEmitter, id, GameType.TestGame),
    );
    Logger.log('GameplayService initialized', Config.GAMEPLAY_INSTANCE_ID);
  }

  // ----------------------------------------------
  // Client -> Server
  // ----------------------------------------------

  public disconnected(message: GameplayDisconnectedMessage) {
    this.deleteUser(message.userId, 'disconnected');
  }

  public joinGame(message: GameplayJoinGameMessage) {
    this.userLastRequestTime.set(message.userId, Date.now());
    this.userGameInstance.set(message.userId, this.gameInstance.gameId);
    this.usersToInit.add(message.userId);
    this.gameInstance.addPlayer(message.userId);

    Logger.log('joinGame', message.userId);

    GameplayService.ConnectedUsers.add(message.userId);

    // let gameInstance: GameInstance = undefined;

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
    this.userLastRequestTime.set(message.userId, Date.now());
    this.checkUserConnected(message.userId);
    const gameInstance = this.checkAndGetGameInstance(message.gameId);
    gameInstance.input({
      userId: message.userId,
      index: message.index,
      actionType: message.actionType,
      movAngle: message.movAngle,
    });
  }

  public createNewGameRoom(message: GameplayCreateNewRoomMsg) {
    const instanceId = uuidv4();
    this.gameInstances.set(
      instanceId,
      new GameInstance(this.eventEmitter, instanceId, message.gameType),
    );

    return {
      gameInstance: instanceId,
      gamePlayInstance: Config.GAMEPLAY_INSTANCE_ID,
    } as GameplayCreatedRoomMsg;
  }

  private checkUserConnected(userId: string) {
    if (!GameplayService.ConnectedUsers.has(userId)) {
      throw new Error('User ' + userId + ' is not connected');
    }
  }

  private checkAndGetGameInstance(gameId: string, description?: string) {
    const gameInstance = this.gameInstances.get(gameId);
    if (!gameInstance) {
      throw new Error(
        `Game '+ gameId +' does not exist.${description && description.length > 0 ? ` (${description})` : ''}`,
      );
    }
    return gameInstance;
  }

  // ----------------------------------------------
  // Server -> Client
  // ----------------------------------------------

  // Input

  @OnEvent(EventGameInit.EventName)
  handleEventGameInit(payload: EventGameInit) {
    // Notify new users about full game state
    if (payload.charactersFullStruct.length > 0) {
      this.usersToInit.forEach((userId) => {
        const message: WsGatewayGameInitMessage = {
          targetUserId: userId,
          gameId: payload.gameId,
          charactersFullStruct: payload.charactersFullStruct,
        };
        this.wsGatewayService.emit(WsGatewayGameInitPattern, message);
      });
      this.usersToInit.clear();
    }
  }

  // Character

  @OnEvent(EventGameCreateCharacter.EventName)
  handleEventGameCreateCharacter(payload: EventGameCreateCharacter) {
    const message: WsGatewayGameCreateCharacterMessage = {
      gameId: payload.gameId,
      characterEntityFullStruct: payload.characterEntityFullStruct,
      excludeUserId: payload.characterEntityFullStruct.base.ownerId,
    };
    this.wsGatewayService.emit(WsGatewayGameCreateCharacterPattern, message);
  }

  @OnEvent(EventGameDeleteCharacter.EventName)
  handleEventGameDeleteCharacter(payload: EventGameDeleteCharacter) {
    const message: WsGatewayGameDeleteCharacterMessage = {
      gameId: payload.gameId,
      characterId: payload.characterId,
    };
    this.wsGatewayService.emit(WsGatewayGameDeleteCharacterPattern, message);
  }

  // Consumable

  @OnEvent(EventGameCreateConsumable.EventName)
  handleEventGameCreateConsumable(payload: EventGameCreateConsumable) {
    const message: WsGatewayGameCreateConsumableMessage = {
      gameId: payload.gameId,
      consumableEntityStruct: payload.consumableEntityStruct,
    };
    this.wsGatewayService.emit(WsGatewayGameCreateConsumablePattern, message);
  }

  @OnEvent(EventGameDeleteConsumable.EventName)
  handleEventGameDeleteConsumable(payload: EventGameDeleteConsumable) {
    const message: WsGatewayGameDeleteConsumableMessage = {
      gameId: payload.gameId,
      entityId: payload.entityId,
      takenByCharacterId: payload.takenByCharacterId,
    };
    this.wsGatewayService.emit(WsGatewayGameDeleteConsumablePattern, message);
  }

  // Projectile

  @OnEvent(EventGameCreateProjectile.EventName)
  handleEventGameCreateProjectile(payload: EventGameCreateProjectile) {
    const message: WsGatewayGameCreateProjectileMessage = {
      gameId: payload.gameId,
    };
    this.wsGatewayService.emit(WsGatewayGameCreateProjectilePattern, message);
  }

  @OnEvent(EventGameDeleteProjectile.EventName)
  handleEventGameDeleteProjectile(payload: EventGameDeleteProjectile) {
    const message: WsGatewayGameDeleteProjectileMessage = {
      gameId: payload.gameId,
    };
    this.wsGatewayService.emit(WsGatewayGameDeleteProjectilePattern, message);
  }

  // Actions

  @OnEvent(EventGameCharacterActions.EventName)
  handleEventGameCharacterActions(payload: EventGameCharacterActions) {
    const message: WsGatewayGameCharacterActionsMessage = {
      gameId: payload.gameId,
      actions: payload.actions,
    };
    this.wsGatewayService.emit(WsGatewayGameCharacterActionsPattern, message);
  }

  // States

  @OnEvent(EventGameLoopState.EventName)
  handleEventGameLoopState(payload: EventGameLoopState) {
    // Notify all users about changed game state
    if (payload.charactersMinStruct.length > 0) {
      const message: WsGatewayGameLoopStateMessage = {
        gameId: payload.gameId,
        charactersMinStruct: payload.charactersMinStruct,
      };
      this.wsGatewayService.emit(WsGatewayGameLoopStatePattern, message);
    }
  }

  @OnEvent(EventGameGameState.EventName)
  handleEventGameGameState(payload: EventGameGameState) {
    const message: WsGatewayGameGameStateMessage = {
      gameId: payload.gameId,
      gameState: payload.gameState,
    };
    this.wsGatewayService.emit(WsGatewayGameGameStatePattern, message);
  }

  // ----------------------------------------------
  // Common
  // ----------------------------------------------

  // @Cron(CronExpression.EVERY_5_SECONDS)
  dropDisconnectedUsers() {
    const now = Date.now();
    const usersToDrop = [];

    this.userLastRequestTime.forEach((value, key) => {
      if (now - value > this.userDisconnectTimeout) {
        usersToDrop.push(key);
      }
    });

    usersToDrop.forEach((key) => {
      this.userLastRequestTime.delete(key);
      this.deleteUser(key, 'drop');
    });
  }

  private deleteUser(userId: string, deleteType: string) {
    if (GameplayService.ConnectedUsers.has(userId)) {
      GameplayService.ConnectedUsers.delete(userId);
      const gameInstance = this.checkAndGetGameInstance(
        this.userGameInstance.get(userId),
        `${deleteType} ${userId}`,
      );
      if (gameInstance) {
        gameInstance.deletePlayer(userId);
        this.userGameInstance.delete(userId);
      } else {
        Logger.error('User ' + userId + ' is not in the game, unable to drop');
      }
    } else {
      Logger.error('User ' + userId + ' is not connected, unable to drop');
    }
  }
}
