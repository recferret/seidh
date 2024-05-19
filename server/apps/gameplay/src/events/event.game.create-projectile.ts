import { EventGameBase } from "./event.game.base";

export class EventGameCreateProjectile implements EventGameBase {
    public static readonly EventName = 'game.create-projectile';
    gameId: string;

    constructor(gameId: string) {
        this.gameId = gameId;
    }
}