import { NestFactory } from '@nestjs/core';
import { AuthModule } from './auth.module';
import { ServicePort } from '@app/seidh-common';
import { Logger } from '@nestjs/common';

const fs = require("fs");

async function bootstrap() {
  // const httpsOptions = {
  //   key: fs.readFileSync("./cert/key.pem"),
  //   cert: fs.readFileSync("./cert/cert.pem")
  // };
  // console.log(httpsOptions);

  const app = await NestFactory.create(AuthModule);//, {httpsOptions});

  await app.listen(ServicePort.Auth);

  Logger.log(`Auth listening on port ${ServicePort.Auth}`);
}
bootstrap();
