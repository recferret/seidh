import { GameplayType } from '@lib/seidh-common/dto/gameplay-lobby/gameplay-lobby.find-game.msg';

import { BasicServiceResponse } from '../basic.msg';

export const GameplayServiceCreateGamePattern = 'gameplay.create-new-game-room';

export interface GameplayServiceCreateGameRequest {
  gameplayType: GameplayType;
}

export interface GameplayServiceCreateGameResponse extends BasicServiceResponse {
  gameId?: string;
  gameplayServiceId?: string;
}
