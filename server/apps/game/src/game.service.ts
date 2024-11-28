import {
  GameServiceFinishGameRequest,
  GameServiceFinishGameResponse,
} from '@app/seidh-common/dto/game/game.finish-game.msg';
import {
  GameServiceGetGameConfigGameRequest,
  GameServiceGetGameConfigResponse,
} from '@app/seidh-common/dto/game/game.get-game-config.msg';
import {
  GameServiceProgressGameRequest,
  GameServiceProgressGameResponse,
} from '@app/seidh-common/dto/game/game.progress-game.msg';
import {
  GameServiceStartGameRequest,
  GameServiceStartGameResponse,
} from '@app/seidh-common/dto/game/game.start-game.msg';
import { MicroserviceUsers } from '@app/seidh-common/microservice/microservice.users';
import {
  Game,
  GameDocument,
  GameFinishReason,
  GameGainings,
  GameState,
  GameType,
} from '@app/seidh-common/schemas/game/schema.game';
import { GameConfig } from '@app/seidh-common/schemas/game/schema.game-config';
import { GameProgress } from '@app/seidh-common/schemas/game/schema.game-progress';
import { Injectable, Logger, OnModuleInit } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Cron, CronExpression } from '@nestjs/schedule';
import { Model } from 'mongoose';

interface IGameProgress {
  gameId: string;
  userId: string;
  mobsSpawned: number;
  mobsKilled: number;
  tokensGained: number;
  lastUpdateTime: number;
}

@Injectable()
export class GameService implements OnModuleInit {
  private readonly gameProgressByPlayerCache = new Map<string, IGameProgress>();

  private gameConfig: GameServiceGetGameConfigResponse;

  constructor(
    private microserviceUsers: MicroserviceUsers,
    @InjectModel(Game.name)
    private gameModel: Model<Game>,
    @InjectModel(GameProgress.name)
    private gameProgressModel: Model<GameProgress>,
    @InjectModel(GameConfig.name)
    private gameConfigModel: Model<GameConfig>,
  ) {}

  async onModuleInit() {
    // Mobs spawn
    const mobsMaxAtTheSameTime = 100;
    const mobsMaxPerGame = 500;
    const mobSpawnDelayMs = 2500;

    // TODO move to boosts MS
    // Exp boost
    const expLevel1Multiplier = 1.5;
    const expLevel2Multiplier = 2;
    const expLevel3Multiplier = 3;

    // Stats boost
    const statsLevel1Multiplier = 1.2;
    const statsLevel2Multiplier = 1.5;
    const statsLevel3Multiplier = 2;

    // Wealth boost
    const wealthLevel1PickUpRangeMultiplier = 1.2;
    const wealthLevel2PickUpRangeMultiplier = 2;
    const wealthLevel3PickUpRangeMultiplier = 2.5;

    const wealthLevel1CoinsMultiplier = 2;
    const wealthLevel2CoinsMultiplier = 3;
    const wealthLevel3CoinsMultiplier = 4;

    const gameConfig = await this.gameConfigModel.find();
    if (!gameConfig || gameConfig.length == 0) {
      await this.gameConfigModel.create({
        // Mobs spawn
        mobsMaxAtTheSameTime,
        mobsMaxPerGame,
        mobSpawnDelayMs,

        // Exp boost
        expLevel1Multiplier,
        expLevel2Multiplier,
        expLevel3Multiplier,

        // Stats boost
        statsLevel1Multiplier,
        statsLevel2Multiplier,
        statsLevel3Multiplier,

        // Wealth boost
        wealthLevel1PickUpRangeMultiplier,
        wealthLevel2PickUpRangeMultiplier,
        wealthLevel3PickUpRangeMultiplier,

        wealthLevel1CoinsMultiplier,
        wealthLevel2CoinsMultiplier,
        wealthLevel3CoinsMultiplier,
      });
    }

    this.gameConfig = {
      success: true,

      // Mobs spawn
      mobsMaxAtTheSameTime,
      mobsMaxPerGame,
      mobSpawnDelayMs,

      // Exp boost
      expLevel1Multiplier,
      expLevel2Multiplier,
      expLevel3Multiplier,

      // Stats boost
      statsLevel1Multiplier,
      statsLevel2Multiplier,
      statsLevel3Multiplier,

      // Wealth boost
      wealthLevel1PickUpRangeMultiplier,
      wealthLevel2PickUpRangeMultiplier,
      wealthLevel3PickUpRangeMultiplier,

      wealthLevel1CoinsMultiplier,
      wealthLevel2CoinsMultiplier,
      wealthLevel3CoinsMultiplier,
    };

    const existingGames = await this.gameModel.find({
      type: GameType.Single,
      state: GameState.Playing,
    });

    if (existingGames && existingGames.length > 0) {
      for (const existingGame of existingGames) {
        await this.finishExistingGame(existingGame, GameFinishReason.Timeout);
      }
    }
  }

  // eslint-disable-next-line @typescript-eslint/no-unused-vars
  async getGameConfig(request: GameServiceGetGameConfigGameRequest) {
    return this.gameConfig;
  }

  async startGame(request: GameServiceStartGameRequest) {
    const response: GameServiceStartGameResponse = {
      success: false,
    };

    try {
      const existingGame = await this.gameModel.findOne({
        type: GameType.Single,
        state: GameState.Playing,
        userIds: [request.userId],
      });

      if (existingGame) {
        await this.finishExistingGame(existingGame, GameFinishReason.Closed);
      }

      const game = await this.gameModel.create({
        type: GameType.Single,
        userIds: [request.userId],
      });

      if (game) {
        this.gameProgressByPlayerCache.set(request.userId, {
          gameId: game.id,
          userId: request.userId,
          mobsSpawned: 0,
          mobsKilled: 0,
          tokensGained: 0,
          lastUpdateTime: Date.now(),
        });

        response.success = true;
        response.gameId = game.id;
      } else {
        return response;
      }
    } catch (error) {
      Logger.error({
        msg: 'GameService startGame error',
        request,
        error,
      });
    }

    return response;
  }

  async progressGame(request: GameServiceProgressGameRequest) {
    const response: GameServiceProgressGameResponse = {
      success: false,
    };

    const existingGame = await this.gameModel.findById(request.gameId);
    const gameProgressCache = this.gameProgressByPlayerCache.get(
      request.userId,
    );
    gameProgressCache.lastUpdateTime = Date.now();

    if (existingGame && gameProgressCache) {
      let logicErrorString = undefined;

      // Check total mobs spawned
      if (
        gameProgressCache.mobsSpawned + request.mobsSpawned <
        this.gameConfig.mobsMaxAtTheSameTime
      ) {
        gameProgressCache.mobsSpawned += request.mobsSpawned;

        // Check mobs killed
        if (
          gameProgressCache.mobsKilled + request.mobsKilled <
          gameProgressCache.mobsSpawned
        ) {
          gameProgressCache.mobsKilled += request.mobsKilled;

          // Check tokens gained
          if (
            gameProgressCache.tokensGained + request.tokensGained <=
            gameProgressCache.mobsSpawned
          ) {
            gameProgressCache.tokensGained += request.tokensGained;
          } else {
            logicErrorString = 'progressGame, update tokens gained error';
          }
        } else {
          logicErrorString = 'progressGame, update mobs killed error';
        }
      } else {
        logicErrorString = 'progressGame, update mobs spawned error';
      }

      if (logicErrorString) {
        Logger.error({
          msg: logicErrorString,
          gameProgressCache,
          request,
        });
      } else {
        const gameProgress = await this.gameProgressModel.create({
          userId: request.userId,
          gameId: request.gameId,
          mobsSpawned: request.mobsSpawned,
          mobsKilled: request.mobsKilled,
          tokensGained: request.tokensGained,
        });

        existingGame.gameProgress.push(gameProgress._id);
        existingGame.userGainings.set(request.userId, {
          kills: gameProgressCache.mobsKilled,
          tokens: gameProgressCache.tokensGained,
        } as GameGainings);

        await existingGame.save();

        response.success = true;
      }
    }

    return response;
  }

  async finishGame(request: GameServiceFinishGameRequest) {
    const response: GameServiceFinishGameResponse = {
      success: false,
    };

    const existingGame = await this.gameModel.findById(request.gameId);
    const gameProgressCache = this.gameProgressByPlayerCache.get(
      request.userId,
    );

    if (existingGame && gameProgressCache) {
      if (
        request.reason == GameFinishReason.Win &&
        gameProgressCache.mobsSpawned == this.gameConfig.mobsMaxAtTheSameTime &&
        gameProgressCache.mobsKilled == this.gameConfig.mobsMaxAtTheSameTime
      ) {
        gameProgressCache.mobsKilled == this.gameConfig.mobsMaxAtTheSameTime;
      }

      await this.finishExistingGame(existingGame, request.reason);
    }

    this.gameProgressByPlayerCache.delete(request.userId);

    return response;
  }

  @Cron(CronExpression.EVERY_10_SECONDS)
  async finishOutdatedGames() {
    const now = Date.now();
    const outdatedGames: IGameProgress[] = [];

    this.gameProgressByPlayerCache.forEach((v) => {
      if (v.lastUpdateTime < now) {
        outdatedGames.push(v);
      }
    });

    for (const outdatedGame of outdatedGames) {
      const existingGame = await this.gameModel.findById(outdatedGame.gameId);
      await this.finishExistingGame(existingGame, GameFinishReason.Timeout);

      this.gameProgressByPlayerCache.delete(outdatedGame.userId);
    }
  }

  private async finishExistingGame(
    game: GameDocument,
    reason: GameFinishReason,
  ) {
    game.state = GameState.Finished;
    game.finishReason = reason;
    await game.save();

    if (game.userGainings.size > 0) {
      await this.microserviceUsers.updateGainings({
        userGainings: {
          userId: game.userIds[0],
          gameId: game.id,
          kills: game.userGainings.get(game.userIds[0]).kills,
          tokens: game.userGainings.get(game.userIds[0]).tokens,
        },
      });
    }
  }
}
