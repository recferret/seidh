import { Controller } from '@nestjs/common';
import {
  UsersGetFriendsPattern,
  UsersGetFriendsServiceRequest,
} from '@app/seidh-common/dto/users/users.get.friends.msg';
import { MessagePattern } from '@nestjs/microservices';
import { ServiceFriends } from '../services/service.friends';

@Controller()
export class ControllerFriends {
  constructor(private readonly serviceFriends: ServiceFriends) {}

  @MessagePattern(UsersGetFriendsPattern)
  async getFriends(request: UsersGetFriendsServiceRequest) {
    return this.serviceFriends.getFriends(request);
  }
}
