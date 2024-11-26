import { Body, Controller, Post, UseGuards } from '@nestjs/common';
import { AuthRequestDto } from '../dto/auth/auth.dto';
import { ProductionGuard } from '../guards/guard.production';
import { ServiceUsers } from '../services/service.users';

@Controller('auth')
export class ControllerAuth {
  constructor(private readonly serviceUsers: ServiceUsers) {}

  @Post()
  @UseGuards(ProductionGuard)
  authenticate(@Body() req: AuthRequestDto) {
    return this.serviceUsers.authenticate(req);
  }
}
