import {
  CharacterActionStruct,
  CharacterEntityShape,
  CharacterMovementStruct,
  CharacterType,
} from '../../types/types.character';

export const UsersServiceGetUserPattern = 'users.get-user';

export interface CharacterBody {
  id: string;
  type: CharacterType;
  active: boolean;
  levelCurrent: number;
  levelMax: number;
  expCurrent: number;
  expTillNextLevel: number;
  health: number;
  entityShape: CharacterEntityShape;
  movement: CharacterMovementStruct;
  actionMain: CharacterActionStruct;
}

export interface UserBody {
  userId: string;
  userName: string;

  telegramPremium: boolean;

  coins: number;
  teeth: number;

  // Chatacters
  characters: CharacterBody[];
}

export interface UsersServiceGetUserRequest {
  userId: string;
}

export interface UsersServiceGetUserResponse {
  success: boolean;
  user?: UserBody;
}
