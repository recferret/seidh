export const BoostsBuyBoostPattern = 'boosts.buy.boost';

export interface BoostsBuyBoostMessageRequest {
  userId: string;
  boostId: string;
}

export interface BoostsBuyBoostMessageResponse {
  success: boolean;
  message?: string;
}
