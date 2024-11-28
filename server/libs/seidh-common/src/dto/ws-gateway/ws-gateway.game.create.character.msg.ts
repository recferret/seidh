import { CharacterEntityFullStruct } from '@app/seidh-common/seidh-common.boost-constants';
import { WsGatewayGameBaseMsg } from './ws-gateway.game.base.msg';

export const WsGatewayGameCreateCharacterPattern =
  'ws-gateway.game.create.character';

export interface WsGatewayGameCreateCharacterMessage
  extends WsGatewayGameBaseMsg {
  characterEntityFullStruct: CharacterEntityFullStruct;
}
