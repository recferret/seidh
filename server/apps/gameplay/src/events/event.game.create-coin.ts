import { CoinEntityStruct } from "@app/seidh-common/seidh-common.game-types";
import { EventGameBase } from "./event.game.base";

export class EventGameCreateCoin implements EventGameBase {
    public static readonly EventName = 'game.create-coin';
    gameId: string;
    coinEntityStruct: CoinEntityStruct;

    constructor(gameId: string, coinEntityStruct: CoinEntityStruct) { 
        this.gameId = gameId; 
        this.coinEntityStruct = coinEntityStruct;
    }
}