import { NestFactory } from '@nestjs/core';
import { AuthModule } from './auth.module';
import { ServicePort } from '@app/seidh-common';
import { Logger } from '@nestjs/common';

async function bootstrap() {
  const app = await NestFactory.create(AuthModule);
  await app.listen(ServicePort.Auth);

  Logger.log(`Auth listening on port ${ServicePort.Auth}`);
}
bootstrap();
