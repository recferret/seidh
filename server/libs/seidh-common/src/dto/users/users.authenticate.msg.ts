import { CharacterActionStruct, CharacterMovementStruct, CharacterType } from "@app/seidh-common/schemas/schema.character";

export const UsersAuthenticatePattern = 'users.authenticate';

export interface UserCharacterStruct {
    id: string;
    active: boolean;
    type: CharacterType;
    levelCurrent: number;
    levelMax: number;
    expCurrent: number;
    expTillNewLevel: number;
    health: number;
    movement: CharacterMovementStruct;
    actionMain: CharacterActionStruct;
}

export interface UsersAuthenticateMessageRequest {
    telegramInitData: string;
    startParam?: string;
}

export interface UsersAuthenticateMessageResponse {
    success: boolean;
    userId?: string;
    telegramName?: string;
    authToken?: string;
    tokens?: number;
    kills?: number;
    characters?: UserCharacterStruct[];
}