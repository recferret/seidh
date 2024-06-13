import { Module } from '@nestjs/common';
import { WsGatewayController } from './ws-gateway.controller';
import { WsGatewayWsController } from './ws-gateway.ws.controller';
import { ClientsModule, Transport } from '@nestjs/microservices';
import { InternalProtocol, ServiceName } from '@app/seidh-common';

@Module({
  imports: [
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
  controllers: [WsGatewayController],
  providers: [WsGatewayWsController],
})
export class WsGatewayModule {}
