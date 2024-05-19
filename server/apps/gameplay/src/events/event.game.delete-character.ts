import { EventGameBase } from "./event.game.base";

export class EventGameDeleteCharacter implements EventGameBase {
    public static readonly EventName = 'game.delete-character';
    gameId: string;

    constructor(gameId: string) {
        this.gameId = gameId;
    }
}