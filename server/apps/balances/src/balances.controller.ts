import { Controller, Get } from '@nestjs/common';

import { BalancesService } from './balances.service';

@Controller()
export class BalancesController {
  constructor(private readonly balancesService: BalancesService) {}

  @Get()
  getHello(): string {
    return this.balancesService.getHello();
  }
}
