import { CharacterActionType } from '../types/types.engine';

export const GameplayServiceInputPattern = 'gameplay.input';

export interface GameplayServiceInputMessage {
  userId: string;
  gameId: string;
  gameplayServiceId: string;
  actionType: CharacterActionType;
  movAngle?: number;
  index?: number;
}
