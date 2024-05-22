import { Controller, Logger } from '@nestjs/common';
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
    Logger.log('gameInit, data:');
    Logger.log(data);
    this.wsGatewayWsController.broadcast(WsProtocol.GameInit, data);
  }

  @MessagePattern(WsGatewayGameCreateCharacterPattern)
  createCharacter(data: WsGatewayGameCreateCharacterMessage) {
    Logger.log('createCharacter, data:');
    Logger.log(data);
    this.wsGatewayWsController.broadcast(WsProtocol.CreateCharacter, data);
  }

  @MessagePattern(WsGatewayGameDeleteCharacterPattern)
  deleteCharacter(data: WsGatewayGameDeleteCharacterMessage) {
    Logger.log('deleteCharacter, data:');
    Logger.log(data);
    this.wsGatewayWsController.broadcast(WsProtocol.DeleteCharacter, data);
  }

  @MessagePattern(WsGatewayGameCreateProjectilePattern)
  createProjectile(data: WsGatewayGameCreateProjectileMessage) {
    Logger.log('createProjectile, data:');
    Logger.log(data);
    this.wsGatewayWsController.broadcast(WsProtocol.CreateProjectile, data);
  }

  @MessagePattern(WsGatewayGameDeleteProjectilePattern)
  deleteProjectile(data: WsGatewayGameDeleteProjectileMessage) {
    Logger.log('deleteProjectile, data:');
    Logger.log(data);
    this.wsGatewayWsController.broadcast(WsProtocol.DeleteProjectile, data);
  }

  @MessagePattern(WsGatewayGameCharacterActionsPattern)
  characterActions(data: WsGatewayGameCharacterActionsMessage) {
    Logger.log('characterActions, data:');
    Logger.log(data);
    this.wsGatewayWsController.broadcast(WsProtocol.CharacterActions, data);
  }

  @MessagePattern(WsGatewayGameStatePattern)
  gameState(data: WsGatewayGameStateMessage) {
    Logger.log('gameState, data:');
    Logger.log(data);
    this.wsGatewayWsController.broadcast(WsProtocol.GameState, data);
  }

}
