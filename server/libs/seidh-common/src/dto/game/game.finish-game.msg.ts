import { GameFinishReason } from '@app/seidh-common/schemas/game/schema.game';

export const GameServiceFinishGamePattern = 'game.finish-game';

export interface GameServiceFinishGameRequest {
  userId: string;
  gameId: string;
  reason: GameFinishReason;
}

export interface GameServiceFinishGameResponse {
  success: boolean;
}
