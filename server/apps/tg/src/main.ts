import { NestFactory } from '@nestjs/core';
import { TgModule } from './tg.module';
import { ServicePort } from '@app/seidh-common';

async function bootstrap() {
  const app = await NestFactory.create(TgModule);
  await app.listen(ServicePort.TG);
}
bootstrap();
