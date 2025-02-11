import { Controller } from '@nestjs/common';
import { MessagePattern } from '@nestjs/microservices';

import { TgService } from '../../tg.service';

import {
  TgServiceCreateInvoicePattern,
  TgServiceCreateInvoiceRequest,
} from '@lib/seidh-common/dto/tg/tg.invoice-create';

@Controller()
export class ControllerInvoice {
  constructor(private readonly tgService: TgService) {}

  @MessagePattern(TgServiceCreateInvoicePattern)
  async createInvoice(request: TgServiceCreateInvoiceRequest) {
    return this.tgService.createInvoiceLink(request);
  }
}
