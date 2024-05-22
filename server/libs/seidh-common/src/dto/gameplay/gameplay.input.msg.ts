import { CharacterActionType } from "@app/seidh-common/seidh-common.game-types";

export const GameplayInputPattern = 'gameplay.input';

export interface GameplayInputMessage {
    playerId: string;
    gameId: string;

    index?: number;
	actionType: CharacterActionType;
	movAngle: number;
}