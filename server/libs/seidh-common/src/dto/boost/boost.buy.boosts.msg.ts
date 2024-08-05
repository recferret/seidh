import { BoostBody } from './boost.get.boosts.msg';

export const BoostsBuyPattern = 'boosts.buy';

export interface BoostsBuyRequest {
  userId: string;
  boostId: string;
}

export interface BoostsBuyResponse {
  success: boolean;
  message?: string;
  boosts?: BoostBody[];
}
