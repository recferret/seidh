import { NatsUrl, ServiceName, ServicePort } from '@lib/seidh-common/seidh-common.internal-protocol';

import { Logger } from '@nestjs/common';
import { NestFactory } from '@nestjs/core';
import { MicroserviceOptions, Transport } from '@nestjs/microservices';
import { NestExpressApplication } from '@nestjs/platform-express';

import { CollectionModule } from './collection.module';

async function bootstrap() {
  const app = await NestFactory.create<NestExpressApplication>(CollectionModule);

  app.connectMicroservice<MicroserviceOptions>({
    transport: Transport.NATS,
    options: {
      servers: [NatsUrl],
      name: ServiceName.Collection,
    },
  });

  await app.startAllMicroservices();
  await app.listen(ServicePort.Collection);

  Logger.log(`Collection listening on port ${ServicePort.Collection}`);
}
bootstrap();
