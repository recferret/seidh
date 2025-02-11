import { CharacterType } from '../../types/types.character';

import { BasicServiceResponse } from '../basic.msg';

export const CharactersServiceCreatePattern = 'characters.create';

export interface CharactersServiceCreateRequest {
  characterType: CharacterType;
}

export interface CharactersServiceCreateResponse extends BasicServiceResponse {
  characterId?: string;
}
