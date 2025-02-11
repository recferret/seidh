import { CharacterEntityFullStruct } from '../../types/types.engine';

import { WsGatewayGameBaseMsg } from './ws-gateway.game.base.msg';

export const WsGatewayGameInitPattern = 'ws-gateway.game.init';

export interface WsGatewayGameInitMessage extends WsGatewayGameBaseMsg {
  charactersFullStruct: CharacterEntityFullStruct[];
}
