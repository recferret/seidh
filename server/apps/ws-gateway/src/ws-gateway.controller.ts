import { Controller } from '@nestjs/common';
import { MessagePattern } from '@nestjs/microservices';
import { WsGatewayWsController, WsProtocolMessage } from './ws-gateway.ws.controller';
import { WsGatewayGameInitPattern, WsGatewayGameInitMessage } from '@app/seidh-common/dto/ws-gateway/ws-gateway.game.init.msg';
import { WsGatewayGameCharacterActionsPattern, WsGatewayGameCharacterActionsMessage } from '@app/seidh-common/dto/ws-gateway/ws-gateway.game.character.actions.msg';
import { WsGatewayGameCreateCharacterPattern, WsGatewayGameCreateCharacterMessage } from '@app/seidh-common/dto/ws-gateway/ws-gateway.game.create.character.msg';
import { WsGatewayGameCreateProjectilePattern, WsGatewayGameCreateProjectileMessage } from '@app/seidh-common/dto/ws-gateway/ws-gateway.game.create.projectile.msg';
import { WsGatewayGameDeleteCharacterPattern, WsGatewayGameDeleteCharacterMessage } from '@app/seidh-common/dto/ws-gateway/ws-gateway.game.delete.character.msg';
import { WsGatewayGameDeleteProjectilePattern, WsGatewayGameDeleteProjectileMessage } from '@app/seidh-common/dto/ws-gateway/ws-gateway.game.delete.projectile.msg';
import { WsGatewayGameLoopStateMessage, WsGatewayGameLoopStatePattern } from '@app/seidh-common/dto/ws-gateway/ws-gateway.game.loop.state.msg';
import { WsGatewayGameGameStatePattern, WsGatewayGameGameStateMessage } from '@app/seidh-common/dto/ws-gateway/ws-gateway.game.game.state';

@Controller()
export class WsGatewayController {
  
  constructor(private readonly wsGatewayWsController: WsGatewayWsController) { }

  @MessagePattern(WsGatewayGameInitPattern)
  gameInit(data: WsGatewayGameInitMessage) {
    this.wsGatewayWsController.broadcast(WsProtocolMessage.GameInit, data);
  }

  @MessagePattern(WsGatewayGameCreateCharacterPattern)
  createCharacter(data: WsGatewayGameCreateCharacterMessage) {
    this.wsGatewayWsController.broadcast(WsProtocolMessage.CreateCharacter, data);
  }

  @MessagePattern(WsGatewayGameDeleteCharacterPattern)
  deleteCharacter(data: WsGatewayGameDeleteCharacterMessage) {
    this.wsGatewayWsController.broadcast(WsProtocolMessage.DeleteCharacter, data);
  }

  @MessagePattern(WsGatewayGameCreateProjectilePattern)
  createProjectile(data: WsGatewayGameCreateProjectileMessage) {
    this.wsGatewayWsController.broadcast(WsProtocolMessage.CreateProjectile, data);
  }

  @MessagePattern(WsGatewayGameDeleteProjectilePattern)
  deleteProjectile(data: WsGatewayGameDeleteProjectileMessage) {
    this.wsGatewayWsController.broadcast(WsProtocolMessage.DeleteProjectile, data);
  }

  @MessagePattern(WsGatewayGameCharacterActionsPattern)
  characterActions(data: WsGatewayGameCharacterActionsMessage) {
    this.wsGatewayWsController.broadcast(WsProtocolMessage.CharacterActions, data);
  }

  @MessagePattern(WsGatewayGameLoopStatePattern)
  loopState(data: WsGatewayGameLoopStateMessage) {
    this.wsGatewayWsController.broadcast(WsProtocolMessage.LoopState, data);
  }

  @MessagePattern(WsGatewayGameGameStatePattern)
  gameState(data: WsGatewayGameGameStateMessage) {
    this.wsGatewayWsController.broadcast(WsProtocolMessage.GameState, data);
  }

}
