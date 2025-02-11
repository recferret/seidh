import { ConsumableEntityStruct } from '../../types/types.engine';

import { WsGatewayGameBaseMsg } from './ws-gateway.game.base.msg';

export const WsGatewayGameCreateCoinPattern = 'ws-gateway.game.create.coin';

export interface WsGatewayGameCreateCoinMessage extends WsGatewayGameBaseMsg {
  сonsumableEntityStruct: ConsumableEntityStruct;
}
