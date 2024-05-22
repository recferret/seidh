import { CharacterEntityMinStruct } from "@app/seidh-common/seidh-common.game-types";
import { EventGameBase } from "./event.game.base";

export class EventGameCreateCharacter implements EventGameBase {
    public static readonly EventName = 'game.create-character';
    gameId: string;
    characterMinEntity: CharacterEntityMinStruct;

    constructor(gameId: string, characterMinEntity: CharacterEntityMinStruct) { 
        this.gameId = gameId; 
        this.characterMinEntity = characterMinEntity;
    }
}