import { VkLaunchParams } from '@lib/seidh-common/types/types.vk';

import { BasicServiceResponse } from '../basic.msg';

export const UsersServiceTgAuthPattern = 'users.auth-tg';
export const UsersServiceVkAuthPattern = 'users.auth-vk';
export const UsersServiceSimpleAuthPattern = 'users.auth-simple';

export interface UsersServiceTgAuthRequest {
  telegramInitData?: string;
  referrerId?: string;
}

export interface UsersServiceVkAuthRequest {
  vkLaunchParams: VkLaunchParams;
  first_name?: string;
  last_name?: string;
}

export interface UsersServiceSimpleAuthRequest {
  login: string;
}

export interface UsersServiceAuthenticateResponse extends BasicServiceResponse {
  authToken?: string;
  publicRsaKey?: string;
}
