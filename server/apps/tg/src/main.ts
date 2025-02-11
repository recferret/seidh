import { NatsUrl, ServiceName, ServicePort } from '@lib/seidh-common/seidh-common.internal-protocol';

import { Logger } from '@nestjs/common';
import { NestFactory } from '@nestjs/core';
import { MicroserviceOptions, Transport } from '@nestjs/microservices';
import { NestExpressApplication } from '@nestjs/platform-express';

import { TgModule } from './tg.module';

async function bootstrap() {
  const app = await NestFactory.create<NestExpressApplication>(TgModule);

  app.connectMicroservice<MicroserviceOptions>({
    transport: Transport.NATS,
    options: {
      servers: [NatsUrl],
      name: ServiceName.TG,
    },
  });

  await app.startAllMicroservices();
  await app.listen(ServicePort.TG);

  Logger.log(`TG listening on port ${ServicePort.TG}`);
}
bootstrap();
