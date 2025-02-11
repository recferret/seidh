import { CharacterEntityParams } from '../../types/types.character';

import { BasicServiceResponse } from '../basic.msg';

export const CharactersServiceGetDefaultParamsPattern = 'characters.get-default-params';

export interface CharactersServiceGetDefaultParamsResponse extends BasicServiceResponse {
  ragnarLoh?: CharacterEntityParams;
  zombieBoy?: CharacterEntityParams;
  zombieGirl?: CharacterEntityParams;
}
