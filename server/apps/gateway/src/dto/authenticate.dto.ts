import { UserCharacterStruct } from "@app/seidh-common/dto/users/users.authenticate.msg";

export class AuthenticateRequest {
    telegramInitData: string;
}

export class AuthenticateResponse {
    success: boolean;
    telegramName?: string;
    authToken?: string;
    tokens?: number;
    kills?: number;
    characters?: UserCharacterStruct[];
}