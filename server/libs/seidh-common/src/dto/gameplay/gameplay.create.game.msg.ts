import { GameplayType } from '@app/seidh-common/dto/gameplay-lobby/gameplay-lobby.find.game.msg';

export const GameplayCreateGamePattern = 'gameplay.create.new.game.room';

export interface GameplayCreateGameServiceRequest {
  gameplayType: GameplayType;
}

export interface GameplayCreateGameServiceResponse {
  success: boolean;
  gameId?: string;
  gameplayServiceId?: string;
}
