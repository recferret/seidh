import { Controller } from '@nestjs/common';
import { MessagePattern } from '@nestjs/microservices';
import {
  WsGatewayWsController,
  WsProtocolMessage,
} from './ws-gateway.ws.controller';
import {
  WsGatewayGameInitPattern,
  WsGatewayGameInitMessage,
} from '@app/seidh-common/dto/ws-gateway/ws-gateway.game.init.msg';
import {
  WsGatewayGameCharacterActionsPattern,
  WsGatewayGameCharacterActionsMessage,
} from '@app/seidh-common/dto/ws-gateway/ws-gateway.game.character.actions.msg';
import {
  WsGatewayGameCreateCharacterPattern,
  WsGatewayGameCreateCharacterMessage,
} from '@app/seidh-common/dto/ws-gateway/ws-gateway.game.create.character.msg';
import {
  WsGatewayGameCreateProjectilePattern,
  WsGatewayGameCreateProjectileMessage,
} from '@app/seidh-common/dto/ws-gateway/ws-gateway.game.create.projectile.msg';
import {
  WsGatewayGameDeleteCharacterPattern,
  WsGatewayGameDeleteCharacterMessage,
} from '@app/seidh-common/dto/ws-gateway/ws-gateway.game.delete.character.msg';
import {
  WsGatewayGameDeleteProjectilePattern,
  WsGatewayGameDeleteProjectileMessage,
} from '@app/seidh-common/dto/ws-gateway/ws-gateway.game.delete.projectile.msg';
import {
  WsGatewayGameLoopStateMessage,
  WsGatewayGameLoopStatePattern,
} from '@app/seidh-common/dto/ws-gateway/ws-gateway.game.loop.state.msg';
import {
  WsGatewayGameGameStatePattern,
  WsGatewayGameGameStateMessage,
} from '@app/seidh-common/dto/ws-gateway/ws-gateway.game.game.state';
import {
  WsGatewayGameCreateConsumablePattern,
  WsGatewayGameCreateConsumableMessage,
} from '@app/seidh-common/dto/ws-gateway/ws-gateway.game.create.consumable.msg';
import {
  WsGatewayGameDeleteConsumablePattern,
  WsGatewayGameDeleteConsumableMessage,
} from '@app/seidh-common/dto/ws-gateway/ws-gateway.game.delete.consumable.msg';

@Controller()
export class WsGatewayController {
  constructor(private readonly wsGatewayWsController: WsGatewayWsController) {}

  // Init

  @MessagePattern(WsGatewayGameInitPattern)
  gameInit(data: WsGatewayGameInitMessage) {
    this.wsGatewayWsController.broadcast(WsProtocolMessage.GameInit, data);
  }

  // Character

  @MessagePattern(WsGatewayGameCreateCharacterPattern)
  createCharacter(data: WsGatewayGameCreateCharacterMessage) {
    this.wsGatewayWsController.broadcast(
      WsProtocolMessage.CreateCharacter,
      data,
    );
  }

  @MessagePattern(WsGatewayGameDeleteCharacterPattern)
  deleteCharacter(data: WsGatewayGameDeleteCharacterMessage) {
    this.wsGatewayWsController.broadcast(
      WsProtocolMessage.DeleteCharacter,
      data,
    );
  }

  // Consumable

  @MessagePattern(WsGatewayGameCreateConsumablePattern)
  createConsumable(data: WsGatewayGameCreateConsumableMessage) {
    this.wsGatewayWsController.broadcast(
      WsProtocolMessage.CreateConsumable,
      data,
    );
  }

  @MessagePattern(WsGatewayGameDeleteConsumablePattern)
  deleteConsumable(data: WsGatewayGameDeleteConsumableMessage) {
    this.wsGatewayWsController.broadcast(
      WsProtocolMessage.DeleteConsumable,
      data,
    );
  }

  // Projectile

  @MessagePattern(WsGatewayGameCreateProjectilePattern)
  createProjectile(data: WsGatewayGameCreateProjectileMessage) {
    this.wsGatewayWsController.broadcast(
      WsProtocolMessage.CreateProjectile,
      data,
    );
  }

  @MessagePattern(WsGatewayGameDeleteProjectilePattern)
  deleteProjectile(data: WsGatewayGameDeleteProjectileMessage) {
    this.wsGatewayWsController.broadcast(
      WsProtocolMessage.DeleteProjectile,
      data,
    );
  }

  // Actions

  @MessagePattern(WsGatewayGameCharacterActionsPattern)
  characterActions(data: WsGatewayGameCharacterActionsMessage) {
    this.wsGatewayWsController.broadcast(
      WsProtocolMessage.CharacterActions,
      data,
    );
  }

  // States

  @MessagePattern(WsGatewayGameLoopStatePattern)
  loopState(data: WsGatewayGameLoopStateMessage) {
    this.wsGatewayWsController.broadcast(WsProtocolMessage.LoopState, data);
  }

  @MessagePattern(WsGatewayGameGameStatePattern)
  gameState(data: WsGatewayGameGameStateMessage) {
    this.wsGatewayWsController.broadcast(WsProtocolMessage.GameState, data);
  }
}
