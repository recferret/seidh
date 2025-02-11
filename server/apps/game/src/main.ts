import { NatsUrl, ServiceName, ServicePort } from '@lib/seidh-common/seidh-common.internal-protocol';

import { Logger } from '@nestjs/common';
import { NestFactory } from '@nestjs/core';
import { MicroserviceOptions, Transport } from '@nestjs/microservices';
import { NestExpressApplication } from '@nestjs/platform-express';

import { GameModule } from './game.module';

async function bootstrap() {
  const app = await NestFactory.create<NestExpressApplication>(GameModule);

  app.connectMicroservice<MicroserviceOptions>({
    transport: Transport.NATS,
    options: {
      servers: [NatsUrl],
      name: ServiceName.Game,
    },
  });

  await app.startAllMicroservices();
  await app.listen(ServicePort.Game);

  Logger.log(`Game listening on port ${ServicePort.Game}`);
}
bootstrap();
