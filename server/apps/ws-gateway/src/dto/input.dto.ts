import { CharacterActionType } from '@app/seidh-common/seidh-common.boost-constants';

export class InputDto {
  actionType: CharacterActionType;
  movAngle?: number;
}
