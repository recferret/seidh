import { Inject, Injectable } from '@nestjs/common';
import { ClientProxy } from '@nestjs/microservices';

import { MicroserviceWrapper } from './microservice.utils';

import {
  GameplayServiceLobbyFindGamePattern,
  GameplayServiceLobbyFindGameRequest,
  GameplayServiceLobbyFindGameResponse,
} from '../dto/gameplay-lobby/gameplay-lobby.find-game.msg';

import { ServiceName } from '../seidh-common.internal-protocol';

@Injectable()
export class MicroserviceGameplay {
  private readonly microserviceWrapper: MicroserviceWrapper;

  constructor(@Inject(ServiceName.GameplayLobby) gameplayLobbyService: ClientProxy) {
    this.microserviceWrapper = new MicroserviceWrapper(gameplayLobbyService);
  }

  async findGame(request: GameplayServiceLobbyFindGameRequest) {
    return this.microserviceWrapper.request<GameplayServiceLobbyFindGameRequest, GameplayServiceLobbyFindGameResponse>(
      GameplayServiceLobbyFindGamePattern,
      request,
    );
  }
}
