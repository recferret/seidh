import { Types } from 'mongoose';

export const ReferralUpdateReferrerPattern = 'referral.update.referrer';

export interface ReferralUpdateReferrerMessageRequest {
  referrer: {
    _id: Types.ObjectId;
    virtualTokenBalance: number;
    friendsInvited: Types.ObjectId[];
  };
  newUser: {
    _id: Types.ObjectId;
    invitedBy: Types.ObjectId;
    telegramPremium: boolean;
    virtualTokenBalance: number;
  };
}

export interface BoostsBuyBoostMessageResponse {
  success: boolean;
  message?: string;
}
