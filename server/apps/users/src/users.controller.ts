import { Controller } from '@nestjs/common';
import { MessagePattern } from '@nestjs/microservices';
import { UsersService } from './users.service';
import {
  UsersAuthenticateMessageRequest,
  UsersAuthenticatePattern,
} from '@app/seidh-common/dto/users/users.authenticate.msg';
import {
  UsersCheckTokenMessageRequest,
  UsersCheckTokenPattern,
} from '@app/seidh-common/dto/users/users.check.token.msg';
import {
  UsersGetFriendsMessageRequest,
  UsersGetFriendsPattern,
} from '@app/seidh-common/dto/users/users.get.friends.msg';
import {
  UsersGetUserMessageRequest,
  UsersGetUserPattern,
} from '@app/seidh-common/dto/users/users.get.user.msg';

@Controller()
export class UsersController {
  constructor(private readonly usersService: UsersService) {}

  @MessagePattern(UsersAuthenticatePattern)
  async authenticate(message: UsersAuthenticateMessageRequest) {
    return this.usersService.authenticate(message);
  }

  @MessagePattern(UsersCheckTokenPattern)
  async checkAuthToken(message: UsersCheckTokenMessageRequest) {
    return this.usersService.checkToken(message);
  }

  @MessagePattern(UsersGetUserPattern)
  async getUser(message: UsersGetUserMessageRequest) {
    return this.usersService.getUser(message);
  }

  @MessagePattern(UsersGetFriendsPattern)
  async getFriends(message: UsersGetFriendsMessageRequest) {
    return this.usersService.getFriends(message);
  }
}
