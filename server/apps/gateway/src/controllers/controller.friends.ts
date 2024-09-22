import { Controller, Get, Session, UseGuards } from '@nestjs/common';
import { AuthGuard } from '../guards/guard.auth';
import { IUserSession } from './interfaces';
import { ServiceFriends } from '../services/service.friends';

@Controller('friends')
export class ControllerFriends {
  constructor(private readonly serviceFriends: ServiceFriends) {}

  @Get()
  @UseGuards(AuthGuard)
  getFriends(@Session() session: IUserSession) {
    return this.serviceFriends.getFriends(session.userId);
  }
}
