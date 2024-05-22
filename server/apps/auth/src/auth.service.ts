import { Injectable, Logger } from '@nestjs/common';
import { ValidateTelegramDataDto } from './dto/validate-telegram-data.dto';

@Injectable()
export class AuthService {

  validateTelegramInitData(dto: ValidateTelegramDataDto) {
    Logger.log(dto.initData);
  }

}
