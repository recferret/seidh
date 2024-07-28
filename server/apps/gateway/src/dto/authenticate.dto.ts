import { UserCharacterStruct } from '@app/seidh-common/dto/users/users.authenticate.msg';

export class AuthenticateRequest {
  telegramInitData?: string; // for production, telegram user data
  login?: string; // for stage, login
  referrerId?: string;
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
