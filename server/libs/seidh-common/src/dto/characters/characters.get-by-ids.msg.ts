import { CharacterParams } from "../types/types.character";

export const CharactersServiceGetByIdsPattern = 'characters.get-by-ids';

export interface CharactersServiceGetByIdsRequest {
  ids: string[];
}

export interface CharactersServiceGetByIdsResponse {
  success: boolean;

  characterParams?: CharacterParams[];
}
