import { NestFactory } from '@nestjs/core';
import { ReferralModule } from './referral.module';
import { InternalProtocol, ServiceName, ServicePort } from '@app/seidh-common';
import { Logger } from '@nestjs/common';
import { MicroserviceOptions, Transport } from '@nestjs/microservices';
import { NestExpressApplication } from '@nestjs/platform-express';

async function bootstrap() {
  const app = await NestFactory.create<NestExpressApplication>(ReferralModule);

  app.connectMicroservice<MicroserviceOptions>({
    transport: Transport.NATS,
    options: {
      servers: [InternalProtocol.NatsUrl],
      name: ServiceName.Referral,
    },
  });

  await app.startAllMicroservices();
  await app.listen(ServicePort.Referral);

  Logger.log(`Referral listening on port ${ServicePort.Referral}`);
}
bootstrap();
