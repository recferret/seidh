export class AuthRequestDto {
  telegramInitData?: string; // for production, telegram user data
  login?: string; // for stage, login
  referrerId?: string;
}

export class AuthResponseDto {
  success: boolean;
  authToken?: string;
}
