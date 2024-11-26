import { NestFactory } from '@nestjs/core';
import { CharactersModule } from './characters.module';
import { InternalProtocol, ServiceName, ServicePort } from '@app/seidh-common';
import { Logger } from '@nestjs/common';
import { MicroserviceOptions, Transport } from '@nestjs/microservices';
import { NestExpressApplication } from '@nestjs/platform-express';

async function bootstrap() {
  const app =
    await NestFactory.create<NestExpressApplication>(CharactersModule);

  app.connectMicroservice<MicroserviceOptions>({
    transport: Transport.NATS,
    options: {
      servers: [InternalProtocol.NatsUrl],
      name: ServiceName.Characters,
    },
  });

  await app.startAllMicroservices();
  await app.listen(ServicePort.Characters);

  Logger.log(`Characters listening on port ${ServicePort.Characters}`);
}
bootstrap();
