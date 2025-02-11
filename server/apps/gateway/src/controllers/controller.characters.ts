// import { Body, Controller, Get, Session, UseGuards } from '@nestjs/common';
import { Controller, Get, Post, Session, UseGuards } from '@nestjs/common';

import { ServiceCharacters } from '../services/service.characters';

import { AuthGuard } from '../guards/guard.auth';

import { IUserSession } from './interfaces';

// import { IUserSession } from './interfaces';

@Controller('characters')
export class ControllerCharacters {
  constructor(private readonly serviceCharacters: ServiceCharacters) {}

  // @Get('by-user')
  // @UseGuards(AuthGuard)
  // getByUser(@Session() session: IUserSession) {}

  @Get('default-params')
  @UseGuards(AuthGuard)
  getDefaultParams() {
    return this.serviceCharacters.getDefaultParams();
  }

  @Post('level-up')
  @UseGuards(AuthGuard)
  levelUp(@Session() session: IUserSession) {
    return this.serviceCharacters.levelUp(session.userId);
  }
}
