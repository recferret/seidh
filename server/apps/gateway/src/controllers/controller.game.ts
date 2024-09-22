import { Body, Controller, Post, Session, UseGuards } from '@nestjs/common';
import { ServiceGame } from '../services/service.game';
import { AuthGuard } from '../guards/guard.auth';
import { GameFinishGameRequestDto } from '../dto/game/game.finish.game.dto';
import { GameProgressGameRequestDto } from '../dto/game/game.progress.game.dto';
import { IUserSession } from './interfaces';

@Controller('game')
export class ControllerGame {
  constructor(private readonly serviceGame: ServiceGame) {}

  @Post('start')
  @UseGuards(AuthGuard)
  startGame(@Session() session: IUserSession) {
    return this.serviceGame.startGame(session.userId);
  }

  @Post('progress')
  @UseGuards(AuthGuard)
  progressGame(
    @Session() session: IUserSession,
    @Body() req: GameProgressGameRequestDto,
  ) {
    return this.serviceGame.progressGame(session.userId, req);
  }

  @Post('finish')
  @UseGuards(AuthGuard)
  finishGame(
    @Session() session: IUserSession,
    @Body() req: GameFinishGameRequestDto,
  ) {
    return this.serviceGame.finishGame(session.userId, req);
  }
}
