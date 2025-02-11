import { BasicServiceResponse } from '../basic.msg';

export const UsersServiceUpdateKillsPattern = 'users.update-kills';

export interface UsersServiceUpdateKillsRequest {
  userId: string;
  zombiesKilled: number;
}

export interface UsersServiceUpdateKillsResponse extends BasicServiceResponse {}
