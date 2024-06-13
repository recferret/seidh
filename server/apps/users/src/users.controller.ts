import { Controller } from '@nestjs/common';
import { UsersService } from './users.service';
import { UsersAuthenticateMessageRequest, UsersAuthenticatePattern } from '@app/seidh-common/dto/users/users.authenticate.msg';
import { MessagePattern } from '@nestjs/microservices';
import { UsersGetFriendsMessageRequest, UsersGetFriendsPattern } from '@app/seidh-common/dto/users/users.get.friends.msg';

@Controller()
export class UsersController {
  constructor(private readonly usersService: UsersService) {}

  @MessagePattern(UsersAuthenticatePattern)
  async authenticate(message: UsersAuthenticateMessageRequest) {
    return this.usersService.authenticate(message);
  }

  @MessagePattern(UsersGetFriendsPattern)
  async getFriends(message: UsersGetFriendsMessageRequest) {
    return this.usersService.getFriends(message);
  }
}