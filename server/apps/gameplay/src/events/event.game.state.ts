import { CharacterEntity, CharacterEntityMinStruct } from "@app/seidh-common/seidh-common.game-types";
import { EventGameBase } from "./event.game.base";

export class EventGameGameState implements EventGameBase {
    public static readonly EventName = 'game.game-state'
    gameId: string;
    charactersMin: CharacterEntityMinStruct[];
    charactersFull: CharacterEntity[];

    constructor(gameId: string, charactersMin: CharacterEntityMinStruct[], charactersFull: CharacterEntity[]) {
        this.gameId = gameId;
        this.charactersMin = charactersMin;
        this.charactersFull = charactersFull;
    }
}