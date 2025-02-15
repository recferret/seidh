import { BullModule } from '@nestjs/bull';
import { Module } from '@nestjs/common';

import { GameplayWorkerConsumer } from './gameplay-worker.consumer';

@Module({
  imports: [
    BullModule.forRoot({
      redis: {
        host: 'localhost',
        port: 6379,
      },
    }),
    BullModule.registerQueue({
      name: 'gamelog',
    }),
  ],
  controllers: [],
  providers: [GameplayWorkerConsumer],
})
export class GameplayWorkerModule {}
