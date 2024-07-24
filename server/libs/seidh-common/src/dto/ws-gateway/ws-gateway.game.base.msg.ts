import { WsGatewayBaseMsg } from './ws-gateway.base.msg';

export interface WsGatewayGameBaseMsg extends WsGatewayBaseMsg {
  gameId: string;
}
