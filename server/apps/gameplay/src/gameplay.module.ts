import { Module } from '@nestjs/common';
import { GameplayController } from './gameplay.controller';
import { GameplayService } from './gameplay.service';
import { ClientsModule, Transport } from '@nestjs/microservices';
import { InternalProtocol, ServiceName } from '@app/seidh-common';
import { ScheduleModule } from '@nestjs/schedule';
import { EventEmitterModule } from '@nestjs/event-emitter';

@Module({
  imports: [
    ScheduleModule.forRoot(),
    EventEmitterModule.forRoot(),
    ClientsModule.register([
      {
        name: ServiceName.WsGateway,
        transport: Transport.NATS,
        options: {
          servers: [InternalProtocol.NatsUrl],
        }
      },
      {
        name: ServiceName.GameplayLobby,
        transport: Transport.NATS,
        options: {
          servers: [InternalProtocol.NatsUrl],
        }
      },
    ]),
  ],
  controllers: [GameplayController],
  providers: [GameplayService],
})
export class GameplayModule {}
