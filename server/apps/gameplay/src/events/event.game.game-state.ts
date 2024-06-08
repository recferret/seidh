import { GameState } from "@app/seidh-common/seidh-common.game-types";
import { EventGameBase } from "./event.game.base";

export class EventGameGameState implements EventGameBase {
    public static readonly EventName = 'game.game-state';
    gameId: string;
    gameState: GameState;

    constructor(gameId: string, gameState: GameState) {
        this.gameId = gameId;
        this.gameState = gameState;
    }
}