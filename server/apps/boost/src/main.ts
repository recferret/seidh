import { NestFactory } from '@nestjs/core';
import { BoostModule } from './boost.module';
import { InternalProtocol, ServiceName, ServicePort } from '@app/seidh-common';
import { Logger } from '@nestjs/common';
import { MicroserviceOptions, Transport } from '@nestjs/microservices';
import { NestExpressApplication } from '@nestjs/platform-express';

async function bootstrap() {
  const app = await NestFactory.create<NestExpressApplication>(BoostModule);

  app.connectMicroservice<MicroserviceOptions>({
    transport: Transport.NATS,
    options: {
      servers: [InternalProtocol.NatsUrl],
      name: ServiceName.Boost,
    },
  });

  await app.startAllMicroservices();
  await app.listen(ServicePort.Boost);

  Logger.log(`Boost listening on port ${ServicePort.Boost}`);
}
bootstrap();
