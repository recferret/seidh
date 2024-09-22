import { Body, Controller, Post, UseGuards } from '@nestjs/common';
import { AuthRequestDto } from '../dto/auth/auth.dto';
import { ProductionGuard } from '../guards/guard.production';
import { ServiceAuth } from '../services/service.auth';

@Controller('auth')
export class ControllerAuth {
  constructor(private readonly serviceAuth: ServiceAuth) {}

  @Post()
  @UseGuards(ProductionGuard)
  authenticate(@Body() req: AuthRequestDto) {
    return this.serviceAuth.authenticate(req);
  }
}
