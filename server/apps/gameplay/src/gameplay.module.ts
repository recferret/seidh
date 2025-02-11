import { NatsUrl, ServiceName } from '@lib/seidh-common/seidh-common.internal-protocol';

import { BullModule } from '@nestjs/bull';
import { Module } from '@nestjs/common';
import { EventEmitterModule } from '@nestjs/event-emitter';
import { ClientsModule, Transport } from '@nestjs/microservices';
import { ScheduleModule } from '@nestjs/schedule';

import { PrometheusModule } from '@willsoto/nestjs-prometheus';

import { GameplayController } from './gameplay.controller';

import { GameplayService } from './gameplay.service';

@Module({
  imports: [
    ScheduleModule.forRoot(),
    EventEmitterModule.forRoot(),
    PrometheusModule.register(),
    BullModule.forRoot({
      redis: {
        host: 'localhost',
        port: 6379,
      },
    }),
    BullModule.registerQueue({
      name: 'gamelog',
    }),
    ClientsModule.register([
      {
        name: ServiceName.WsGateway,
        transport: Transport.NATS,
        options: {
          servers: [NatsUrl],
        },
      },
      {
        name: ServiceName.GameplayLobby,
        transport: Transport.NATS,
        options: {
          servers: [NatsUrl],
        },
      },
      {
        name: ServiceName.Users,
        transport: Transport.NATS,
        options: {
          servers: [NatsUrl],
        },
      },
    ]),
  ],
  controllers: [GameplayController],
  providers: [GameplayService],
})
export class GameplayModule {}
