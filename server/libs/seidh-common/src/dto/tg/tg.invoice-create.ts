import { BasicServiceResponse } from '../basic.msg';

export const TgServiceCreateInvoicePattern = 'tg.invoice-create';

export interface TgServiceCreateInvoiceRequest {
  itemId: number;
}

export interface TgServiceCreateInvoiceResponse extends BasicServiceResponse {
  url?: string;
}
