import { ReferralConfig } from '@lib/seidh-common/schemas/user/schema.referral';
import { Model } from 'mongoose';

import { Injectable } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';

import {
  ReferralServiceUpdateReferrerRequest,
  ReferralServiceUpdateReferrerResponse,
} from '@lib/seidh-common/dto/referral/referral.update-referrer.msg';

@Injectable()
export class ReferralService {
  private readonly isProd = process.env.NODE_ENV == 'production';

  constructor(
    @InjectModel(ReferralConfig.name)
    private referralConfigModel: Model<ReferralConfig>,
  ) {}

  async getReferrerConfig() {
    return this.referralConfigModel.findOne();
  }

  async updateReferrer(_request: ReferralServiceUpdateReferrerRequest) {
    const response: ReferralServiceUpdateReferrerResponse = {
      success: false,
    };

    // try {
    //   if (request.referrer) {
    //     const {
    //       referrerPremiumRewardTokens,
    //       referrerNoPremiumRewardTokens,
    //       referralPremiumRewardTokens,
    //       referralNoPremiumRewardTokens,
    //     } = await this.getReferrerConfig();

    //     referrer.friendsInvited.push(newUser._id);

    //     if (this.isProd) {
    //       // Give some bonus to the referrer
    //       referrer.virtualTokenBalance += newUser.telegramPremium
    //         ? referrerPremiumRewardTokens
    //         : referrerNoPremiumRewardTokens;

    //       // Give some bonus to the referral
    //       newUser.virtualTokenBalance = newUser.telegramPremium
    //         ? referralPremiumRewardTokens
    //         : referralNoPremiumRewardTokens;
    //     } else {
    //       // Give some bonus to the referrer
    //       referrer.virtualTokenBalance += referrerNoPremiumRewardTokens;

    //       // Give some bonus to the referral
    //       newUser.virtualTokenBalance = referralNoPremiumRewardTokens;
    //     }
    //     return { referrer, newUser };
    //   }
    // } catch () {

    // }

    return response;
  }
}
