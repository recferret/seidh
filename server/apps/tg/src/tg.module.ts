import { Module } from '@nestjs/common';
import { TgController } from './tg.controller';
import { TgService } from './tg.service';

@Module({
  imports: [],
  controllers: [TgController],
  providers: [TgService],
})
export class TgModule {}
