import { Controller, Get } from '@nestjs/common';
import { ReferralService } from './referral.service';

@Controller()
export class ReferralController {
  constructor(private readonly referralService: ReferralService) {}

  @Get()
  getHello(): string {
    return this.referralService.getHello();
  }
}
