import { NestFactory } from '@nestjs/core';
import { WsGatewayModule } from './ws-gateway.module';
import { MicroserviceOptions, Transport } from '@nestjs/microservices';
import { NestExpressApplication } from '@nestjs/platform-express';
import { ServiceName, ServicePort } from '@app/seidh-common';
import { InternalProtocol } from '@app/seidh-common/seidh-common.internal-protocol';
import { Logger } from '@nestjs/common';

async function bootstrap() {
  const app = await NestFactory.create<NestExpressApplication>(WsGatewayModule);

  app.connectMicroservice<MicroserviceOptions>({
    transport: Transport.NATS,
    options: {
      servers: [InternalProtocol.NatsUrl],
      name: ServiceName.WsGateway,
    },
  });

  await app.startAllMicroservices();
  await app.listen(ServicePort.WsGateway);

  Logger.log(`WsGateway listening on port ${ServicePort.WsGateway}`);
}
bootstrap();
