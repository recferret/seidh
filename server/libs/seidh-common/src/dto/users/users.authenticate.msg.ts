export const UsersAuthenticatePattern = 'users.authenticate';

export interface UsersAuthenticateServiceRequest {
  telegramInitData?: string;
  login?: string;
  referrerId?: string;
}

export interface UsersAuthenticateServiceResponse {
  success: boolean;
  authToken?: string;
  publicRsaKey?: string;
}
