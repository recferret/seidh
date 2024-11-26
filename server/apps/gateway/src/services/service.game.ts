import { Injectable, Logger } from '@nestjs/common';
import { GameServiceGetGameConfigResponseDto } from '../dto/game/game.get-game-config.dto';
import { GameServiceStartGameResponseDto } from '../dto/game/game.start-game.dto';
import { GameServiceProgressGameRequestDto } from '../dto/game/game.progress-game.dto';
import {
  GameServiceFinishGameRequestDto,
  GameServiceFinishGameResponseDto,
} from '../dto/game/game.finish-game.dto';
import { MicroserviceGame } from '@app/seidh-common/microservice/microservice.game';

@Injectable()
export class ServiceGame {
  constructor(private microserviceGame: MicroserviceGame) {}

  async getGameConfig() {
    const responseDto: GameServiceGetGameConfigResponseDto = {
      success: false,
    };

    try {
      const response = await this.microserviceGame.getGameConfig({});
      responseDto.success = response.success;

      if (response.success) {
        responseDto.mobsMaxPerGame = response.mobsMaxPerGame;
        responseDto.mobsMaxAtTheSameTime = response.mobsMaxAtTheSameTime;
        responseDto.mobSpawnDelayMs = response.mobSpawnDelayMs;

        // Exp boost
        responseDto.expLevel1Multiplier = response.expLevel1Multiplier;
        responseDto.expLevel2Multiplier = response.expLevel2Multiplier;
        responseDto.expLevel3Multiplier = response.expLevel3Multiplier;

        // Stats boost
        responseDto.statsLevel1Multiplier = response.statsLevel1Multiplier;
        responseDto.statsLevel2Multiplier = response.statsLevel2Multiplier;
        responseDto.statsLevel3Multiplier = response.statsLevel3Multiplier;

        // Wealth boost
        responseDto.wealthLevel1PickUpRangeMultiplier =
          response.wealthLevel1PickUpRangeMultiplier;
        responseDto.wealthLevel2PickUpRangeMultiplier =
          response.wealthLevel2PickUpRangeMultiplier;
        responseDto.wealthLevel3PickUpRangeMultiplier =
          response.wealthLevel3PickUpRangeMultiplier;

        responseDto.wealthLevel1CoinsMultiplier =
          response.wealthLevel1CoinsMultiplier;
        responseDto.wealthLevel2CoinsMultiplier =
          response.wealthLevel2CoinsMultiplier;
        responseDto.wealthLevel3CoinsMultiplier =
          response.wealthLevel3CoinsMultiplier;
      }
    } catch (error) {
      Logger.error({
        msg: 'Unable to get game config',
        error,
      });
    }

    return responseDto;
  }

  async startGame(userId: string) {
    const response = await this.microserviceGame.startGame({
      userId,
    });
    const responseDto: GameServiceStartGameResponseDto = {
      success: response.success,
    };
    if (response.success) {
      responseDto.gameId = response.gameId;
    }
    return responseDto;
  }

  async progressGame(userId: string, req: GameServiceProgressGameRequestDto) {
    Logger.log(userId, req);
  }

  async finishGame(userId: string, req: GameServiceFinishGameRequestDto) {
    const response = await this.microserviceGame.finishGame({
      userId,
      gameId: req.gameId,
      reason: req.reason,
    });
    const responseDto: GameServiceFinishGameResponseDto = {
      success: response.success,
    };
    return responseDto;
  }
}
