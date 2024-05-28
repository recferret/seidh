import { CharacterActionCallbackParams } from "@app/seidh-common/seidh-common.game-types";
import { WsGatewayGameBaseMsg } from "./ws-gateway.game.base.msg";

export const WsGatewayGameCharacterActionsPattern = 'ws-gateway.game.character.actions';

export interface WsGatewayGameCharacterActionsMessage extends WsGatewayGameBaseMsg {
    actions: CharacterActionCallbackParams[];
}