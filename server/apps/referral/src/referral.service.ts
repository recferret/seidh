import { Injectable } from '@nestjs/common';
import { ReferralUpdateReferrerMessageRequest } from '@app/seidh-common/dto/referral/referral.update.referrer.msg';
import { InjectModel } from '@nestjs/mongoose';
import { Model } from 'mongoose';
import { ReferralConfig } from '@app/seidh-common/schemas/schema.referral';

@Injectable()
export class ReferralService {
  private readonly isProd = process.env.NODE_ENV == 'production';

  constructor(
    @InjectModel(ReferralConfig.name)
    private referralConfigModel: Model<ReferralConfig>,
  ) {}

  // onModuleInit() {
  //   new this.referralConfigModel().save();
  // }

  async getReferrerConfig() {
    return this.referralConfigModel.findOne();
  }

  async updateReferrer(message: ReferralUpdateReferrerMessageRequest) {
    const { referrer, newUser } = message;

    if (referrer) {
      const {
        referrerPremiumRewardTokens,
        referrerNoPremiumRewardTokens,
        referralPremiumRewardTokens,
        referralNoPremiumRewardTokens,
      } = await this.getReferrerConfig();

      referrer.friendsInvited.push(newUser._id);

      if (this.isProd) {
        // Give some bonus to the referrer
        referrer.virtualTokenBalance += newUser.telegramPremium
          ? referrerPremiumRewardTokens
          : referrerNoPremiumRewardTokens;

        // Give some bonus to the referral
        newUser.virtualTokenBalance = newUser.telegramPremium
          ? referralPremiumRewardTokens
          : referralNoPremiumRewardTokens;
      } else {
        // Give some bonus to the referrer
        referrer.virtualTokenBalance += referrerNoPremiumRewardTokens;

        // Give some bonus to the referral
        newUser.virtualTokenBalance = referralNoPremiumRewardTokens;
      }
      return { referrer, newUser };
    }
  }
}
