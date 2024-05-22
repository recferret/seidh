import { CharacterEntity } from "@app/seidh-common/seidh-common.game-types";
import { WsGatewayGameBaseMsg } from "./ws-gateway.game.base.msg";

export const WsGatewayGameInitPattern = 'ws-gateway.game.init';

export interface WsGatewayGameInitMessage extends WsGatewayGameBaseMsg {
    characters: CharacterEntity[];
}