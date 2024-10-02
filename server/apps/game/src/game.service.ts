import {
  GameFinishGameServiceRequest,
  GameFinishGameServiceResponse,
} from '@app/seidh-common/dto/game/game.finish.game.msg';
import {
  GameProgressGameServiceRequest,
  GameProgressGameServiceResponse,
} from '@app/seidh-common/dto/game/game.progress.game.msg';
import {
  GameStartGameServiceRequest,
  GameStartGameServiceResponse,
} from '@app/seidh-common/dto/game/game.start.game.msg';
import { MicroserviceUser } from '@app/seidh-common/microservice/microservice.user';
import {
  Game,
  GameDocument,
  GameFinishReason,
  GameGainings,
  GameState,
  GameType,
} from '@app/seidh-common/schemas/game/schema.game';
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
  private readonly maxMobs = 120;
  private readonly gameProgressByPlayerCache = new Map<string, IGameProgress>();

  constructor(
    private microserviceUser: MicroserviceUser,
    @InjectModel(Game.name) private gameModel: Model<Game>,
    @InjectModel(GameProgress.name)
    private gameProgressModel: Model<GameProgress>,
  ) {}

  async onModuleInit() {
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

  async startGame(request: GameStartGameServiceRequest) {
    const response: GameStartGameServiceResponse = {
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

  async progressGame(request: GameProgressGameServiceRequest) {
    const response: GameProgressGameServiceResponse = {
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
      if (gameProgressCache.mobsSpawned + request.mobsSpawned < this.maxMobs) {
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

  async finishGame(request: GameFinishGameServiceRequest) {
    const response: GameFinishGameServiceResponse = {
      success: false,
    };

    const existingGame = await this.gameModel.findById(request.gameId);
    const gameProgressCache = this.gameProgressByPlayerCache.get(
      request.userId,
    );

    if (existingGame && gameProgressCache) {
      if (
        request.reason == GameFinishReason.Win &&
        gameProgressCache.mobsSpawned == this.maxMobs &&
        gameProgressCache.mobsKilled == this.maxMobs
      ) {
        gameProgressCache.mobsKilled == this.maxMobs;
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
      await this.microserviceUser.updateGainings({
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
