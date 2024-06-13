import { Body, Controller, Get, Post, Req, UseGuards } from '@nestjs/common';
import { GatewayService } from './gateway.service';
import { FindGameRequest } from './dto/find.game.dto';
import { AuthenticateRequest } from './dto/authenticate.dto';
import { AuthGuard } from './guards/guard.auth';
import { JwtService } from '@nestjs/jwt';

@Controller()
export class GatewayController {
  constructor(
    private readonly gatewayService: GatewayService,
    private readonly jwtService: JwtService
  ) {
  }

  // TODO add auth guard
  @Post('findGame')
  findGame(@Body() findGameRequest: FindGameRequest) {
    return this.gatewayService.findGame(findGameRequest);
  }

  @Post('authenticate')
  authenticate(@Body() authenticateRequest: AuthenticateRequest) {
    return this.gatewayService.authenticate(authenticateRequest);
  }

  @Get('friends')
  @UseGuards(AuthGuard)
  getFriends(@Req() request: Request)  {
    const decodedToken = this.jwtService.decode(request.headers['authorization'].split(' ')[1]);
    return this.gatewayService.getFriends(decodedToken.userId);
  }

}
