export const GameplayJoinGamePattern = 'gameplay.join.game';

export interface GameplayJoinGameMessage {
    playerId: string;
    gameplayServiceId: string;
    gameId?: string;
}