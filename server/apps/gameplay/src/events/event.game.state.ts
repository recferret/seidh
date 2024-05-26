import { CharacterEntityFullStruct, CharacterEntityMinStruct } from "@app/seidh-common/seidh-common.game-types";
import { EventGameBase } from "./event.game.base";

export class EventGameGameState implements EventGameBase {
    public static readonly EventName = 'game.game-state'
    gameId: string;
    charactersMinStruct: CharacterEntityMinStruct[];
    charactersFullStruct: CharacterEntityFullStruct[];

    constructor(gameId: string, charactersMinStruct: CharacterEntityMinStruct[], charactersFullStruct?: CharacterEntityFullStruct[]) {
        this.gameId = gameId;
        this.charactersMinStruct = charactersMinStruct;
        this.charactersFullStruct = charactersFullStruct;
    }
}