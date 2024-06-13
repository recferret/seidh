import { Module } from '@nestjs/common';
import { GatewayController } from './gateway.controller';
import { GatewayService } from './gateway.service';
import { ServiceName } from '@app/seidh-common';
import NatsUrl from '@app/seidh-common/seidh-common.internal-protocol';
import { ClientsModule, Transport } from '@nestjs/microservices';
import { JwtModule } from '@nestjs/jwt';

@Module({
  imports: [
    ClientsModule.register([
      {
        name: ServiceName.GameplayLobby,
        transport: Transport.NATS,
        options: {
          servers: [NatsUrl],
        }
      },
      {
        name: ServiceName.Users,
        transport: Transport.NATS,
        options: {
          servers: [NatsUrl],
        }
      },
    ]),
    JwtModule.register({
      global: true,
      secret: 'MY SUPER SECRET',
    }),
  ],
  controllers: [GatewayController],
  providers: [GatewayService],
})
export class GatewayModule {}
