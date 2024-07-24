import { NestFactory } from '@nestjs/core';
import { CollectionModule } from './collection.module';
import { InternalProtocol, ServiceName, ServicePort } from '@app/seidh-common';
import { Logger } from '@nestjs/common';
import { MicroserviceOptions, Transport } from '@nestjs/microservices';
import { NestExpressApplication } from '@nestjs/platform-express';

async function bootstrap() {
  const app =
    await NestFactory.create<NestExpressApplication>(CollectionModule);

  app.connectMicroservice<MicroserviceOptions>({
    transport: Transport.NATS,
    options: {
      servers: [InternalProtocol.NatsUrl],
      name: ServiceName.Collection,
    },
  });

  await app.startAllMicroservices();
  await app.listen(ServicePort.Collection);

  Logger.log(`Collection listening on port ${ServicePort.Collection}`);
}
bootstrap();
