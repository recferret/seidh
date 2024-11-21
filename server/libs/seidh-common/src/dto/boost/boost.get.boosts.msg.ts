import {
  BoostType,
  CurrencyType,
} from '@app/seidh-common/schemas/boost/schema.boost';

export const BoostsGetPattern = 'boosts.get';

export interface BoostBody {
  order: number;

  boostType: BoostType;

  levelZeroName: string;

  levelOneId: string;
  levelOneName: string;
  levelOneDescription: string;
  levelOnePrice: number;
  levelOneCurrencyType: CurrencyType;
  levelOneAccquired: boolean;

  levelTwoId: string;
  levelTwoName: string;
  levelTwoDescription: string;
  levelTwoPrice: number;
  levelTwoCurrencyType: CurrencyType;
  levelTwoAccquired: boolean;

  levelThreeId: string;
  levelThreeName: string;
  levelThreeDescription: string;
  levelThreePrice: number;
  levelThreeCurrencyType: CurrencyType;
  levelThreeAccquired: boolean;
}

export interface BoostsGetServiceRequest {
  userId: string;
}

export interface BoostsGetServiceResponse {
  success: boolean;
  message?: string;
  boosts?: BoostBody[];
}
