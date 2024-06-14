import { CoinEntityStruct } from "@app/seidh-common/seidh-common.game-types";
import { WsGatewayGameBaseMsg } from "./ws-gateway.game.base.msg";

export const WsGatewayGameCreateCoinPattern = 'ws-gateway.game.create.coin';

export interface WsGatewayGameCreateCoinMessage extends WsGatewayGameBaseMsg {
    coinEntityStruct: CoinEntityStruct;
}