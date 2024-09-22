import { GameplayType } from '@app/seidh-common/dto/gameplay-lobby/gameplay-lobby.find.game.msg';
import { Injectable } from '@nestjs/common';
import { GameplayFindGameResponseDto } from '../dto/gameplay/gameplay.find.game.dto';
import { MicroserviceGameplay } from '@app/seidh-common/microservice/microservice.gameplay';

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
      reason: response.reason,
      gameplayServiceId: response.gameplayServiceId,
      gameId: response.gameId,
    };
    return responseDto;
  }
}
