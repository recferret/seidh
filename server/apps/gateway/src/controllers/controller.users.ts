import { Controller, Get, Session, UseGuards } from '@nestjs/common';

import { ServiceUsers } from '../services/service.users';

import { AuthGuard } from '../guards/guard.auth';

import { IUserSession } from './interfaces';

@Controller('users')
export class ControllerUsers {
  constructor(private readonly serviceUsers: ServiceUsers) {}

  @Get()
  @UseGuards(AuthGuard)
  getUser(@Session() session: IUserSession) {
    return this.serviceUsers.getUser(session.userId);
  }
}
