export const GameplayServiceJoinGamePattern = 'gameplay.join-game';

export interface GameplayServiceJoinGameMessage {
  userId: string;
  gameplayServiceId: string;
  gameId?: string;
}
