import { NestFactory } from '@nestjs/core';
import { GameModule } from './game.module';
import { InternalProtocol, ServiceName, ServicePort } from '@app/seidh-common';
import { Logger } from '@nestjs/common';
import { MicroserviceOptions, Transport } from '@nestjs/microservices';
import { NestExpressApplication } from '@nestjs/platform-express';

async function bootstrap() {
  const app = await NestFactory.create<NestExpressApplication>(GameModule);

  app.connectMicroservice<MicroserviceOptions>({
    transport: Transport.NATS,
    options: {
      servers: [InternalProtocol.NatsUrl],
      name: ServiceName.Game,
    },
  });

  await app.startAllMicroservices();
  await app.listen(ServicePort.Game);

  Logger.log(`Game listening on port ${ServicePort.Game}`);
}
bootstrap();
