import { CharacterEntityFullStruct, CharacterEntityMinStruct } from "@app/seidh-common/seidh-common.game-types";
import { EventGameBase } from "./event.game.base";

export class EventGameLoopState implements EventGameBase {
    public static readonly EventName = 'game.loop-state'
    gameId: string;
    charactersMinStruct: CharacterEntityMinStruct[];
    charactersFullStruct: CharacterEntityFullStruct[];

    constructor(gameId: string, charactersMinStruct: CharacterEntityMinStruct[], charactersFullStruct?: CharacterEntityFullStruct[]) {
        this.gameId = gameId;
        this.charactersMinStruct = charactersMinStruct;
        this.charactersFullStruct = charactersFullStruct;
    }
}