import { CharacterActionType } from "apps/gameplay/src/game/game.types";

export const GameplayJoinGamePattern = 'gameplay.input';

export interface GameplayInputMessage {
    playerId: string;
    gameId: string;

    index?: number;
	actionType: CharacterActionType;
	movAngle: number;
}