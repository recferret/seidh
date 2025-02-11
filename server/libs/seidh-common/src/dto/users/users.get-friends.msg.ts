import { BasicServiceResponse } from '../basic.msg';

export const UsersServiceGetFriendsPattern = 'users.get-friends';

export interface Friend {
  userId: string;
  telegramName: string;
  telegramPremium?: boolean;
  referralReward: number;
  online: boolean;
  playing?: boolean;
  possibleToJoinGame?: boolean;
}

export interface UsersServiceGetFriendsRequest {
  userId: string;
}

export interface UsersServiceGetFriendsResponse extends BasicServiceResponse {
  friends?: Friend[];
  friendsInvited?: number;
  coins?: number;
}
