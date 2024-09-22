import { UserGainings } from '@app/seidh-common/seidh-common.game-types';

export const UsersUpdateGainingsPattern = 'users.update.gainings';

export interface UsersUpdateGainingsServiceMessage {
  userGainings: UserGainings;
}
