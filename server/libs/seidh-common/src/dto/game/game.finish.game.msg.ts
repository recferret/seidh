import { GameFinishReason } from '@app/seidh-common/schemas/game/schema.game';

export const GameFinishGamePattern = 'game.finish.game';

export interface GameFinishGameServiceRequest {
  userId: string;
  gameId: string;
  reason: GameFinishReason;
}

export interface GameFinishGameServiceResponse {
  success: boolean;
}
