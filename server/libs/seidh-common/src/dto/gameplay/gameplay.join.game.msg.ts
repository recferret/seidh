export const GameplayJoinGamePattern = 'gameplay.join.game';

export interface GameplayJoinGameServiceMessage {
  userId: string;
  gameplayServiceId: string;
  gameId?: string;
}
