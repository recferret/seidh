import { NestFactory } from '@nestjs/core';
import { GameplayLobbyModule } from './gameplay-lobby.module';
import { ServiceName, ServicePort } from '@app/seidh-common';
import NatsUrl from '@app/seidh-common/seidh-common.internal-protocol';
import { MicroserviceOptions, Transport } from '@nestjs/microservices';
import { NestExpressApplication } from '@nestjs/platform-express';

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
}
bootstrap();
