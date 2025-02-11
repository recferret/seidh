import { Types } from 'mongoose';

import { BasicServiceResponse } from '../basic.msg';

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

export interface ReferralServiceUpdateReferrerResponse extends BasicServiceResponse {}
