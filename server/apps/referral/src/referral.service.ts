import { Injectable } from '@nestjs/common';
import { ReferralUpdateReferrerMessageRequest } from '@app/seidh-common/dto/referral/referral.update.referrer.msg';

@Injectable()
export class ReferralService {
  private readonly isProd = process.env.NODE_ENV == 'production';
  private readonly referrerPremiumRewardTokens = 1000;
  private readonly referrerNoPremiumRewardTokens = 200;
  private readonly referralPremiumRewardTokens = 200;
  private readonly referralNoPremiumRewardTokens = 50;

  UpdateReferrer(message: ReferralUpdateReferrerMessageRequest) {
    const { referrer, newUser } = message;

    if (referrer) {
      referrer.friendsInvited.push(newUser._id);

      if (this.isProd) {
        // Give some bonus to the referrer
        referrer.virtualTokenBalance += newUser.telegramPremium
          ? this.referrerPremiumRewardTokens
          : this.referrerNoPremiumRewardTokens;

        // Give some bonus to the referral
        newUser.virtualTokenBalance = newUser.telegramPremium
          ? this.referralPremiumRewardTokens
          : this.referralNoPremiumRewardTokens;
      } else {
        // Give some bonus to the referrer
        referrer.virtualTokenBalance += this.referrerNoPremiumRewardTokens;

        // Give some bonus to the referral
        newUser.virtualTokenBalance = this.referralNoPremiumRewardTokens;
      }
      return { referrer, newUser };
    }
  }
}
