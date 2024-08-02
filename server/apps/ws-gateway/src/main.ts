import { NestFactory } from '@nestjs/core';
import { WsGatewayModule } from './ws-gateway.module';
import { MicroserviceOptions, Transport } from '@nestjs/microservices';
import { NestExpressApplication } from '@nestjs/platform-express';
import { ServiceName, ServicePort } from '@app/seidh-common';
import { InternalProtocol } from '@app/seidh-common/seidh-common.internal-protocol';
import { Logger } from '@nestjs/common';
import * as fs from 'fs';
import * as path from 'path';

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

  const app = await NestFactory.create<NestExpressApplication>(
    WsGatewayModule,
    { httpsOptions },
  );

  app.connectMicroservice<MicroserviceOptions>({
    transport: Transport.NATS,
    options: {
      servers: [InternalProtocol.NatsUrl],
      name: ServiceName.WsGateway,
    },
  });

  await app.startAllMicroservices();
  await app.listen(ServicePort.WsGateway);

  Logger.log(`WsGateway listening on port ${ServicePort.WsGateway}`);
}
bootstrap();
