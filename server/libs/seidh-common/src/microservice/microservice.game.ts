import { Inject, Injectable } from '@nestjs/common';
import { ClientProxy } from '@nestjs/microservices';
import { ServiceName } from '../seidh-common.internal-protocol';
import { firstValueFrom } from 'rxjs';
import {
  GameStartGamePattern,
  GameStartGameServiceRequest,
  GameStartGameServiceResponse,
} from '../dto/game/game.start.game.msg';
import {
  GameFinishGamePattern,
  GameFinishGameServiceRequest,
  GameFinishGameServiceResponse,
} from '../dto/game/game.finish.game.msg';
import {
  GameProgressGamePattern,
  GameProgressGameServiceRequest,
  GameProgressGameServiceResponse,
} from '../dto/game/game.progress.game.msg';

@Injectable()
export class MicroserviceGame {
  constructor(@Inject(ServiceName.Game) private gameService: ClientProxy) {}

  async startGame(request: GameStartGameServiceRequest) {
    const response: GameStartGameServiceResponse = await firstValueFrom(
      this.gameService.send(GameStartGamePattern, request),
    );
    return response;
  }

  async progressGame(request: GameProgressGameServiceRequest) {
    const response: GameProgressGameServiceResponse = await firstValueFrom(
      this.gameService.send(GameProgressGamePattern, request),
    );
    return response;
  }

  async finishGame(request: GameFinishGameServiceRequest) {
    const response: GameFinishGameServiceResponse = await firstValueFrom(
      this.gameService.send(GameFinishGamePattern, request),
    );
    return response;
  }
}
