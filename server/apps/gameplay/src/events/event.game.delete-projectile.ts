import { EventGameBase } from "./event.game.base";

export class EventGameDeleteProjectile implements EventGameBase {
    public static readonly EventName = 'game.delete-projectile';
    gameId: string;

    constructor(gameId: string) {
        this.gameId = gameId;
    }
}