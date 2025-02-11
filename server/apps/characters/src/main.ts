import { NatsUrl, ServiceName, ServicePort } from '@lib/seidh-common/seidh-common.internal-protocol';

import { Logger } from '@nestjs/common';
import { NestFactory } from '@nestjs/core';
import { MicroserviceOptions, Transport } from '@nestjs/microservices';
import { NestExpressApplication } from '@nestjs/platform-express';

import { CharactersModule } from './characters.module';

async function bootstrap() {
  const app = await NestFactory.create<NestExpressApplication>(CharactersModule);

  app.connectMicroservice<MicroserviceOptions>({
    transport: Transport.NATS,
    options: {
      servers: [NatsUrl],
      name: ServiceName.Characters,
    },
  });

  await app.startAllMicroservices();
  await app.listen(ServicePort.Characters);

  Logger.log(`Characters listening on port ${ServicePort.Characters}`);
}
bootstrap();
