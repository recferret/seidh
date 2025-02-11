import { BasicServiceResponse } from '../basic.msg';

export const UsersServiceCheckTokenPattern = 'users.check-token';

export interface UsersServiceCheckTokenRequest {
  authToken: string;
}

export interface UsersServiceCheckTokenResponse extends BasicServiceResponse {}
