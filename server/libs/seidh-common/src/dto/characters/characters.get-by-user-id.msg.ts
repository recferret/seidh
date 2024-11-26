export const CharactersServiceGetByUserIdPattern = 'characters.get-by-user-id';

export interface CharactersServiceGetByUserIdRequest {
  userId: string;
}

export interface CharactersServiceGetByUserIdResponse {
  success: boolean;
}
