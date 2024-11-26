import { CharacterActionType } from '@app/seidh-common/seidh-common.game-types';

export const GameplayServiceInputPattern = 'gameplay.input';

export interface GameplayServiceInputMessage {
  userId: string;
  gameId: string;
  gameplayServiceId: string;
  actionType: CharacterActionType;
  movAngle?: number;
  index?: number;
}
