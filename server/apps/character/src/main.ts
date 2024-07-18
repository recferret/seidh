import { NestFactory } from '@nestjs/core';
import { CharacterModule } from './character.module';
import { InternalProtocol, ServiceName, ServicePort } from '@app/seidh-common';
import { Logger } from '@nestjs/common';
import { MicroserviceOptions, Transport } from '@nestjs/microservices';
import { NestExpressApplication } from '@nestjs/platform-express';

async function bootstrap() {
  const app = await NestFactory.create<NestExpressApplication>(CharacterModule);

  app.connectMicroservice<MicroserviceOptions>({
    transport: Transport.NATS,
    options: {
      servers: [InternalProtocol.NatsUrl],
      name: ServiceName.Character,
    },
  });

  await app.startAllMicroservices();
  await app.listen(ServicePort.Character);

  Logger.log(`Character listening on port ${ServicePort.Character}`);
}
bootstrap();
