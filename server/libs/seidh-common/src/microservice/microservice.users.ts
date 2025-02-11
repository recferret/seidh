import { Inject, Injectable } from '@nestjs/common';
import { ClientProxy } from '@nestjs/microservices';

import { MicroserviceWrapper } from './microservice.utils';

import {
  UsersServiceAuthenticateResponse,
  UsersServiceSimpleAuthPattern,
  UsersServiceSimpleAuthRequest,
  UsersServiceTgAuthPattern,
  UsersServiceTgAuthRequest,
  UsersServiceVkAuthPattern,
  UsersServiceVkAuthRequest,
} from '../dto/users/users.authenticate.msg';
import {
  UsersServiceGetUserPattern,
  UsersServiceGetUserRequest,
  UsersServiceGetUserResponse,
} from '../dto/users/users.get-user.msg';
import {
  UsersServiceUpdateBalancePattern,
  UsersServiceUpdateBalanceRequest,
  UsersServiceUpdateBalanceResponse,
} from '../dto/users/users.update-balance.msg';
import {
  UsersServiceUpdateKillsPattern,
  UsersServiceUpdateKillsRequest,
  UsersServiceUpdateKillsResponse,
} from '../dto/users/users.update-kills.msg';

import { ServiceName } from '../seidh-common.internal-protocol';

@Injectable()
export class MicroserviceUsers {
  private readonly microserviceWrapper: MicroserviceWrapper;

  constructor(@Inject(ServiceName.Users) usersService: ClientProxy) {
    this.microserviceWrapper = new MicroserviceWrapper(usersService);
  }

  async tgAuth(request: UsersServiceTgAuthRequest) {
    return this.microserviceWrapper.request<UsersServiceTgAuthRequest, UsersServiceAuthenticateResponse>(
      UsersServiceTgAuthPattern,
      request,
    );
  }

  async vkAuth(request: UsersServiceVkAuthRequest) {
    return this.microserviceWrapper.request<UsersServiceVkAuthRequest, UsersServiceAuthenticateResponse>(
      UsersServiceVkAuthPattern,
      request,
    );
  }

  async simpleAuth(request: UsersServiceSimpleAuthRequest) {
    return this.microserviceWrapper.request<UsersServiceSimpleAuthRequest, UsersServiceAuthenticateResponse>(
      UsersServiceSimpleAuthPattern,
      request,
    );
  }

  async getUser(request: UsersServiceGetUserRequest) {
    return this.microserviceWrapper.request<UsersServiceGetUserRequest, UsersServiceGetUserResponse>(
      UsersServiceGetUserPattern,
      request,
    );
  }

  async updateKills(request: UsersServiceUpdateKillsRequest) {
    return this.microserviceWrapper.request<UsersServiceUpdateKillsRequest, UsersServiceUpdateKillsResponse>(
      UsersServiceUpdateKillsPattern,
      request,
    );
  }

  async updateBalance(request: UsersServiceUpdateBalanceRequest) {
    return this.microserviceWrapper.request<UsersServiceUpdateBalanceRequest, UsersServiceUpdateBalanceResponse>(
      UsersServiceUpdateBalancePattern,
      request,
    );
  }
}
