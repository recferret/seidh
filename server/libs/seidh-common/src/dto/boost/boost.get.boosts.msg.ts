export const BoostsGetPattern = 'boosts.get';

export interface BoostBody {
  id: string;
  order: number;
  name: string;
  description: string;
  price: number;
  accquired: boolean;
}

export interface BoostsGetServiceRequest {
  userId: string;
}

export interface BoostsGetServiceResponse {
  success: boolean;
  message?: string;
  boosts?: BoostBody[];
}
