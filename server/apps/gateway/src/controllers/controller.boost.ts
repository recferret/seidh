import { Body, Controller, Get, Post, Session, UseGuards } from '@nestjs/common';

import { ServiceBoost } from '../services/service.boost';

import { AuthGuard } from '../guards/guard.auth';

import { BoostsBuyRequestDto } from '../dto/boost/boosts.buy.dto';

import { IUserSession } from './interfaces';

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
