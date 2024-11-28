import { GameState } from '@app/seidh-common/seidh-common.boost-constants';
import { WsGatewayGameBaseMsg } from './ws-gateway.game.base.msg';

export const WsGatewayGameGameStatePattern = 'ws-gateway.game.game.state';

export interface WsGatewayGameGameStateMessage extends WsGatewayGameBaseMsg {
  gameState: GameState;
}
