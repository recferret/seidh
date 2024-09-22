import { Types } from 'mongoose';

export const ReferralUpdateReferrerPattern = 'referral.update.referrer';

export interface ReferralUpdateReferrerServiceRequest {
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

export interface BoostsBuyBoostMessageServiceResponse {
  success: boolean;
  message?: string;
}
