import { Controller } from '@nestjs/common';
import { ReferralService } from './referral.service';
import { MessagePattern } from '@nestjs/microservices';
import {
  ReferralServiceUpdateReferrerPattern,
  ReferralServiceUpdateReferrerRequest,
} from '@app/seidh-common/dto/referral/referral.update-referrer.msg';

@Controller()
export class ReferralController {
  constructor(private readonly referralService: ReferralService) {}

  @MessagePattern(ReferralServiceUpdateReferrerPattern)
  async UpdateReferrer(message: ReferralServiceUpdateReferrerRequest) {
    return await this.referralService.updateReferrer(message);
  }
}
