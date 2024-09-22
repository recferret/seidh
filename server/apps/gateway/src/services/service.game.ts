import { Injectable, Logger } from '@nestjs/common';
import {
  GameFinishGameRequestDto,
  GameFinishGameResponseDto,
} from '../dto/game/game.finish.game.dto';
import { GameProgressGameRequestDto } from '../dto/game/game.progress.game.dto';
import { GameStartGameResponseDto } from '../dto/game/game.start.game.dto';
import { MicroserviceGame } from '@app/seidh-common/microservice/microservice.game';

@Injectable()
export class ServiceGame {
  constructor(private microserviceGame: MicroserviceGame) {}

  async startGame(userId: string) {
    const response = await this.microserviceGame.startGame({
      userId,
    });
    const responseDto: GameStartGameResponseDto = {
      success: response.success,
    };
    if (response.success) {
      responseDto.gameId = response.gameId;
    }
    return responseDto;
  }

  async progressGame(userId: string, req: GameProgressGameRequestDto) {
    Logger.log(userId, req);
  }

  async finishGame(userId: string, req: GameFinishGameRequestDto) {
    const response = await this.microserviceGame.finishGame({
      userId,
      gameId: req.gameId,
      reason: req.reason,
    });
    const responseDto: GameFinishGameResponseDto = {
      success: response.success,
    };
    return responseDto;
  }
}
