import { BalanceOperationType, BalanceUpdateReason } from '../../types/types.user';

import { BasicServiceResponse } from '../basic.msg';

export const UsersServiceUpdateBalancePattern = 'users.update-balance';

export interface UsersServiceUpdateBalanceRequest {
  userId: string;
  operation: BalanceOperationType;
  reason: BalanceUpdateReason;
  coins?: number;
  teeth?: number;
}

export interface UsersServiceUpdateBalanceResponse extends BasicServiceResponse {}
