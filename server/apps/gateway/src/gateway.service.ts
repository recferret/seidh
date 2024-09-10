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
  AuthenticateRequestDTO,
  AuthenticateResponseDTO,
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
import { GetFriendsResponseDTO } from './dto/friends.dto';
import { GetBoostsResponseDTO } from './dto/boosts.get.dto';
import {
  UsersGetUserMessageRequest,
  UsersGetUserMessageResponse,
  UsersGetUserPattern,
} from '@app/seidh-common/dto/users/users.get.user.msg';
import {
  BoostsGetRequest,
  BoostsGetResponse,
  BoostsGetPattern,
} from '@app/seidh-common/dto/boost/boost.get.boosts.msg';
import {
  BoostsBuyPattern,
  BoostsBuyRequest,
  BoostsBuyResponse,
} from '@app/seidh-common/dto/boost/boost.buy.boosts.msg';

@Injectable()
export class GatewayService {
  constructor(
    @Inject(ServiceName.GameplayLobby)
    private gameplayLobbyService: ClientProxy,
    @Inject(ServiceName.Boost) private boostsService: ClientProxy,
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

  async authenticate(authenticateRequest: AuthenticateRequestDTO) {
    const request: UsersAuthenticateMessageRequest = {
      telegramInitData: authenticateRequest.telegramInitData,
      login: authenticateRequest.login,
      referrerId: authenticateRequest.referrerId,
    };
    const result: UsersAuthenticateMessageResponse = await firstValueFrom(
      this.usersService.send(UsersAuthenticatePattern, request),
    );
    const response: AuthenticateResponseDTO = {
      success: result.success,
      authToken: result.authToken,
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
    const response: GetFriendsResponseDTO = {
      success: result.success,
      friends: result.friends,
      friendsInvited: result.friendsInvited,
      virtualTokenBalance: result.virtualTokenBalance,
    };
    return response;
  }

  async getBoosts(userId: string) {
    const request: BoostsGetRequest = {
      userId,
    };
    const result: BoostsGetResponse = await firstValueFrom(
      this.boostsService.send(BoostsGetPattern, request),
    );
    const response: GetBoostsResponseDTO = {
      success: result.success,
      boosts: result.boosts,
    };
    return response;
  }

  async buyBoost(userId: string, boostId: string) {
    const request: BoostsBuyRequest = {
      userId,
      boostId,
    };
    const result: BoostsBuyResponse = await firstValueFrom(
      this.boostsService.send(BoostsBuyPattern, request),
    );
    const response: GetBoostsResponseDTO = {
      success: result.success,
      message: result.message,
      boosts: result.boosts,
    };
    return response;
  }
}
