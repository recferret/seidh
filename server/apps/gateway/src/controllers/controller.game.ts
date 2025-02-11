import { Body, Controller, Get, Post, Session, UseGuards } from '@nestjs/common';

import { ServiceGame } from '../services/service.game';

import { AuthGuard } from '../guards/guard.auth';

import { GameServiceFinishGameRequestDto } from '../dto/game/game.finish-game.dto';
import { GameServiceProgressGameRequestDto } from '../dto/game/game.progress-game.dto';

import { IUserSession } from './interfaces';

@Controller('game')
export class ControllerGame {
  constructor(private readonly serviceGame: ServiceGame) {}

  @Get('config')
  @UseGuards(AuthGuard)
  getConfig() {
    return this.serviceGame.getGameConfig();
  }

  @Post('start')
  @UseGuards(AuthGuard)
  startGame(@Session() session: IUserSession) {
    return this.serviceGame.startGame(session.userId);
  }

  @Post('progress')
  @UseGuards(AuthGuard)
  progressGame(@Session() session: IUserSession, @Body() req: GameServiceProgressGameRequestDto) {
    return this.serviceGame.progressGame(session.userId, req);
  }

  @Post('finish')
  @UseGuards(AuthGuard)
  finishGame(@Session() session: IUserSession, @Body() req: GameServiceFinishGameRequestDto) {
    return this.serviceGame.finishGame(session.userId, req);
  }
}
