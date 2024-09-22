export const GameStartGamePattern = 'game.start.game';

export interface GameStartGameServiceRequest {
  userId: string;
}

export interface GameStartGameServiceResponse {
  success: boolean;
  gameId?: string;
}
