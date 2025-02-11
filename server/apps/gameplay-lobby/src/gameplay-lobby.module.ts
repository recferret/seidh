import { NatsUrl, ServiceName } from '@lib/seidh-common/seidh-common.internal-protocol';

import { Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { ClientsModule, Transport } from '@nestjs/microservices';
import { ScheduleModule } from '@nestjs/schedule';

import { PrometheusModule } from '@willsoto/nestjs-prometheus';

import { GameplayLobbyController } from './gameplay-lobby.controller';

import { GameplayLobbyService } from './gameplay-lobby.service';

@Module({
  imports: [
    ScheduleModule.forRoot(),
    ConfigModule.forRoot(),
    PrometheusModule.register(),
    ClientsModule.register([
      {
        name: ServiceName.Gameplay,
        transport: Transport.NATS,
        options: {
          servers: [NatsUrl],
        },
      },
    ]),
  ],
  controllers: [GameplayLobbyController],
  providers: [GameplayLobbyService],
})
export class GameplayLobbyModule {}
