import { Controller } from '@nestjs/common';
import { MessagePattern } from '@nestjs/microservices';

import { ServiceFriends } from '../../services/service.friends';

import {
  UsersServiceGetFriendsPattern,
  UsersServiceGetFriendsRequest,
} from '@lib/seidh-common/dto/users/users.get-friends.msg';

@Controller()
export class ControllerFriends {
  constructor(private readonly serviceFriends: ServiceFriends) {}

  @MessagePattern(UsersServiceGetFriendsPattern)
  async getFriends(request: UsersServiceGetFriendsRequest) {
    return this.serviceFriends.getFriends(request);
  }
}
