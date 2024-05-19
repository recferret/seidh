import { Body, Controller, Post } from '@nestjs/common';
import { GatewayService } from './gateway.service';
import { FindGameRequest } from './dto/find.game.dto';

@Controller()
export class GatewayController {
  constructor(private readonly gatewayService: GatewayService) {}

  @Post('findGame')
  findGame(@Body() findGameRequest: FindGameRequest) {
    return this.gatewayService.findGame(findGameRequest);
  }

}
