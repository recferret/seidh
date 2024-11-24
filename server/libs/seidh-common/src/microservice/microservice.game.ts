import { Inject, Injectable } from '@nestjs/common';
import { ClientProxy } from '@nestjs/microservices';
import { ServiceName } from '../seidh-common.internal-protocol';
import { firstValueFrom } from 'rxjs';
import {
  GameServiceGetGameConfigPattern,
  GameServiceGetGameConfigGameRequest,
  GameServiceGetGameConfigResponse,
} from '../dto/game/game.get-game-config.msg';
import {
  GameServiceStartGamePattern,
  GameServiceStartGameRequest,
  GameServiceStartGameResponse,
} from '../dto/game/game.start-game.msg';
import {
  GameServiceProgressGamePattern,
  GameServiceProgressGameRequest,
  GameServiceProgressGameResponse,
} from '../dto/game/game.progress-game.msg';
import {
  GameServiceFinishGamePattern,
  GameServiceFinishGameRequest,
  GameServiceFinishGameResponse,
} from '../dto/game/game.finish-game.msg';

@Injectable()
export class MicroserviceGame {
  constructor(@Inject(ServiceName.Game) private gameService: ClientProxy) {}

  async getGameConfig(request: GameServiceGetGameConfigGameRequest) {
    const response: GameServiceGetGameConfigResponse = await firstValueFrom(
      this.gameService.send(GameServiceGetGameConfigPattern, request),
    );
    return response;
  }

  async startGame(request: GameServiceStartGameRequest) {
    const response: GameServiceStartGameResponse = await firstValueFrom(
      this.gameService.send(GameServiceStartGamePattern, request),
    );
    return response;
  }

  async progressGame(request: GameServiceProgressGameRequest) {
    const response: GameServiceProgressGameResponse = await firstValueFrom(
      this.gameService.send(GameServiceProgressGamePattern, request),
    );
    return response;
  }

  async finishGame(request: GameServiceFinishGameRequest) {
    const response: GameServiceFinishGameResponse = await firstValueFrom(
      this.gameService.send(GameServiceFinishGamePattern, request),
    );
    return response;
  }
}
