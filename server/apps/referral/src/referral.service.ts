import { Injectable } from '@nestjs/common';

@Injectable()
export class ReferralService {
  getHello(): string {
    return 'Hello World!';
  }
}
