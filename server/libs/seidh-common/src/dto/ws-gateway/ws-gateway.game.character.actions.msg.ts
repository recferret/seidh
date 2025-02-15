import { CharacterActionCallbackParams } from '../../types/types.engine';

import { WsGatewayGameBaseMsg } from './ws-gateway.game.base.msg';

export const WsGatewayGameCharacterActionsPattern = 'ws-gateway.game.character.actions';

export interface WsGatewayGameCharacterActionsMessage extends WsGatewayGameBaseMsg {
  actions: CharacterActionCallbackParams[];
}
