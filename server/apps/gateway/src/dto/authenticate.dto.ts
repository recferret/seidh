export class AuthenticateRequestDTO {
  telegramInitData?: string; // for production, telegram user data
  login?: string; // for stage, login
  referrerId?: string;
}

export class AuthenticateResponseDTO {
  success: boolean;
  authToken?: string;
}
