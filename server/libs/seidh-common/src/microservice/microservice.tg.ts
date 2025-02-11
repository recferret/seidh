import { Inject, Injectable } from '@nestjs/common';
import { ClientProxy } from '@nestjs/microservices';

import { MicroserviceWrapper } from './microservice.utils';

import {
  TgServiceCreateInvoicePattern,
  TgServiceCreateInvoiceRequest,
  TgServiceCreateInvoiceResponse,
} from '../dto/tg/tg.invoice-create';

import { ServiceName } from '../seidh-common.internal-protocol';

@Injectable()
export class MicroserviceTg {
  private readonly microserviceWrapper: MicroserviceWrapper;

  constructor(@Inject(ServiceName.TG) tgService: ClientProxy) {
    this.microserviceWrapper = new MicroserviceWrapper(tgService);
  }

  async createInvoice(request: TgServiceCreateInvoiceRequest) {
    return this.microserviceWrapper.request<TgServiceCreateInvoiceRequest, TgServiceCreateInvoiceResponse>(
      TgServiceCreateInvoicePattern,
      request,
    );
  }
}
