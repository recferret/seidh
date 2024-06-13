import { NestFactory } from '@nestjs/core';
import { UsersModule } from './users.module';
import { InternalProtocol, ServiceName, ServicePort } from '@app/seidh-common';
import { Logger } from '@nestjs/common';
import { MicroserviceOptions, Transport } from '@nestjs/microservices';
import { NestExpressApplication } from '@nestjs/platform-express';

async function bootstrap() {
  const app = await NestFactory.create<NestExpressApplication>(UsersModule);

  app.connectMicroservice<MicroserviceOptions>({
    transport: Transport.NATS,
    options: {
      servers: [InternalProtocol.NatsUrl],
      name: ServiceName.Users,
    },
  });

  await app.startAllMicroservices();
  await app.listen(ServicePort.Users);

  Logger.log(`Users listening on port ${ServicePort.Users}`);
}
bootstrap();
