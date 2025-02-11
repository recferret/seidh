import { Controller, Logger } from '@nestjs/common';
import { MessagePattern } from '@nestjs/microservices';

import { WsGatewayWsController, WsProtocolMessage } from './ws-gateway.ws.controller';

import {
  WsGatewayGameCharacterActionsMessage,
  WsGatewayGameCharacterActionsPattern,
} from '@lib/seidh-common/dto/ws-gateway/ws-gateway.game.character.actions.msg';
import {
  WsGatewayGameCreateCharacterMessage,
  WsGatewayGameCreateCharacterPattern,
} from '@lib/seidh-common/dto/ws-gateway/ws-gateway.game.create.character.msg';
import {
  WsGatewayGameCreateConsumableMessage,
  WsGatewayGameCreateConsumablePattern,
} from '@lib/seidh-common/dto/ws-gateway/ws-gateway.game.create.consumable.msg';
import {
  WsGatewayGameCreateProjectileMessage,
  WsGatewayGameCreateProjectilePattern,
} from '@lib/seidh-common/dto/ws-gateway/ws-gateway.game.create.projectile.msg';
import {
  WsGatewayGameDeleteCharacterMessage,
  WsGatewayGameDeleteCharacterPattern,
} from '@lib/seidh-common/dto/ws-gateway/ws-gateway.game.delete.character.msg';
import {
  WsGatewayGameDeleteConsumableMessage,
  WsGatewayGameDeleteConsumablePattern,
} from '@lib/seidh-common/dto/ws-gateway/ws-gateway.game.delete.consumable.msg';
import {
  WsGatewayGameDeleteProjectileMessage,
  WsGatewayGameDeleteProjectilePattern,
} from '@lib/seidh-common/dto/ws-gateway/ws-gateway.game.delete.projectile.msg';
import {
  WsGatewayGameGameStateMessage,
  WsGatewayGameGameStatePattern,
} from '@lib/seidh-common/dto/ws-gateway/ws-gateway.game.game.state';
import {
  WsGatewayGameInitMessage,
  WsGatewayGameInitPattern,
} from '@lib/seidh-common/dto/ws-gateway/ws-gateway.game.init.msg';
import {
  WsGatewayGameLoopStateMessage,
  WsGatewayGameLoopStatePattern,
} from '@lib/seidh-common/dto/ws-gateway/ws-gateway.game.loop.state.msg';
import {
  WsGatewayUserBalanceMsg,
  WsGatewayUserBalancePattern,
} from '@lib/seidh-common/dto/ws-gateway/ws-gateway.user.balance.msg';

@Controller()
export class WsGatewayController {
  constructor(private readonly wsGatewayWsController: WsGatewayWsController) {}

  // --------------------------------------
  // GAME EVENTS
  // --------------------------------------

  // Init

  @MessagePattern(WsGatewayGameInitPattern)
  gameInit(data: WsGatewayGameInitMessage) {
    this.wsGatewayWsController.gameBroadcast(WsProtocolMessage.GameInit, data);
  }

  // Character

  @MessagePattern(WsGatewayGameCreateCharacterPattern)
  createCharacter(data: WsGatewayGameCreateCharacterMessage) {
    this.wsGatewayWsController.gameBroadcast(WsProtocolMessage.CreateCharacter, data);
  }

  @MessagePattern(WsGatewayGameDeleteCharacterPattern)
  deleteCharacter(data: WsGatewayGameDeleteCharacterMessage) {
    this.wsGatewayWsController.gameBroadcast(WsProtocolMessage.DeleteCharacter, data);
  }

  // Consumable

  @MessagePattern(WsGatewayGameCreateConsumablePattern)
  createConsumable(data: WsGatewayGameCreateConsumableMessage) {
    this.wsGatewayWsController.gameBroadcast(WsProtocolMessage.CreateConsumable, data);
  }

  @MessagePattern(WsGatewayGameDeleteConsumablePattern)
  deleteConsumable(data: WsGatewayGameDeleteConsumableMessage) {
    this.wsGatewayWsController.gameBroadcast(WsProtocolMessage.DeleteConsumable, data);
  }

  // Projectile

  @MessagePattern(WsGatewayGameCreateProjectilePattern)
  createProjectile(data: WsGatewayGameCreateProjectileMessage) {
    this.wsGatewayWsController.gameBroadcast(WsProtocolMessage.CreateProjectile, data);
  }

  @MessagePattern(WsGatewayGameDeleteProjectilePattern)
  deleteProjectile(data: WsGatewayGameDeleteProjectileMessage) {
    this.wsGatewayWsController.gameBroadcast(WsProtocolMessage.DeleteProjectile, data);
  }

  // Actions

  @MessagePattern(WsGatewayGameCharacterActionsPattern)
  characterActions(data: WsGatewayGameCharacterActionsMessage) {
    this.wsGatewayWsController.gameBroadcast(WsProtocolMessage.CharacterActions, data);
  }

  // States

  @MessagePattern(WsGatewayGameLoopStatePattern)
  loopState(data: WsGatewayGameLoopStateMessage) {
    this.wsGatewayWsController.gameBroadcast(WsProtocolMessage.LoopState, data);
  }

  @MessagePattern(WsGatewayGameGameStatePattern)
  gameState(data: WsGatewayGameGameStateMessage) {
    this.wsGatewayWsController.gameBroadcast(WsProtocolMessage.GameState, data);
  }

  // --------------------------------------
  // USER EVENTS
  // --------------------------------------

  @MessagePattern(WsGatewayUserBalancePattern)
  userBalance(data: WsGatewayUserBalanceMsg) {
    this.wsGatewayWsController.broadcast(WsProtocolMessage.UserrBalance, data);
  }
}
