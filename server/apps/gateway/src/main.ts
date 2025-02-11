import * as fs from 'fs';
import * as path from 'path';
import { ServicePort } from '@lib/seidh-common/seidh-common.internal-protocol';

import { Logger, ValidationPipe } from '@nestjs/common';
import { NestFactory } from '@nestjs/core';

import { GatewayModule } from './gateway.module';

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

  const app = await NestFactory.create(GatewayModule, { httpsOptions });
  app.useGlobalPipes(new ValidationPipe());
  app.enableCors();
  await app.listen(ServicePort.Gateway);

  Logger.log(`Gateway listening on port ${ServicePort.Gateway}`);
}
bootstrap();
