import { Controller, Get, Session, UseGuards } from '@nestjs/common';
import { AuthGuard } from '../guards/guard.auth';
import { IUserSession } from './interfaces';
import { ServiceUser } from '../services/service.user';

@Controller('user')
export class ControllerUser {
  constructor(private readonly serviceUser: ServiceUser) {}

  @Get()
  @UseGuards(AuthGuard)
  getUser(@Session() session: IUserSession) {
    return this.serviceUser.getUser(session.userId);
  }
}
