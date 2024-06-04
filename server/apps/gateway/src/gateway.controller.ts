import { Body, Controller, Post } from '@nestjs/common';
import { GatewayService } from './gateway.service';
import { FindGameRequest } from './dto/find.game.dto';
import { AuthenticateRequest } from './dto/authenticate.dto';

@Controller()
export class GatewayController {
  constructor(private readonly gatewayService: GatewayService) {}

  @Post('findGame')
  findGame(@Body() findGameRequest: FindGameRequest) {
    return this.gatewayService.findGame(findGameRequest);
  }

  @Post('authenticate')
  authenticate(@Body() authenticateRequest: AuthenticateRequest) {
    return this.gatewayService.authenticate(authenticateRequest);
  }

}
