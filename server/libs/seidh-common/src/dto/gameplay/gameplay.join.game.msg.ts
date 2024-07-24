export const GameplayJoinGamePattern = 'gameplay.join.game';

export interface GameplayJoinGameMessage {
  userId: string;
  gameplayServiceId: string;
  gameId?: string;
}
