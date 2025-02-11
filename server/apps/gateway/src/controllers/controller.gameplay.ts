import { Body, Controller, Post, Session, UseGuards } from '@nestjs/common';

import { ServiceGameplay } from '../services/service.gameplay';

import { AuthGuard } from '../guards/guard.auth';

import { GameplayType } from '@lib/seidh-common/dto/gameplay-lobby/gameplay-lobby.find-game.msg';

import { IUserSession } from './interfaces';

@Controller('gameplay')
export class ControllerGameplay {
  constructor(private readonly serviceGameplay: ServiceGameplay) {}

  @Post('findGame')
  @UseGuards(AuthGuard)
  findGame(@Session() session: IUserSession, @Body() body: { gameplayType: GameplayType }) {
    return this.serviceGameplay.findGame(session.userId, body.gameplayType);
  }
}
