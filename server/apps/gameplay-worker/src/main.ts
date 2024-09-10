import { NestFactory } from '@nestjs/core';
import { GameplayWorkerModule } from './gameplay-worker.module';
import { ServicePort } from '@app/seidh-common';
import { Logger } from '@nestjs/common';

async function bootstrap() {
  const app = await NestFactory.create(GameplayWorkerModule);
  await app.listen(ServicePort.GameplayWorker);

  Logger.log(`Gameplay-Worker listening on port ${ServicePort.GameplayWorker}`);
}
bootstrap();
