import { EventGameBase } from './event.game.base';

export interface UserGainings {
  userId: string;
  gameId: string;
  kills: number;
  tokens: number;
}

export class EventGameUserGainings implements EventGameBase {
  public static readonly EventName = 'game.user-gainings';
  gameId: string;
  userGainings: UserGainings;

  constructor(gameId: string, userGainings: UserGainings) {
    this.gameId = gameId;
    this.userGainings = userGainings;
  }
}
