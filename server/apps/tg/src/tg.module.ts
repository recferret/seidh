import { Module } from '@nestjs/common';
import { TgController } from './tg.controller';
import { TgService } from './tg.service';
import { PrometheusModule } from '@willsoto/nestjs-prometheus';

@Module({
  imports: [PrometheusModule.register()],
  controllers: [TgController],
  providers: [TgService],
})
export class TgModule {}
