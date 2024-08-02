export class AuthenticateRequest {
  telegramInitData?: string; // for production, telegram user data
  login?: string; // for stage, login
  referrerId?: string;
}

export class AuthenticateResponse {
  success: boolean;
  authToken?: string;
}
