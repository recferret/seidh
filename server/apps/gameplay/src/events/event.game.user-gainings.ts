import { GameGainings } from '@lib/seidh-common/types/types.game';

import { EventGameBase } from './event.game.base';

export class EventGameUserGainings implements EventGameBase {
  public static readonly EventName = 'game.user-gainings';
  gameId: string;
  gameGainings: GameGainings;

  constructor(gameId: string, gameGainings: GameGainings) {
    this.gameId = gameId;
    this.gameGainings = gameGainings;
  }
}
