import { Controller, Get } from '@nestjs/common';
import { UsersService } from './users.service';
import { UsersAuthenticateMessageRequest, UsersAuthenticatePattern } from '@app/seidh-common/dto/users/users.authenticate.msg';
import { MessagePattern } from '@nestjs/microservices';

@Controller()
export class UsersController {
  constructor(private readonly usersService: UsersService) {}

  @MessagePattern(UsersAuthenticatePattern)
  async authenticate(message: UsersAuthenticateMessageRequest) {
    return this.usersService.authenticate(message);
  }
}