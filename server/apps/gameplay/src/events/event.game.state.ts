import { EventGameBase } from "./event.game.base";

export class EventGameGameState implements EventGameBase {
    public static readonly EventName = 'game.game-state'
    gameId: string;

    constructor(gameId: string) {
        this.gameId = gameId;
    }
}