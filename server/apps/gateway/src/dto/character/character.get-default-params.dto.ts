import { CharacterEntityParams } from '@lib/seidh-common/types/types.character';

export class CharacterServiceGetDefaultParamsResponseDto {
  success: boolean;
  ragnarLoh?: CharacterEntityParams;
  zombieBoy?: CharacterEntityParams;
  zombieGirl?: CharacterEntityParams;
}
