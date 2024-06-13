import { NestFactory } from '@nestjs/core';
import { GameplayLobbyModule } from './gameplay-lobby.module';
import { ServiceName, ServicePort } from '@app/seidh-common';
import { InternalProtocol } from '@app/seidh-common/seidh-common.internal-protocol';
import { MicroserviceOptions, Transport } from '@nestjs/microservices';
import { NestExpressApplication } from '@nestjs/platform-express';
import { Logger } from '@nestjs/common';

async function bootstrap() {
  const app = await NestFactory.create<NestExpressApplication>(GameplayLobbyModule);

  app.connectMicroservice<MicroserviceOptions>({
    transport: Transport.NATS,
    options: {
      servers: [InternalProtocol.NatsUrl],
      name: ServiceName.GameplayLobby,
    },
  });

  await app.startAllMicroservices();
  await app.listen(ServicePort.GameplayLobby);

  Logger.log(`Gameplay lobby listening on port ${ServicePort.GameplayLobby}`);
}
bootstrap();
