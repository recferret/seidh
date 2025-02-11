import { Module } from '@nestjs/common';

import { EnvModule } from '@lib/env/env.module';

import { ControllerInvoice } from './nats/controller.invoice';

import { TgService } from '../tg.service';

@Module({
  imports: [EnvModule],
  controllers: [ControllerInvoice],
  providers: [TgService],
})
export class ApiModule {}
