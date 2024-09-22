export const GameProgressGamePattern = 'game.progress.game';

export interface GameProgressGameServiceRequest {
  userId: string;
  gameId: string;
  mobsSpawned: number;
  mobsKilled: number;
  tokensGained: number;
}

export interface GameProgressGameServiceResponse {
  success: boolean;
}
