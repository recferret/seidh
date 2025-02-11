import { BoostType } from '../../types/types.boost';
import { CurrencyType } from '../../types/types.user';

import { BasicServiceResponse } from '../basic.msg';

export const BoostsServiceGetPattern = 'boosts.get';

export interface BoostBody {
  order: number;

  boostType: BoostType;

  levelZeroName: string;

  levelOneId: string;
  levelOneName: string;
  levelOneDescription1: string;
  levelOneDescription2?: string;
  levelOnePrice: number;
  levelOneCurrencyType: CurrencyType;
  levelOneAccquired: boolean;

  levelTwoId?: string;
  levelTwoName?: string;
  levelTwoDescription1?: string;
  levelTwoDescription2?: string;
  levelTwoPrice?: number;
  levelTwoCurrencyType?: CurrencyType;
  levelTwoAccquired?: boolean;

  levelThreeId?: string;
  levelThreeName?: string;
  levelThreeDescription1?: string;
  levelThreeDescription2?: string;
  levelThreePrice?: number;
  levelThreeCurrencyType?: CurrencyType;
  levelThreeAccquired?: boolean;
}

export interface BoostsServiceGetRequest {
  userId: string;
}

export interface BoostsServiceGetResponse extends BasicServiceResponse {
  boosts?: BoostBody[];
}
