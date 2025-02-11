import { NatsUrl, ServiceName, ServicePort } from '@lib/seidh-common/seidh-common.internal-protocol';
import { v4 as uuidv4 } from 'uuid';

import { Logger } from '@nestjs/common';
import { NestFactory } from '@nestjs/core';
import { MicroserviceOptions, Transport } from '@nestjs/microservices';
import { NestExpressApplication } from '@nestjs/platform-express';

import { GameplayModule } from './gameplay.module';

export class Config {
  public static readonly GAMEPLAY_INSTANCE_ID = uuidv4();
}

async function bootstrap() {
  const app = await NestFactory.create<NestExpressApplication>(GameplayModule);

  app.connectMicroservice<MicroserviceOptions>({
    transport: Transport.NATS,
    options: {
      servers: [NatsUrl],
      name: ServiceName.Gameplay,
    },
  });

  await app.startAllMicroservices();
  await app.listen(ServicePort.Gameplay);

  Logger.log(`Gameplay ${Config.GAMEPLAY_INSTANCE_ID} listening on port ${ServicePort.Gameplay}`);
}
bootstrap();
