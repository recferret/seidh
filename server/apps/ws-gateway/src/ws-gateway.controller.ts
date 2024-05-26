import { Controller, Logger } from '@nestjs/common';
import { MessagePattern } from '@nestjs/microservices';
import { WsGatewayWsController, WsProtocolMessage } from './ws-gateway.ws.controller';
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
    this.wsGatewayWsController.broadcast(WsProtocolMessage.GameInit, data);
  }

  @MessagePattern(WsGatewayGameCreateCharacterPattern)
  createCharacter(data: WsGatewayGameCreateCharacterMessage) {
    Logger.log(`createCharacter excludePlayerId: ${data.excludePlayerId}. targetPlayerId: ${data.targetPlayerId}`);
    this.wsGatewayWsController.broadcast(WsProtocolMessage.CreateCharacter, data);
  }

  @MessagePattern(WsGatewayGameDeleteCharacterPattern)
  deleteCharacter(data: WsGatewayGameDeleteCharacterMessage) {
    Logger.log('deleteCharacter, data:');
    Logger.log(data);
    this.wsGatewayWsController.broadcast(WsProtocolMessage.DeleteCharacter, data);
  }

  @MessagePattern(WsGatewayGameCreateProjectilePattern)
  createProjectile(data: WsGatewayGameCreateProjectileMessage) {
    Logger.log('createProjectile, data:');
    Logger.log(data);
    this.wsGatewayWsController.broadcast(WsProtocolMessage.CreateProjectile, data);
  }

  @MessagePattern(WsGatewayGameDeleteProjectilePattern)
  deleteProjectile(data: WsGatewayGameDeleteProjectileMessage) {
    Logger.log('deleteProjectile, data:');
    Logger.log(data);
    this.wsGatewayWsController.broadcast(WsProtocolMessage.DeleteProjectile, data);
  }

  @MessagePattern(WsGatewayGameCharacterActionsPattern)
  characterActions(data: WsGatewayGameCharacterActionsMessage) {
    Logger.log('characterActions, data:');
    Logger.log(data);
    this.wsGatewayWsController.broadcast(WsProtocolMessage.CharacterActions, data);
  }

  @MessagePattern(WsGatewayGameStatePattern)
  gameState(data: WsGatewayGameStateMessage) {
    this.wsGatewayWsController.broadcast(WsProtocolMessage.GameState, data);
  }

}
