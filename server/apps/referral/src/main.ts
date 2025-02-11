import { NatsUrl, ServiceName, ServicePort } from '@lib/seidh-common/seidh-common.internal-protocol';

import { Logger } from '@nestjs/common';
import { NestFactory } from '@nestjs/core';
import { MicroserviceOptions, Transport } from '@nestjs/microservices';
import { NestExpressApplication } from '@nestjs/platform-express';

import { ReferralModule } from './referral.module';

async function bootstrap() {
  const app = await NestFactory.create<NestExpressApplication>(ReferralModule);

  app.connectMicroservice<MicroserviceOptions>({
    transport: Transport.NATS,
    options: {
      servers: [NatsUrl],
      name: ServiceName.Referral,
    },
  });

  await app.startAllMicroservices();
  await app.listen(ServicePort.Referral);

  Logger.log(`Referral listening on port ${ServicePort.Referral}`);
}
bootstrap();
