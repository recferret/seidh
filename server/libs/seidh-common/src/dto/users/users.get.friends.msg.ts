export const UsersGetFriendsPattern = 'users.get.friends';

export interface Friend {
    userId: string;
    telegramName: string;
    telegramPremium: boolean;
    referralReward: number
    online: boolean;
    playing: boolean;
    possibleToJoinGame: boolean;
}

export interface UsersGetFriendsMessageRequest {
    userId: string;
}

export interface UsersGetFriendsMessageResponse {
    success: boolean;
    friends?: Friend[];
}