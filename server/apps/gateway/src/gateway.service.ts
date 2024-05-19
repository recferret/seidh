import { Inject, Injectable } from '@nestjs/common';
import { FindGameRequest, FindGameResponse } from './dto/find.game.dto';
import { ServiceName } from '@app/seidh-common';
import { ClientProxy } from '@nestjs/microservices';
import { GameplayLobbyFindGamePattern } from '@app/seidh-common/dto/gameplay-lobby/gameplay-lobby.find.game.msg';
import { firstValueFrom } from 'rxjs';

@Injectable()
export class GatewayService {
  
  constructor(
    @Inject(ServiceName.GameplayLobby) private gameplayLobbyService: ClientProxy
  ) { }

  async findGame(findGameRequest: FindGameRequest) {
    const response: FindGameResponse = await firstValueFrom(this.gameplayLobbyService.send(GameplayLobbyFindGamePattern, findGameRequest));
    return response;
  }

}
