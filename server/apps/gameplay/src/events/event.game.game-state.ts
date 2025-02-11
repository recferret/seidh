import { GameState } from '@lib/seidh-common/types/types.game';

import { EventGameBase } from './event.game.base';

export class EventGameGameState implements EventGameBase {
  public static readonly EventName = 'game.game-state';
  gameId: string;
  gameState: GameState;

  constructor(gameId: string, gameState: GameState) {
    this.gameId = gameId;
    this.gameState = gameState;
  }
}
