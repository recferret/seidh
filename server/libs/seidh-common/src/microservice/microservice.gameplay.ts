import { Inject, Injectable } from '@nestjs/common';
import { ClientProxy } from '@nestjs/microservices';
import { ServiceName } from '../seidh-common.internal-protocol';
import { firstValueFrom } from 'rxjs';
import {
  GameplayLobbyFindGameServiceRequest,
  GameplayLobbyFindGameServiceResponse,
  GameplayLobbyFindGamePattern,
} from '../dto/gameplay-lobby/gameplay-lobby.find.game.msg';

@Injectable()
export class MicroserviceGameplay {
  constructor(
    @Inject(ServiceName.GameplayLobby)
    private gameplayLobbyService: ClientProxy,
  ) {}

  async findGame(request: GameplayLobbyFindGameServiceRequest) {
    const response: GameplayLobbyFindGameServiceResponse = await firstValueFrom(
      this.gameplayLobbyService.send(GameplayLobbyFindGamePattern, request),
    );
    return response;
  }
}
