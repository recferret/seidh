export const GameServiceProgressGamePattern = 'game.progress-game';

export interface GameServiceProgressGameRequest {
  userId: string;
  gameId: string;
  mobsSpawned: number;
  mobsKilled: number;
  tokensGained: number;
}

export interface GameServiceProgressGameResponse {
  success: boolean;
}
