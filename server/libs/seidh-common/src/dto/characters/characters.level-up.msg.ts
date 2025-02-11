import { BasicServiceResponse } from '../basic.msg';

export const CharactersServiceLevelUpPattern = 'characters.level-up';

export interface CharactersServiceLevelUpRequest {
  userId: string;
  coins?: number;
  teeth?: number;
}

export interface CharactersServiceLevelUpResponse extends BasicServiceResponse {}
