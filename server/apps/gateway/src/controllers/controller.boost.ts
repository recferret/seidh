import {
  Body,
  Controller,
  Get,
  Post,
  Session,
  UseGuards,
} from '@nestjs/common';
import { AuthGuard } from '../guards/guard.auth';
import { IUserSession } from './interfaces';
import { ServiceBoost } from '../services/service.boost';
import { BoostsBuyRequestDto } from '../dto/boost/boosts.buy.dto';

@Controller('boosts')
export class ControllerBoost {
  constructor(private readonly serviceBoost: ServiceBoost) {}

  @Get()
  @UseGuards(AuthGuard)
  getBoosts(@Session() session: IUserSession) {
    return this.serviceBoost.getBoosts(session.userId);
  }

  @Post()
  @UseGuards(AuthGuard)
  buyBoost(@Session() session: IUserSession, @Body() req: BoostsBuyRequestDto) {
    return this.serviceBoost.buyBoost(session.userId, req.boostId);
  }
}
