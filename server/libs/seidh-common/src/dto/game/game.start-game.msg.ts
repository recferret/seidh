import { BasicServiceResponse } from '../basic.msg';

export const GameServiceStartGamePattern = 'game.start-game';

export interface GameServiceStartGameRequest {
  userId: string;
}

export interface GameServiceStartGameResponse extends BasicServiceResponse {
  gameId?: string;
}
