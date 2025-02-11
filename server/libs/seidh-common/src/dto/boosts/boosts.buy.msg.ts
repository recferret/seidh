import { BasicServiceResponse } from '../basic.msg';
import { BoostBody } from './boosts.get.msg';

export const BoostsServiceBuyPattern = 'boosts.buy';

export interface BoostsServiceBuyRequest {
  userId: string;
  boostId: string;
}

export interface BoostsServiceBuyResponse extends BasicServiceResponse {
  boosts?: BoostBody[];
}
