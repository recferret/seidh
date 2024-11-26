import { UserGainings } from "apps/gameplay/src/events/event.game.user-gainings";

export const UsersUpdateGainingsPattern = 'users.update.gainings';

export interface UsersUpdateGainingsServiceMessage {
  userGainings: UserGainings;
}
