import { NestFactory } from '@nestjs/core';
import { TgModule } from './tg.module';
import { ServicePort } from '@app/seidh-common';
import { Logger } from '@nestjs/common';

async function bootstrap() {
  const app = await NestFactory.create(TgModule);
  await app.listen(ServicePort.TG);

  Logger.log(`TG listening on port ${ServicePort.TG}`);
}
bootstrap();
