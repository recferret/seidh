import { Controller, Get, Session, UseGuards } from '@nestjs/common';
import { AuthGuard } from '../guards/guard.auth';
import { IUserSession } from './interfaces';
import { ServiceUsers } from '../services/service.users';

@Controller('users')
export class ControllerUsers {
  constructor(private readonly serviceUsers: ServiceUsers) {}

  @Get()
  @UseGuards(AuthGuard)
  getUser(@Session() session: IUserSession) {
    return this.serviceUsers.getUser(session.userId);
  }
}
