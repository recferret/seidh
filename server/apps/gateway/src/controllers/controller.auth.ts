import { Body, Controller, Logger, Post, UseGuards } from '@nestjs/common';

import { ServiceUsers } from '../services/service.users';

import { ProductionGuard } from '../guards/guard.production';

import { AuthSimpleRequestDto, AuthTgRequestDto, AuthVkRequestDto } from '../dto/auth/auth.dto';

@Controller('auth')
export class ControllerAuth {
  constructor(private readonly serviceUsers: ServiceUsers) {}

  @Post('tg')
  @UseGuards(ProductionGuard)
  tgAuth(@Body() req: AuthTgRequestDto) {
    Logger.log('tg auth', req);
    return this.serviceUsers.tgAuth(req);
  }

  @Post('vk')
  @UseGuards(ProductionGuard)
  vkAuth(@Body() req: AuthVkRequestDto) {
    Logger.log('vk auth', req);
    return this.serviceUsers.vkAuth(req);
  }

  @Post('simple')
  @UseGuards(ProductionGuard)
  simpleAuth(@Body() req: AuthSimpleRequestDto) {
    Logger.log('simple auth', req);
    return this.serviceUsers.simpleAuth(req);
  }
}
