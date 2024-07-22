import { Inject, Injectable, OnModuleInit } from '@nestjs/common';
import { ServiceName } from '@app/seidh-common';
import { ClientProxy } from '@nestjs/microservices';
import { 
  GameplayLobbyFindGameMessageRequest, 
  GameplayLobbyFindGameMessageResponse, 
  GameplayLobbyFindGamePattern 
} from '@app/seidh-common/dto/gameplay-lobby/gameplay-lobby.find.game.msg';
import { firstValueFrom } from 'rxjs';
import { AuthenticateRequest, AuthenticateResponse } from './dto/authenticate.dto';
import { 
  UsersAuthenticateMessageRequest, 
  UsersAuthenticateMessageResponse, 
  UsersAuthenticatePattern 
} from '@app/seidh-common/dto/users/users.authenticate.msg';
import { 
  UsersGetFriendsMessageRequest, 
  UsersGetFriendsMessageResponse, 
  UsersGetFriendsPattern 
} from '@app/seidh-common/dto/users/users.get.friends.msg';
import { GetFriendsResponse } from './dto/friends.dto';


@Injectable()
export class GatewayService implements OnModuleInit {
  
  constructor(
    @Inject(ServiceName.GameplayLobby) private gameplayLobbyService: ClientProxy,
    @Inject(ServiceName.Users) private usersService: ClientProxy
  ) { 
  }

  async onModuleInit() {
  }

  async findGame(userId: string) {
    const request: GameplayLobbyFindGameMessageRequest = {
      userId,
    };
    const response: GameplayLobbyFindGameMessageResponse = await firstValueFrom(this.gameplayLobbyService.send(GameplayLobbyFindGamePattern, request));
    return response;
  }

  async authenticate(authenticateRequest: AuthenticateRequest) {
    const request: UsersAuthenticateMessageRequest = {
      telegramInitData: authenticateRequest.telegramInitData,
      email: authenticateRequest.email,
      referrerId: authenticateRequest.referrerId,
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

  async getFriends(userId: string) {
    const request: UsersGetFriendsMessageRequest = {
      userId
    };
    const result: UsersGetFriendsMessageResponse = await firstValueFrom(this.usersService.send(UsersGetFriendsPattern, request));
    const response: GetFriendsResponse = {
      success: result.success,
      friends: result.friends,
    };
    return response;
  }

}
