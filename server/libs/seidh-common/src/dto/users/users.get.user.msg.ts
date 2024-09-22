import { CharacterType } from '@app/seidh-common/schemas/character/schema.character';
import {
  CharacterMovementStruct,
  CharacterActionStruct,
} from '@app/seidh-common/seidh-common.game-types';

export const UsersGetUserPattern = 'users.get.user';

export interface CharacterBody {
  id: string;
  type: CharacterType;
  active: boolean;
  levelCurrent: number;
  levelMax: number;
  expCurrent: number;
  expTillNewLevel: number;
  health: number;
  movement: CharacterMovementStruct;
  actionMain: CharacterActionStruct;
}

export interface UserBody {
  userId: string;
  telegramName: string;
  telegramPremium: boolean;

  virtualTokenBalance: number;

  // Chatacters
  characters: CharacterBody[];

  hasExpBoost1: boolean;
  hasExpBoost2: boolean;
  hasPotionDropBoost1: boolean;
  hasPotionDropBoost2: boolean;
  hasMaxPotionBoost1: boolean;
  hasMaxPotionBoost2: boolean;
  hasMaxPotionBoost3: boolean;
}

export interface UsersGetUserServiceRequest {
  userId: string;
}

export interface UsersGetUserServiceResponse {
  success: boolean;
  user?: UserBody;
}
