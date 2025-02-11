import { GameFinishReason } from '../../types/types.game';

import { BasicServiceResponse } from '../basic.msg';

export const GameServiceFinishGamePattern = 'game.finish-game';

export interface GameServiceFinishGameRequest {
  userId: string;
  gameId: string;

  zombiesKilled: number;
  coinsGained: number;

  reason: GameFinishReason;
}

export interface GameServiceFinishGameResponse extends BasicServiceResponse {}
