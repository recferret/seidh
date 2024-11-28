import { CharacterEntityFullStruct } from '@app/seidh-common/seidh-common.boost-constants';
import { WsGatewayGameBaseMsg } from './ws-gateway.game.base.msg';

export const WsGatewayGameInitPattern = 'ws-gateway.game.init';

export interface WsGatewayGameInitMessage extends WsGatewayGameBaseMsg {
  charactersFullStruct: CharacterEntityFullStruct[];
}
