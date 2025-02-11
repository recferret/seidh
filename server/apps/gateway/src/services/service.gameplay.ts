import { Injectable } from '@nestjs/common';

import { MicroserviceGameplay } from '@lib/seidh-common/microservice/microservice.gameplay';

import { GameplayFindGameResponseDto } from '../dto/gameplay/gameplay.find.game.dto';
import { GameplayType } from '@lib/seidh-common/dto/gameplay-lobby/gameplay-lobby.find-game.msg';

@Injectable()
export class ServiceGameplay {
  constructor(private microserviceGameplay: MicroserviceGameplay) {}

  async findGame(userId: string, gameplayType: GameplayType) {
    const response = await this.microserviceGameplay.findGame({
      userId,
      gameplayType,
    });
    const responseDto: GameplayFindGameResponseDto = {
      success: response.success,
      reason: response.message,
      gameplayServiceId: response.gameplayServiceId,
      gameId: response.gameId,
    };
    return responseDto;
  }
}
