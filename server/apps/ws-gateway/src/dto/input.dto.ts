import { CharacterActionType } from '@lib/seidh-common/types/types.engine';

export class InputDto {
  actionType: CharacterActionType;
  movAngle?: number;
}
