import { Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { ClientsModule, Transport } from '@nestjs/microservices';
import { JwtModule } from '@nestjs/jwt';
import { WsGatewayController } from './ws-gateway.controller';
import { WsGatewayWsController } from './ws-gateway.ws.controller';
import { InternalProtocol, ServiceName } from '@app/seidh-common';
import { PrometheusModule } from '@willsoto/nestjs-prometheus';

@Module({
  imports: [
    ConfigModule.forRoot(),
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
    JwtModule.register({
      global: true,
      secret: process.env.JWT_SECRET,
    }),
  ],
  controllers: [WsGatewayController],
  providers: [WsGatewayWsController],
})
export class WsGatewayModule {}
