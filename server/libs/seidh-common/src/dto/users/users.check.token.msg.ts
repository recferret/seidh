export const UsersCheckTokenPattern = 'users.check.token';

export interface UsersCheckTokenServiceRequest {
  authToken: string;
}

export interface UsersCheckTokenServiceResponse {
  success: boolean;
}
