import { EventGameBase } from "./event.game.base";

export class EventGameDeleteCharacter implements EventGameBase {
    public static readonly EventName = 'game.delete-character';
    gameId: string;
    characterId: string;

    constructor(gameId: string, characterId: string) {
        this.gameId = gameId;
        this.characterId = characterId;
    }
}