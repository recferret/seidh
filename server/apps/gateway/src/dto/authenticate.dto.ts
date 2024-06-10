import { UserCharacterStruct } from "@app/seidh-common/dto/users/users.authenticate.msg";

export class AuthenticateRequest {
    telegramInitData: string;
    startParam?: string;
}

export class AuthenticateResponse {
    success: boolean;
    userId?: string;
    telegramName?: string;
    authToken?: string;
    tokens?: number;
    kills?: number;
    characters?: UserCharacterStruct[];
}