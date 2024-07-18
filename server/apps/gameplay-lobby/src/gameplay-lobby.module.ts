import { Module } from '@nestjs/common';
import { GameplayLobbyController } from './gameplay-lobby.controller';
import { GameplayLobbyService } from './gameplay-lobby.service';
import { InternalProtocol, ServiceName } from '@app/seidh-common';
import { ClientsModule, Transport } from '@nestjs/microservices';
import { ScheduleModule } from '@nestjs/schedule';
import { PrometheusModule } from '@willsoto/nestjs-prometheus';

@Module({
  imports: [
    ScheduleModule.forRoot(),
    PrometheusModule.register(),
    ClientsModule.register([
      {
        name: ServiceName.Gameplay,
        transport: Transport.NATS,
        options: {
          servers: [InternalProtocol.NatsUrl],
        }
      },
    ]),
  ],
  controllers: [GameplayLobbyController],
  providers: [GameplayLobbyService],
})
export class GameplayLobbyModule {}
