import { v4 as uuidv4 } from 'uuid';

import { NestFactory } from '@nestjs/core';
import { GameplayModule } from './gameplay.module';
import { MicroserviceOptions, Transport } from '@nestjs/microservices';
import { NestExpressApplication } from '@nestjs/platform-express';
import { ServiceName, ServicePort } from '@app/seidh-common';
import { InternalProtocol } from '@app/seidh-common/seidh-common.internal-protocol';
import { Logger } from '@nestjs/common';

export class Config {
  public static readonly GAMEPLAY_INSTANCE_ID = uuidv4();
}

async function bootstrap() {
  const app = await NestFactory.create<NestExpressApplication>(GameplayModule);

  app.connectMicroservice<MicroserviceOptions>({
    transport: Transport.NATS,
    options: {
      servers: [InternalProtocol.NatsUrl],
      name: ServiceName.Gameplay,
    },
  });

  await app.startAllMicroservices();
  await app.listen(ServicePort.Gameplay);

  Logger.log(
    `Gameplay ${Config.GAMEPLAY_INSTANCE_ID} listening on port ${ServicePort.Gameplay}`,
  );
}
bootstrap();
