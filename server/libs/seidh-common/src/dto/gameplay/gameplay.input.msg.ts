import { CharacterActionType } from "@app/seidh-common/seidh-common.game-types";

export const GameplayInputPattern = 'gameplay.input';

export interface GameplayInputMessage {
    userId: string;
    gameId: string;
    gameplayServiceId: string;
	actionType: CharacterActionType;
	movAngle?: number;
    index?: number;
}