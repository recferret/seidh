export const UsersAuthenticatePattern = 'users.authenticate';

export interface UsersAuthenticateMessageRequest {
  telegramInitData?: string;
  login?: string;
  referrerId?: string;
}

export interface UsersAuthenticateMessageResponse {
  success: boolean;
  authToken?: string;
}
