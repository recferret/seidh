import { WsGatewayGameBaseMsg } from './ws-gateway.game.base.msg';

export const WsGatewayGameDeleteConsumablePattern =
  'ws-gateway.game.delete.consumable';

export interface WsGatewayGameDeleteConsumableMessage
  extends WsGatewayGameBaseMsg {
  entityId: string;
  takenByCharacterId: string;
}
