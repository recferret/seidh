import { WsGatewayBaseMsg } from './ws-gateway.base.msg';

export const WsGatewayUserBalancePattern = 'ws-gateway.user.balance';

export interface WsGatewayUserBalanceMsg extends WsGatewayBaseMsg {
  balance: number;
}
