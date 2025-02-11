import { GameState } from '@lib/seidh-common/types/types.game';

import { WsGatewayGameBaseMsg } from './ws-gateway.game.base.msg';

export const WsGatewayGameGameStatePattern = 'ws-gateway.game.game.state';

export interface WsGatewayGameGameStateMessage extends WsGatewayGameBaseMsg {
  gameState: GameState;
}
