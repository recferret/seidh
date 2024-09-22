import { GameFinishReason } from '@app/seidh-common/schemas/game/schema.game';

export class GameFinishGameRequestDto {
  gameId: string;
  reason: GameFinishReason;
}

export class GameFinishGameResponseDto {}
