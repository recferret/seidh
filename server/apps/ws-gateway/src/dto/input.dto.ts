import { CharacterActionType } from "@app/seidh-common/seidh-common.game-types";

export class InputDto {
    actionType: CharacterActionType;
    movAngle?: number;
}