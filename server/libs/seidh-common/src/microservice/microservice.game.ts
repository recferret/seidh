import { Inject, Injectable } from '@nestjs/common';
import { ClientProxy } from '@nestjs/microservices';

import { MicroserviceWrapper } from './microservice.utils';

import {
  GameServiceFinishGamePattern,
  GameServiceFinishGameRequest,
  GameServiceFinishGameResponse,
} from '../dto/game/game.finish-game.msg';
import {
  GameServiceGetGameConfigPattern,
  GameServiceGetGameConfigResponse,
} from '../dto/game/game.get-game-config.msg';
import {
  GameServiceProgressGamePattern,
  GameServiceProgressGameRequest,
  GameServiceProgressGameResponse,
} from '../dto/game/game.progress-game.msg';
import {
  GameServiceStartGamePattern,
  GameServiceStartGameRequest,
  GameServiceStartGameResponse,
} from '../dto/game/game.start-game.msg';

import { ServiceName } from '../seidh-common.internal-protocol';

@Injectable()
export class MicroserviceGame {
  private readonly microserviceWrapper: MicroserviceWrapper;

  constructor(@Inject(ServiceName.Game) gameService: ClientProxy) {
    this.microserviceWrapper = new MicroserviceWrapper(gameService);
  }

  async getGameConfig() {
    return this.microserviceWrapper.request<{}, GameServiceGetGameConfigResponse>(GameServiceGetGameConfigPattern, {});
  }

  async startGame(request: GameServiceStartGameRequest) {
    return this.microserviceWrapper.request<GameServiceStartGameRequest, GameServiceStartGameResponse>(
      GameServiceStartGamePattern,
      request,
    );
  }

  async progressGame(request: GameServiceProgressGameRequest) {
    return this.microserviceWrapper.request<GameServiceProgressGameRequest, GameServiceProgressGameResponse>(
      GameServiceProgressGamePattern,
      request,
    );
  }

  async finishGame(request: GameServiceFinishGameRequest) {
    return this.microserviceWrapper.request<GameServiceFinishGameRequest, GameServiceFinishGameResponse>(
      GameServiceFinishGamePattern,
      request,
    );
  }
}
