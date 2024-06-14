import { EventGameBase } from "./event.game.base";

export class EventGameDeleteCoin implements EventGameBase {
    public static readonly EventName = 'game.delete-coin';
    gameId: string;
    id: string;

    constructor(gameId: string, id: string) { 
        this.gameId = gameId; 
        this.id = id;
    }
}