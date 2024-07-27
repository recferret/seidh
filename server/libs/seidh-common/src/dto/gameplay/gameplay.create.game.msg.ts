import { GameType } from '@app/seidh-common/dto/gameplay-lobby/gameplay-lobby.find.game.msg';

export const GameplayCreateGamePattern = 'gameplay.create.new.game.room';

export interface GameplayCreateGameMessageRequest {
  gameType: GameType;
}

export interface GameplayCreateGameMessageResponse {
  success: boolean;
  gameId?: string;
  gameplayServiceId?: string;
}
