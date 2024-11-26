import { CharacterType } from '../types/types.character';

export const CharactersServiceCreatePattern = 'characters.create';

export interface CharactersServiceCreateRequest {
  characterType: CharacterType;
}

export interface CharactersServiceCreateResponse {
  success: boolean;
  characterId?: string;
}
