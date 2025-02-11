import { Injectable } from '@nestjs/common';

import { MicroserviceTg } from '@lib/seidh-common/microservice/microservice.tg';

import { TgInvoiceCreateRequestDto, TgInvoiceCreateResponseDto } from '../dto/tg/tg.invoice.create.dto';

@Injectable()
export class ServiceTg {
  constructor(private microserviceTg: MicroserviceTg) {}

  async createInvoice(request: TgInvoiceCreateRequestDto) {
    const result = await this.microserviceTg.createInvoice(request);
    const response: TgInvoiceCreateResponseDto = {
      url: result.url,
    };
    return response;
  }
}
