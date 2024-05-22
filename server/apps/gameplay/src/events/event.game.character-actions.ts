import { CharacterActionCallbackParams } from "@app/seidh-common/seidh-common.game-types";
import { EventGameBase } from "./event.game.base";

export class EventGameCharacterActions implements EventGameBase {
    public static readonly EventName = 'game.character-actions';
    gameId: string;
    actions: CharacterActionCallbackParams[];

    constructor(gameId: string, actions: CharacterActionCallbackParams[]) {
        this.gameId = gameId;
        this.actions = actions;
    }
}