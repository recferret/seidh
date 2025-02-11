import { BasicServiceResponse } from '../basic.msg';

export const GameServiceProgressGamePattern = 'game.progress-game';

export interface GameServiceProgressGameRequest {
  userId: string;
  gameId: string;

  zombiesKilled: number;
  coinsGained: number;
}

export interface GameServiceProgressGameResponse extends BasicServiceResponse {}
