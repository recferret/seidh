import { NestFactory } from '@nestjs/core';
import { GatewayModule } from './gateway.module';
import { ServicePort } from '@app/seidh-common';
import { Logger } from '@nestjs/common';

async function bootstrap() {
  const app = await NestFactory.create(GatewayModule);

  app.enableCors();
  await app.listen(ServicePort.Gateway);

  Logger.log(`Gateway listening on port ${ServicePort.Gateway}`);
}
bootstrap();
