export const CharactersServiceGetPattern = 'characters.get';

export interface CharactersServiceGetRequest {
  userId: string;
}

export interface CharactersServiceGetResponse {
  success: boolean;
}
