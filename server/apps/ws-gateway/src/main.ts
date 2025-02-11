import * as fs from 'fs';
import * as path from 'path';
import { NatsUrl, ServiceName, ServicePort } from '@lib/seidh-common/seidh-common.internal-protocol';

import { Logger } from '@nestjs/common';
import { NestFactory } from '@nestjs/core';
import { MicroserviceOptions, Transport } from '@nestjs/microservices';
import { NestExpressApplication } from '@nestjs/platform-express';

import { WsGatewayModule } from './ws-gateway.module';

async function bootstrap() {
  let httpsOptions = null;
  if (process.env.LOCAL_SSL == 'true') {
    const keyPath = '../../cert/key.pem';
    const certPath = '../../cert/cert.pem';
    httpsOptions = {
      key: fs.readFileSync(path.join(__dirname, keyPath)),
      cert: fs.readFileSync(path.join(__dirname, certPath)),
    };
  }

  const app = await NestFactory.create<NestExpressApplication>(WsGatewayModule, { httpsOptions });

  app.connectMicroservice<MicroserviceOptions>({
    transport: Transport.NATS,
    options: {
      servers: [NatsUrl],
      name: ServiceName.WsGateway,
    },
  });

  await app.startAllMicroservices();
  await app.listen(ServicePort.WsGateway);

  Logger.log(`WsGateway listening on port ${ServicePort.WsGateway}`);
}
bootstrap();
