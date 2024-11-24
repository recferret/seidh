import { GameFinishReason } from '@app/seidh-common/schemas/game/schema.game';

export class GameServiceFinishGameRequestDto {
  gameId: string;
  reason: GameFinishReason;
}

export class GameServiceFinishGameResponseDto {}
