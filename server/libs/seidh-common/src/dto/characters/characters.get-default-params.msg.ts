import { CharacterParams } from '../types/types.character';

export const CharactersServiceGetDefaultParamsPattern =
  'characters.get-default-params';

export interface CharactersServiceGetDefaultParamsResponse {
  success: boolean;
  ragnarLoh?: CharacterParams;
  zombieBoy?: CharacterParams;
  zombieGirl?: CharacterParams;
}
