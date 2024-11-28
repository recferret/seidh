import { ConsumableEntityStruct } from '@app/seidh-common/seidh-common.boost-constants';
import { WsGatewayGameBaseMsg } from './ws-gateway.game.base.msg';

export const WsGatewayGameCreateConsumablePattern =
  'ws-gateway.game.create.consumable';

export interface WsGatewayGameCreateConsumableMessage
  extends WsGatewayGameBaseMsg {
  consumableEntityStruct: ConsumableEntityStruct;
}
