import { GameplayType } from '@app/seidh-common/dto/gameplay-lobby/gameplay-lobby.find.game.msg';

export const GameplayServiceCreateGamePattern = 'gameplay.create-new-game-room';

export interface GameplayServiceCreateGameRequest {
  gameplayType: GameplayType;
}

export interface GameplayServiceCreateGameResponse {
  success: boolean;
  gameId?: string;
  gameplayServiceId?: string;
}
