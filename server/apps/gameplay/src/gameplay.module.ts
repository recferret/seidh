import { Module } from '@nestjs/common';
import { GameplayController } from './gameplay.controller';
import { GameplayService } from './gameplay.service';
import { ClientsModule, Transport } from '@nestjs/microservices';
import { ServiceName } from '@app/seidh-common';
import { ScheduleModule } from '@nestjs/schedule';
import { EventEmitterModule } from '@nestjs/event-emitter';
import NatsUrl from '@app/seidh-common/seidh-common.internal-protocol';

@Module({
  imports: [
    ScheduleModule.forRoot(),
    EventEmitterModule.forRoot(),
    ClientsModule.register([
      {
        name: ServiceName.WsGateway,
        transport: Transport.NATS,
        options: {
          servers: [NatsUrl],
        }
      },
      {
        name: ServiceName.GameplayLobby,
        transport: Transport.NATS,
        options: {
          servers: [NatsUrl],
        }
      },
    ]),
  ],
  controllers: [GameplayController],
  providers: [GameplayService],
})
export class GameplayModule {}
