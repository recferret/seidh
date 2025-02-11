import { Inject, Injectable } from '@nestjs/common';
import { ClientProxy } from '@nestjs/microservices';

import { MicroserviceWrapper } from './microservice.utils';

import {
  UsersServiceGetFriendsPattern,
  UsersServiceGetFriendsRequest,
  UsersServiceGetFriendsResponse,
} from '../dto/users/users.get-friends.msg';

import { ServiceName } from '../seidh-common.internal-protocol';

@Injectable()
export class MicroserviceFriends {
  private readonly microserviceWrapper: MicroserviceWrapper;

  constructor(@Inject(ServiceName.Users) usersService: ClientProxy) {
    this.microserviceWrapper = new MicroserviceWrapper(usersService);
  }

  async getFriends(request: UsersServiceGetFriendsRequest) {
    return this.microserviceWrapper.request<UsersServiceGetFriendsRequest, UsersServiceGetFriendsResponse>(
      UsersServiceGetFriendsPattern,
      request,
    );
  }
}
