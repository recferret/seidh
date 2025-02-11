import { NestFactory } from '@nestjs/core';

import { BalancesModule } from './balances.module';

async function bootstrap() {
  const app = await NestFactory.create(BalancesModule);
  await app.listen(3000);
}
bootstrap();
