import { Module } from '@nestjs/common';
import { WsGatewayController } from './ws-gateway.controller';
import { WsGatewayWsController } from './ws-gateway.ws.controller';
import { ClientsModule, Transport } from '@nestjs/microservices';
import { ServiceName } from '@app/seidh-common';
import NatsUrl from '@app/seidh-common/seidh-common.internal-protocol';

@Module({
  imports: [
    ClientsModule.register([
      {
        name: ServiceName.Gameplay,
        transport: Transport.NATS,
        options: {
          servers: [NatsUrl],
        }
      },
    ]),
  ],
  controllers: [WsGatewayController],
  providers: [WsGatewayWsController],
})
export class WsGatewayModule {}
