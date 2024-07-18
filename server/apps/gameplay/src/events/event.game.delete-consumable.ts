import { EventGameBase } from "./event.game.base";

export class EventGameDeleteConsumable implements EventGameBase {
    public static readonly EventName = 'game.delete-consumable';
    gameId: string;
    entityId: string;
    takenByCharacterId: string;

    constructor(gameId: string, entityId: string, takenByCharacterId: string) { 
        this.gameId = gameId; 
        this.entityId = entityId;
        this.takenByCharacterId = takenByCharacterId;
    }
}