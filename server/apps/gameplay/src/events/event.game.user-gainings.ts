import { UserGainings } from '@app/seidh-common/seidh-common.game-types';
import { EventGameBase } from './event.game.base';

export class EventGameUserGainings implements EventGameBase {
  public static readonly EventName = 'game.user-gainings';
  gameId: string;
  userGainings: UserGainings;

  constructor(gameId: string, userGainings: UserGainings) {
    this.gameId = gameId;
    this.userGainings = userGainings;
  }
}
