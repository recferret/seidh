import { Game, GameDocument } from '@lib/seidh-common/schemas/game/schema.game';
import { GameConfig } from '@lib/seidh-common/schemas/game/schema.game-config';
import { Model } from 'mongoose';

import { Injectable, Logger, OnModuleInit } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Cron, CronExpression } from '@nestjs/schedule';

import { MicroserviceCharacters } from '@lib/seidh-common/microservice/microservice.characters';
import { MicroserviceUsers } from '@lib/seidh-common/microservice/microservice.users';

import {
  GameServiceFinishGameRequest,
  GameServiceFinishGameResponse,
} from '@lib/seidh-common/dto/game/game.finish-game.msg';
import { GameServiceGetGameConfigResponse } from '@lib/seidh-common/dto/game/game.get-game-config.msg';
import {
  GameServiceProgressGameRequest,
  GameServiceProgressGameResponse,
} from '@lib/seidh-common/dto/game/game.progress-game.msg';
import {
  GameServiceStartGameRequest,
  GameServiceStartGameResponse,
} from '@lib/seidh-common/dto/game/game.start-game.msg';

import { GameFinishReason, GameState, GameType } from '@lib/seidh-common/types/types.game';
import { BalanceOperationType, BalanceUpdateReason } from '@lib/seidh-common/types/types.user';

// ONLY SINGLE PLAYER LOGIC HERE

interface CachedGame {
  lastUpdateTime: number;
  userId: string;
  userZombieKills: number;
  userCoinsGained: number;
}

@Injectable()
export class GameService implements OnModuleInit {
  private gameConfig: GameServiceGetGameConfigResponse;

  private cachedGames = new Map<string, CachedGame>();

  constructor(
    private microserviceUsers: MicroserviceUsers,
    private microserviceCharacters: MicroserviceCharacters,
    @InjectModel(Game.name)
    private gameModel: Model<Game>,
    @InjectModel(GameConfig.name)
    private gameConfigModel: Model<GameConfig>,
  ) {}

  async onModuleInit() {
    // Mobs spawn
    const mobsMaxAtTheSameTime = 100;
    const mobsMaxPerGame = 500;
    const mobSpawnDelayMs = 2500;

    const gameConfig = await this.gameConfigModel.find();
    if (!gameConfig || gameConfig.length == 0) {
      await this.gameConfigModel.create({
        // Mobs spawn
        mobsMaxAtTheSameTime,
        mobsMaxPerGame,
        mobSpawnDelayMs,
      });
    }

    this.gameConfig = {
      success: true,

      // Mobs spawn
      mobsMaxAtTheSameTime,
      mobsMaxPerGame,
      mobSpawnDelayMs,
    };

    await this.finishExistingGames(GameFinishReason.Timeout);
  }

  @Cron(CronExpression.EVERY_10_SECONDS)
  async finishOutdatedGames() {
    await this.finishExistingGames(GameFinishReason.Timeout);
  }

  async getGameConfig() {
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
        const chachedGame = this.cachedGames.get(existingGame.id);

        if (chachedGame) {
          await this.finishExistingGame(
            existingGame,
            GameFinishReason.Closed,
            request.userId,
            chachedGame.userZombieKills,
            chachedGame.userCoinsGained,
          );
        } else {
          Logger.error({
            msg: 'GameService startGame, no chachedGame, finish without gainings',
            request,
          });
          await this.finishExistingGame(existingGame, GameFinishReason.Closed, request.userId, 0, 0);
        }
      }

      const game = await this.gameModel.create({
        type: GameType.Single,
        userIds: [request.userId],
        userGainings: {},
      });

      if (game) {
        this.cachedGames.set(game.id, {
          lastUpdateTime: Date.now(),
          userId: request.userId,
          userZombieKills: 0,
          userCoinsGained: 0,
        });

        response.success = true;
        response.gameId = game.id;
      } else {
        return response;
      }
    } catch (error) {
      Logger.error(
        {
          msg: 'GameService startGame error',
          request,
        },
        error,
      );
    }

    return response;
  }

  async progressGame(request: GameServiceProgressGameRequest) {
    const response: GameServiceProgressGameResponse = {
      success: false,
    };

    try {
      const cachedGame = this.cachedGames.get(request.gameId);

      // TODO add log

      if (cachedGame) {
        cachedGame.lastUpdateTime = Date.now();
        cachedGame.userZombieKills += request.zombiesKilled;
        cachedGame.userCoinsGained += request.coinsGained;
        response.success = true;
      } else {
        Logger.error({
          msg: 'GameService progressGame error, no such cached game',
          request,
        });
      }
    } catch (error) {
      Logger.error(
        {
          msg: 'GameService progressGame error',
          request,
        },
        error,
      );
    }

    return response;
  }

  async finishGame(request: GameServiceFinishGameRequest) {
    const response: GameServiceFinishGameResponse = {
      success: false,
    };

    try {
      const game = await this.gameModel.findById(request.gameId);
      const gameFinished = await this.finishExistingGame(
        game,
        request.reason,
        request.userId,
        request.zombiesKilled,
        request.coinsGained,
      );
      this.cachedGames.delete(request.gameId);
      response.success = gameFinished;
      if (!response.success) {
        Logger.error({
          msg: 'GameService finishGame error, unable to finish',
          request,
        });
      }
    } catch (error) {
      Logger.error(
        {
          msg: 'GameService finishGame error',
          request,
        },
        error,
      );
    }

    return response;
  }

  private async finishGameForUser(gameId: string, userId: string, zombiesKilled: number, coinsGained: number) {
    if (zombiesKilled > 0) {
      const addExpResponse = await this.microserviceCharacters.addExp({
        userId,
        gameId,
        zombiesKilled,
      });

      if (!addExpResponse.success) {
        Logger.error({
          msg: 'GameService finishGame error, unable to add exp',
          request: {
            userId,
            gameId,
            zombiesKilled,
          },
        });
        return false;
      }

      const updateKillsResponse = await this.microserviceUsers.updateKills({
        userId,
        zombiesKilled,
      });

      if (!updateKillsResponse.success) {
        Logger.error({
          msg: 'GameService finishGame error, unable to update kills',
          request: {
            userId,
            gameId,
            zombiesKilled,
          },
        });
        return false;
      }
    }

    if (coinsGained > 0) {
      const updateBalanceResponse = await this.microserviceUsers.updateBalance({
        userId,
        operation: BalanceOperationType.ADD,
        reason: BalanceUpdateReason.GAME_FINISH,
        coins: coinsGained,
      });

      if (!updateBalanceResponse.success) {
        Logger.error({
          msg: 'GameService finishGame error, unable to update balance',
          request: {
            userId,
            gameId,
            operation: BalanceOperationType.ADD,
            reason: BalanceUpdateReason.GAME_FINISH,
            coins: coinsGained,
          },
        });
        return false;
      }
    }

    return true;
  }

  private async finishExistingGame(
    game: GameDocument,
    reason: GameFinishReason,
    userId: string,
    zombiesKilled: number,
    coinsGained: number,
  ) {
    if (game && game.state == GameState.Playing) {
      const finishedForUser = await this.finishGameForUser(game.id, userId, zombiesKilled, coinsGained);
      if (finishedForUser) {
        game.state = GameState.Finished;
        game.finishReason = reason;
        game.userGainings.set(userId, {
          zombiesKilled,
          coinsGained,
        });
        await game.save();
        return true;
      } else {
        return false;
      }
    }
  }

  private async finishExistingGames(reason: GameFinishReason) {
    const existingGames = await this.gameModel.find({
      type: GameType.Single,
      state: GameState.Playing,
    });

    if (existingGames) {
      for (const existingGame of existingGames) {
        const cachedGame = this.cachedGames.get(existingGame.id);
        if (cachedGame && cachedGame.lastUpdateTime + 10000 < Date.now()) {
          await this.finishExistingGame(
            existingGame,
            reason,
            cachedGame.userId,
            cachedGame.userZombieKills,
            cachedGame.userCoinsGained,
          );
        }
      }
    }
  }
}
