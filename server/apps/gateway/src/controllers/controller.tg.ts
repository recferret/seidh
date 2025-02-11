import { Body, Controller, Post, UseGuards } from '@nestjs/common';

import { ServiceTg } from '../services/service.tg';

import { ProductionGuard } from '../guards/guard.production';

import { TgInvoiceCreateRequestDto } from '../dto/tg/tg.invoice.create.dto';

@Controller('tg')
export class ControllerTg {
  constructor(private readonly serviceTg: ServiceTg) {}

  @Post('invoice/create')
  // @UseGuards(ProductionGuard)
  invoiceCreate(@Body() req: TgInvoiceCreateRequestDto) {
    return this.serviceTg.createInvoice(req);
  }
}
