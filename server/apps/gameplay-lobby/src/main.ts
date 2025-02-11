import { NatsUrl, ServiceName, ServicePort } from '@lib/seidh-common/seidh-common.internal-protocol';

import { Logger } from '@nestjs/common';
import { NestFactory } from '@nestjs/core';
import { MicroserviceOptions, Transport } from '@nestjs/microservices';
import { NestExpressApplication } from '@nestjs/platform-express';

import { GameplayLobbyModule } from './gameplay-lobby.module';

async function bootstrap() {
  const app = await NestFactory.create<NestExpressApplication>(GameplayLobbyModule);

  app.connectMicroservice<MicroserviceOptions>({
    transport: Transport.NATS,
    options: {
      servers: [NatsUrl],
      name: ServiceName.GameplayLobby,
    },
  });

  await app.startAllMicroservices();
  await app.listen(ServicePort.GameplayLobby);

  Logger.log(`Gameplay lobby listening on port ${ServicePort.GameplayLobby}`);
}
bootstrap();
