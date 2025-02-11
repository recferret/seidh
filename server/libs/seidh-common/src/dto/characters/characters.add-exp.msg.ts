import { BasicServiceResponse } from '../basic.msg';

export const CharactersServiceAddExpPattern = 'characters.add-exp';

export interface CharactersServiceAddExpRequest {
  userId: string;
  gameId: string;
  zombiesKilled: number;
}

export interface CharactersServiceAddExpResponse extends BasicServiceResponse {}
