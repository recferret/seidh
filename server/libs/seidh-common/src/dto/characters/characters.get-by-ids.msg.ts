import { CharacterEntityParams } from '../../types/types.character';

import { BasicServiceResponse } from '../basic.msg';

export const CharactersServiceGetByIdsPattern = 'characters.get-by-ids';

export interface CharactersServiceGetByIdsRequest {
  ids: string[];
}

export interface CharactersServiceGetByIdsResponse extends BasicServiceResponse {
  characterParams?: CharacterEntityParams[];
}
