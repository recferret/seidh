export const GameServiceStartGamePattern = 'game.start-game';

export interface GameServiceStartGameRequest {
  userId: string;
}

export interface GameServiceStartGameResponse {
  success: boolean;
  gameId?: string;
}
