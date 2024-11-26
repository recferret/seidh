import { Types } from 'mongoose';

export const ReferralServiceUpdateReferrerPattern = 'referral.update-referrer';

// TODO rmk
export interface ReferralServiceUpdateReferrerRequest {
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

export interface ReferralServiceUpdateReferrerResponse {
  success: boolean;
  message?: string;
}
