import { CharacterActionType } from "@app/seidh-common/seidh-common.game-types";

export class InputDto {
    playerId: string;
    actionType: CharacterActionType;
    movAngle?: number;
}