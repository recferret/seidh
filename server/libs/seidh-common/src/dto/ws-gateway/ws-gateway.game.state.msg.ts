import { CharacterEntityMinStruct } from "@app/seidh-common/seidh-common.game-types";
import { WsGatewayGameBaseMsg } from "./ws-gateway.game.base.msg";

export const WsGatewayGameStatePattern = 'ws-gateway.game.state';

export interface WsGatewayGameStateMessage extends WsGatewayGameBaseMsg {
    charactersMinStruct: CharacterEntityMinStruct[];
}