import { Body, Controller, Get, Post } from '@nestjs/common';
import { AuthService } from './auth.service';
import { ValidateTelegramDataDto } from './dto/validate-telegram-data.dto';

@Controller()
export class AuthController {
  constructor(private readonly authService: AuthService) {}

  // TODO replace by gateway api
  @Post('validateTelegramInitData')
  validateTelegramInitData(@Body() dto: ValidateTelegramDataDto) {
    // this.authService.validateTelegramInitData(dto);
  }
}
