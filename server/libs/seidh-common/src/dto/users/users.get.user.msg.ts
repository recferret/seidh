import { CharacterType, CharacterMovementStruct, CharacterActionStruct } from "../types/types.character";

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

  coins: number;
  teeth: number;

  // Chatacters
  characters: CharacterBody[];
}

export interface UsersGetUserServiceRequest {
  userId: string;
}

export interface UsersGetUserServiceResponse {
  success: boolean;
  user?: UserBody;
}
