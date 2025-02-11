import { NatsUrl, ServiceName, ServicePort } from '@lib/seidh-common/seidh-common.internal-protocol';

import { Logger } from '@nestjs/common';
import { NestFactory } from '@nestjs/core';
import { MicroserviceOptions, Transport } from '@nestjs/microservices';
import { NestExpressApplication } from '@nestjs/platform-express';

import { BoostsModule } from './boosts.module';

async function bootstrap() {
  const app = await NestFactory.create<NestExpressApplication>(BoostsModule);

  app.connectMicroservice<MicroserviceOptions>({
    transport: Transport.NATS,
    options: {
      servers: [NatsUrl],
      name: ServiceName.Boost,
    },
  });

  await app.startAllMicroservices();
  await app.listen(ServicePort.Boosts);

  Logger.log(`Boosts listening on port ${ServicePort.Boosts}`);
}
bootstrap();
