import { Injectable } from '@nestjs/common';
import { ValidateTelegramDataDto } from './dto/validate-telegram-data.dto';
// import decodeUriComponent from 'decode-uri-component';

const crypto = require('crypto');

@Injectable()
export class AuthService {

  // TODO rmk to nats
  validateTelegramInitData(dto: ValidateTelegramDataDto) {
    const encoded = decodeURIComponent(dto.initData);

    const secret = crypto.createHmac('sha256', 'WebAppData').update('7109468529:AAHvO4toPIdlBVgEJkDc8Yjozx1uXsM4QV8');

    const arr = encoded.split("&");
    const hashIndex = arr.findIndex((str) => str.startsWith("hash="));
    const hash = arr.splice(hashIndex)[0].split("=")[1];

    arr.sort((a, b) => a.localeCompare(b));
    const dataCheckString = arr.join("\n");

    const _hash = crypto
      .createHmac("sha256", secret.digest())
      .update(dataCheckString)
      .digest("hex");

    return _hash === hash;
  }

}
