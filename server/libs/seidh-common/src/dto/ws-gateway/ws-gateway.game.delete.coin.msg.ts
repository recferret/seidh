import { WsGatewayGameBaseMsg } from './ws-gateway.game.base.msg';

export const WsGatewayGameDeleteCoinPattern = 'ws-gateway.game.delete.coin';

export interface WsGatewayGameDeleteCoinMessage extends WsGatewayGameBaseMsg {
  id: string;
}
