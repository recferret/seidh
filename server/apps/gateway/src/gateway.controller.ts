import { Body, Controller, Get, Post, Session, UseGuards } from '@nestjs/common';
import { GatewayService } from './gateway.service';
import { FindGameRequest } from './dto/find.game.dto';
import { AuthenticateRequest } from './dto/authenticate.dto';
import { AuthGuard } from './guards/guard.auth';

export interface IUserSession {
  userId: string;
}

@Controller()
export class GatewayController {
  constructor(
    private readonly gatewayService: GatewayService
  ) {
  }

  @Post('authenticate')
  authenticate(
    @Body() authenticateRequest: AuthenticateRequest
  ) {
    return this.gatewayService.authenticate(authenticateRequest);
  }

  @Post('findGame')
  @UseGuards(AuthGuard)
  findGame(
    @Body() findGameRequest: FindGameRequest,
    @Session() session: IUserSession,
  ) {
    // TODO pass user id here
    return this.gatewayService.findGame(findGameRequest);
  }

  @Get('boosts')
  @UseGuards(AuthGuard)
  getBoosts(@Session() session: IUserSession) {
    console.log(session);
  }

  @Post('boosts')
  @UseGuards(AuthGuard)
  buyBoost() {

  }

  @Get('friends')
  @UseGuards(AuthGuard)
  getFriends(@Session() session: IUserSession,)  {
    return this.gatewayService.getFriends(session.userId);
  }

}
