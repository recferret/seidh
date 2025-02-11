import { NatsUrl, ServiceName } from '@lib/seidh-common/seidh-common.internal-protocol';

import { Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { JwtModule } from '@nestjs/jwt';
import { ClientsModule, Transport } from '@nestjs/microservices';

import { PrometheusModule } from '@willsoto/nestjs-prometheus';

import { WsGatewayController } from './ws-gateway.controller';
import { WsGatewayWsController } from './ws-gateway.ws.controller';

@Module({
  imports: [
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
    JwtModule.register({
      global: true,
      secret: process.env.JWT_SECRET,
    }),
  ],
  controllers: [WsGatewayController],
  providers: [WsGatewayWsController],
})
export class WsGatewayModule {}
