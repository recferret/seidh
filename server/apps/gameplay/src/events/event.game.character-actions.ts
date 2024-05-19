import { EventGameBase } from "./event.game.base";

export class EventGameCharacterActions implements EventGameBase {
    public static readonly EventName = 'game.character-actions';
    gameId: string;

    constructor(gameId: string) {
        this.gameId = gameId;
    }
}