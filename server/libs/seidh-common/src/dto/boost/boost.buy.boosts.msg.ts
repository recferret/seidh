import { BoostBody } from './boost.get.boosts.msg';

export const BoostsBuyPattern = 'boosts.buy';

export interface BoostsBuyBoostServiceRequest {
  userId: string;
  boostId: string;
}

export interface BoostsBuyBoostServiceResponse {
  success: boolean;
  message?: string;
  boosts?: BoostBody[];
}
