import { CharacterEntityMinStruct } from '../../types/types.engine';

import { WsGatewayGameBaseMsg } from './ws-gateway.game.base.msg';

export const WsGatewayGameLoopStatePattern = 'ws-gateway.game.loop.state';

export interface WsGatewayGameLoopStateMessage extends WsGatewayGameBaseMsg {
  charactersMinStruct: CharacterEntityMinStruct[];
}
