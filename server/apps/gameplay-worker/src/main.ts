import { ServicePort } from '@lib/seidh-common/seidh-common.internal-protocol';

import { Logger } from '@nestjs/common';
import { NestFactory } from '@nestjs/core';

import { GameplayWorkerModule } from './gameplay-worker.module';

async function bootstrap() {
  const app = await NestFactory.create(GameplayWorkerModule);
  await app.listen(ServicePort.GameplayWorker);

  Logger.log(`Gameplay-Worker listening on port ${ServicePort.GameplayWorker}`);
}
bootstrap();
