import { Controller } from '@nestjs/common';
import { MessagePattern } from '@nestjs/microservices';
import { WsGatewayWsController, WsProtocol } from './ws-gateway.ws.controller';
import { WsGatewayGameInitPattern, WsGatewayGameInitMessage } from '@app/seidh-common/dto/ws-gateway/ws-gateway.game.init.msg';
import { WsGatewayGameCharacterActionsPattern, WsGatewayGameCharacterActionsMessage } from '@app/seidh-common/dto/ws-gateway/ws-gateway.game.character.actions.msg';
import { WsGatewayGameCreateCharacterPattern, WsGatewayGameCreateCharacterMessage } from '@app/seidh-common/dto/ws-gateway/ws-gateway.game.create.character.msg';
import { WsGatewayGameCreateProjectilePattern, WsGatewayGameCreateProjectileMessage } from '@app/seidh-common/dto/ws-gateway/ws-gateway.game.create.projectile.msg';
import { WsGatewayGameDeleteCharacterPattern, WsGatewayGameDeleteCharacterMessage } from '@app/seidh-common/dto/ws-gateway/ws-gateway.game.delete.character.msg';
import { WsGatewayGameDeleteProjectilePattern, WsGatewayGameDeleteProjectileMessage } from '@app/seidh-common/dto/ws-gateway/ws-gateway.game.delete.projectile.msg';
import { WsGatewayGameStatePattern, WsGatewayGameStateMessage } from '@app/seidh-common/dto/ws-gateway/ws-gateway.game.state.msg';

@Controller()
export class WsGatewayController {
  
  constructor(private readonly wsGatewayWsController: WsGatewayWsController) { }

  @MessagePattern(WsGatewayGameInitPattern)
  gameInit(data: WsGatewayGameInitMessage) {
    this.wsGatewayWsController.broadcast(WsProtocol.GameInit, data);
  }

  @MessagePattern(WsGatewayGameCreateCharacterPattern)
  createCharacter(data: WsGatewayGameCreateCharacterMessage) {
    this.wsGatewayWsController.broadcast(WsProtocol.CreateCharacter, data);
  }

  @MessagePattern(WsGatewayGameDeleteCharacterPattern)
  deleteCharacter(data: WsGatewayGameDeleteCharacterMessage) {
    this.wsGatewayWsController.broadcast(WsProtocol.DeleteCharacter, data);
  }

  @MessagePattern(WsGatewayGameCreateProjectilePattern)
  createProjectile(data: WsGatewayGameCreateProjectileMessage) {
    this.wsGatewayWsController.broadcast(WsProtocol.CreateProjectile, data);
  }

  @MessagePattern(WsGatewayGameDeleteProjectilePattern)
  deleteProjectile(data: WsGatewayGameDeleteProjectileMessage) {
    this.wsGatewayWsController.broadcast(WsProtocol.DeleteProjectile, data);
  }

  @MessagePattern(WsGatewayGameCharacterActionsPattern)
  characterActions(data: WsGatewayGameCharacterActionsMessage) {
    this.wsGatewayWsController.broadcast(WsProtocol.CharacterActions, data);
  }

  @MessagePattern(WsGatewayGameStatePattern)
  gameState(data: WsGatewayGameStateMessage) {
    this.wsGatewayWsController.broadcast(WsProtocol.GameState, data);
  }

}
