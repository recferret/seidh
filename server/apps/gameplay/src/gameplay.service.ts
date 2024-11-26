import { v4 as uuidv4 } from 'uuid';

import { Inject, Injectable, Logger } from '@nestjs/common';
import { ClientProxy } from '@nestjs/microservices';
import { Config } from './main';
import { GameInstance } from './game/game.instance';
import { ServiceName } from '@app/seidh-common';
import {
  GameplayLobbyGameInfo,
  GameplayLobbyUpdateGamesPattern,
  GameplayLobbyUpdateGamesServiceMessage,
} from '@app/seidh-common/dto/gameplay-lobby/gameplay-lobby.update.games.msg';
import { GameplayServiceJoinGameMessage } from '@app/seidh-common/dto/gameplay/gameplay.join-game.msg';
import { GameplayType } from '@app/seidh-common/dto/gameplay-lobby/gameplay-lobby.find.game.msg';
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
import { GameplayServiceInputMessage } from '@app/seidh-common/dto/gameplay/gameplay.input.msg';
import { GameplayServiceDisconnectedMessage } from '@app/seidh-common/dto/gameplay/gameplay.disconnected.msg';
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
  GameplayServiceCreateGameRequest,
  GameplayServiceCreateGameResponse,
} from '@app/seidh-common/dto/gameplay/gameplay.create-game.msg';
import { Cron, CronExpression } from '@nestjs/schedule';
import { EventGameUserGainings } from './events/event.game.user-gainings';
import {
  UsersUpdateGainingsServiceMessage,
  UsersUpdateGainingsPattern,
} from '@app/seidh-common/dto/users/users.update.gainings';
import { InjectQueue } from '@nestjs/bull';
import { Queue } from 'bull';

enum GameLogAction {
  ClientDisconnect = 'ClientDisconnect',
  ClientJoinGame = 'ClientJoinGame',
  ClientInput = 'ClientInput',
  ClientCreateGame = 'ClientCreateGame',
}

@Injectable()
export class GameplayService {
  public static readonly ConnectedUsers = new Set<string>();

  private readonly gameInstances = new Map<string, GameInstance>();

  private readonly userLastRequestTime = new Map<string, number>();
  private readonly userDisconnectTimeout = 5 * 1000;
  private readonly userGameInstance = new Map<string, string>();
  private readonly usersToInit = new Set<string>();

  constructor(
    private eventEmitter: EventEmitter2,
    @Inject(ServiceName.WsGateway)
    private wsGatewayService: ClientProxy,
    @Inject(ServiceName.GameplayLobby)
    private gameplayLobbyService: ClientProxy,
    @Inject(ServiceName.Users)
    private usersService: ClientProxy,
    @InjectQueue('gamelog') private gameLogQueue: Queue,
  ) {
    const id = uuidv4();
    this.gameInstances.set(
      id,
      new GameInstance(this.eventEmitter, id, GameplayType.TestGame),
    );
    Logger.log('GameplayService initialized', Config.GAMEPLAY_INSTANCE_ID);
  }

  // ----------------------------------------------
  // Client -> Server
  // ----------------------------------------------

  public disconnected(message: GameplayServiceDisconnectedMessage) {
    this.deleteUser(message.userId, 'disconnected');

    // TODO add reason
    this.gameLog(GameLogAction.ClientDisconnect, {
      userId: message.userId,
    });
  }

  public joinGame(message: GameplayServiceJoinGameMessage) {
    const gameInstance = this.gameInstances.get(message.gameId);
    if (gameInstance) {
      this.userLastRequestTime.set(message.userId, Date.now());
      this.userGameInstance.set(message.userId, gameInstance.gameId);
      this.usersToInit.add(message.userId);
      gameInstance.addPlayer(message.userId);
      GameplayService.ConnectedUsers.add(message.userId);

      Logger.log(`User ${message.userId} has joined ${gameInstance.gameId}`);

      this.gameLog(GameLogAction.ClientJoinGame, message);
    } else {
      Logger.error(`Join game failed for user ${message.userId} `);
    }
  }

  public input(message: GameplayServiceInputMessage) {
    this.userLastRequestTime.set(message.userId, Date.now());
    this.checkUserConnected(message.userId);
    const gameInstance = this.checkAndGetGameInstance(message.gameId);
    gameInstance.input({
      userId: message.userId,
      index: message.index,
      actionType: message.actionType,
      movAngle: message.movAngle,
    });
    this.gameLog(GameLogAction.ClientInput, message);
  }

  public createGame(message: GameplayServiceCreateGameRequest) {
    const instanceId = uuidv4();
    this.gameInstances.set(
      instanceId,
      new GameInstance(this.eventEmitter, instanceId, message.gameplayType),
    );
    this.gameLog(GameLogAction.ClientCreateGame, message);
    const response: GameplayServiceCreateGameResponse = {
      success: true,
      gameId: instanceId,
      gameplayServiceId: Config.GAMEPLAY_INSTANCE_ID,
    };
    return response;
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

  @OnEvent(EventGameUserGainings.EventName)
  handleEventGameUserGainings(payload: EventGameUserGainings) {
    const message: UsersUpdateGainingsServiceMessage = {
      userGainings: payload.userGainings,
    };
    this.usersService.emit(UsersUpdateGainingsPattern, message);
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

  @Cron(CronExpression.EVERY_SECOND)
  notifyLobbyService() {
    const games: GameplayLobbyGameInfo[] = [];

    this.gameInstances.forEach((gameInstance) => {
      games.push({
        gameId: gameInstance.gameId,
        gameplayType: gameInstance.gameplayType,
        lastDt: gameInstance.getLastDt(),
        users: gameInstance.getPlayersCount(),
        mobs: gameInstance.getMobsCount(),
      });
    });

    const message: GameplayLobbyUpdateGamesServiceMessage = {
      gameplayServiceId: Config.GAMEPLAY_INSTANCE_ID,
      games,
    };
    this.gameplayLobbyService.emit(GameplayLobbyUpdateGamesPattern, message);
  }

  @Cron(CronExpression.EVERY_10_SECONDS)
  dropEmptyGames() {
    const gamesToDrop: string[] = [];
    this.gameInstances.forEach((gameInstance) => {
      if (
        gameInstance.getPlayersCount() == 0 &&
        gameInstance.gameplayType != GameplayType.TestGame
      ) {
        gamesToDrop.push(gameInstance.gameId);
      }
    });
    gamesToDrop.forEach((gameId) => {
      this.gameInstances.delete(gameId);
    });
  }

  // TODO implement pings and uncomment
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

  private async gameLog(gameLogAction: GameLogAction, params: any) {
    await this.gameLogQueue.add({
      action: gameLogAction,
      params,
    });
  }
}
