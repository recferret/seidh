export const UsersGetFriendsPattern = 'users.get.friends';

export interface Friend {
  userId: string;
  telegramName: string;
  telegramPremium?: boolean;
  referralReward: number;
  online: boolean;
  playing?: boolean;
  possibleToJoinGame?: boolean;
}

export interface UsersGetFriendsServiceRequest {
  userId: string;
}

export interface UsersGetFriendsServiceResponse {
  success: boolean;
  friends?: Friend[];
  friendsInvited?: number;
  virtualTokenBalance?: number;
}
