import { Inject, Injectable } from '@nestjs/common';
import { ServiceName } from '@app/seidh-common';
import { ClientProxy } from '@nestjs/microservices';
import {
  GameplayLobbyFindGameMessageRequest,
  GameplayLobbyFindGameMessageResponse,
  GameplayLobbyFindGamePattern,
  GameType,
} from '@app/seidh-common/dto/gameplay-lobby/gameplay-lobby.find.game.msg';
import { firstValueFrom } from 'rxjs';
import {
  AuthenticateRequest,
  AuthenticateResponse,
} from './dto/authenticate.dto';
import {
  UsersAuthenticateMessageRequest,
  UsersAuthenticateMessageResponse,
  UsersAuthenticatePattern,
} from '@app/seidh-common/dto/users/users.authenticate.msg';
import {
  UsersGetFriendsMessageRequest,
  UsersGetFriendsMessageResponse,
  UsersGetFriendsPattern,
} from '@app/seidh-common/dto/users/users.get.friends.msg';
import { GetFriendsResponse } from './dto/friends.dto';
import {
  UsersGetUserMessageRequest,
  UsersGetUserMessageResponse,
  UsersGetUserPattern,
} from '@app/seidh-common/dto/users/users.get.user.msg';

@Injectable()
export class GatewayService {
  constructor(
    @Inject(ServiceName.GameplayLobby)
    private gameplayLobbyService: ClientProxy,
    @Inject(ServiceName.Users) private usersService: ClientProxy,
  ) {}

  async findGame(userId: string, gameType: GameType) {
    const request: GameplayLobbyFindGameMessageRequest = {
      userId,
      gameType,
    };
    const response: GameplayLobbyFindGameMessageResponse = await firstValueFrom(
      this.gameplayLobbyService.send(GameplayLobbyFindGamePattern, request),
    );
    return response;
  }

  async getUser(userId: string) {
    const request: UsersGetUserMessageRequest = {
      userId,
    };
    const result: UsersGetUserMessageResponse = await firstValueFrom(
      this.usersService.send(UsersGetUserPattern, request),
    );
    return result;
  }

  async authenticate(authenticateRequest: AuthenticateRequest) {
    const request: UsersAuthenticateMessageRequest = {
      telegramInitData: authenticateRequest.telegramInitData,
      login: authenticateRequest.login,
      referrerId: authenticateRequest.referrerId,
    };
    const result: UsersAuthenticateMessageResponse = await firstValueFrom(
      this.usersService.send(UsersAuthenticatePattern, request),
    );
    const response: AuthenticateResponse = {
      success: result.success,
      userId: result.userId,
      telegramName: result.telegramName,
      authToken: result.authToken,
      tokens: result.tokens,
      kills: result.kills,
      characters: result.characters,
    };
    return response;
  }

  async getFriends(userId: string) {
    const request: UsersGetFriendsMessageRequest = {
      userId,
    };
    const result: UsersGetFriendsMessageResponse = await firstValueFrom(
      this.usersService.send(UsersGetFriendsPattern, request),
    );
    const response: GetFriendsResponse = {
      success: result.success,
      friends: result.friends,
      friendsInvited: result.friendsInvited,
      virtualTokenBalance: result.virtualTokenBalance,
    };
    return response;
  }
}
