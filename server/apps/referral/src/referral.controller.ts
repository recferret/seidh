import { Controller } from '@nestjs/common';
import { ReferralService } from './referral.service';
import { MessagePattern } from '@nestjs/microservices';
import {
  ReferralUpdateReferrerMessageRequest,
  ReferralUpdateReferrerPattern,
} from '@app/seidh-common/dto/referral/referral.update.referrer.msg';

@Controller()
export class ReferralController {
  constructor(private readonly referralService: ReferralService) {}

  @MessagePattern(ReferralUpdateReferrerPattern)
  async UpdateReferrer(message: ReferralUpdateReferrerMessageRequest) {
    return await this.referralService.updateReferrer(message);
  }
}
