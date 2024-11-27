import { CharacterParams } from '@app/seidh-common/dto/types/types.character';

export class CharacterServiceGetDefaultParamsResponseDto {
  success: boolean;
  ragnarLoh?: CharacterParams;
  zombieBoy?: CharacterParams;
  zombieGirl?: CharacterParams;
}
