import { GameFinishReason } from '@lib/seidh-common/types/types.game';

export class GameServiceFinishGameRequestDto {
  gameId: string;
  reason: GameFinishReason;
  zombiesKilled: number;
  coinsGained: number;
}

export class GameServiceFinishGameResponseDto {
  success: boolean;
}
