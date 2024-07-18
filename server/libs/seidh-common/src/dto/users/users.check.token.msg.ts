export const UsersCheckTokenPattern = 'users.check.token';

export interface UsersCheckTokenMessageRequest {
    authToken: string;
}

export interface UsersCheckTokenMessageResponse {
    success: boolean;
}