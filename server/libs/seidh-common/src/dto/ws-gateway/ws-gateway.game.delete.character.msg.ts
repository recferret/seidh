import { WsGatewayGameBaseMsg } from './ws-gateway.game.base.msg';

export const WsGatewayGameDeleteCharacterPattern = 'ws-gateway.game.delete.character';

export interface WsGatewayGameDeleteCharacterMessage extends WsGatewayGameBaseMsg {
  characterId: string;
}
