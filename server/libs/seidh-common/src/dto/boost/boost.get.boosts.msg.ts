export const BoostsGetPattern = 'boosts.get';

export interface BoostBody {
  id: string;
  order: number;
  name: string;
  description: string;
  price: number;
  accquired: boolean;
}

export interface BoostsGetRequest {
  userId: string;
}

export interface BoostsGetResponse {
  success: boolean;
  message?: string;
  boosts?: BoostBody[];
}
