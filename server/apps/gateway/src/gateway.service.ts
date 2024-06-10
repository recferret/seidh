import { Inject, Injectable } from '@nestjs/common';
import { FindGameRequest, FindGameResponse } from './dto/find.game.dto';
import { ServiceName } from '@app/seidh-common';
import { ClientProxy } from '@nestjs/microservices';
import { GameplayLobbyFindGamePattern } from '@app/seidh-common/dto/gameplay-lobby/gameplay-lobby.find.game.msg';
import { firstValueFrom } from 'rxjs';
import { AuthenticateRequest, AuthenticateResponse } from './dto/authenticate.dto';
import { 
  UsersAuthenticateMessageRequest, 
  UsersAuthenticateMessageResponse, 
  UsersAuthenticatePattern 
} from '@app/seidh-common/dto/users/users.authenticate.msg';

@Injectable()
export class GatewayService {
  
  constructor(
    @Inject(ServiceName.GameplayLobby) private gameplayLobbyService: ClientProxy,
    @Inject(ServiceName.Users) private usersService: ClientProxy
  ) { }

  async findGame(findGameRequest: FindGameRequest) {
    const response: FindGameResponse = await firstValueFrom(this.gameplayLobbyService.send(GameplayLobbyFindGamePattern, findGameRequest));
    return response;
  }

  async authenticate(authenticateRequest: AuthenticateRequest) {
    const request: UsersAuthenticateMessageRequest = {
      telegramInitData: authenticateRequest.telegramInitData,
      startParam: authenticateRequest.startParam,
    };
    const result: UsersAuthenticateMessageResponse = await firstValueFrom(this.usersService.send(UsersAuthenticatePattern, request));
    const response: AuthenticateResponse = {
      success: result.success,
      userId: result.userId,
      telegramName: result.telegramName,
      authToken: result.authToken,
      tokens: result.tokens,
      kills: result.kills,
      characters: result.characters
    };
    return response;
  }

}
