import { Controller } from '@nestjs/common';
import { MessagePattern } from '@nestjs/microservices';

import { ReferralService } from './referral.service';

import {
  ReferralServiceUpdateReferrerPattern,
  ReferralServiceUpdateReferrerRequest,
} from '@lib/seidh-common/dto/referral/referral.update-referrer.msg';

@Controller()
export class ReferralController {
  constructor(private readonly referralService: ReferralService) {}

  @MessagePattern(ReferralServiceUpdateReferrerPattern)
  async UpdateReferrer(message: ReferralServiceUpdateReferrerRequest) {
    return await this.referralService.updateReferrer(message);
  }
}
