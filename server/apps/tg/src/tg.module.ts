import { Module } from '@nestjs/common';

import { PrometheusModule } from '@willsoto/nestjs-prometheus';

import { ApiModule } from './api/api.module';
import { EnvModule } from '@lib/env/env.module';

import { TgService } from './tg.service';

@Module({
  imports: [PrometheusModule.register(), EnvModule, ApiModule],
  controllers: [],
  providers: [TgService],
})
export class TgModule {}
