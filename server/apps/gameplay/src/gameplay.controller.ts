import { WsGameEvent } from '@lib/seidh-common/seidh-common.internal-protocol';

import { CanActivate, Controller, ExecutionContext, Injectable, UseGuards } from '@nestjs/common';
import { MessagePattern } from '@nestjs/microservices';

import { Observable } from 'rxjs';

import { GameplayService } from './gameplay.service';

import {
  GameplayServiceCreateGamePattern,
  GameplayServiceCreateGameRequest,
} from '@lib/seidh-common/dto/gameplay/gameplay.create-game.msg';
import {
  GameplayServiceDisconnectedMessage,
  GameplayServiceDisconnectedPattern,
} from '@lib/seidh-common/dto/gameplay/gameplay.disconnected.msg';
import {
  GameplayServiceInputMessage,
  GameplayServiceInputPattern,
} from '@lib/seidh-common/dto/gameplay/gameplay.input.msg';
import {
  GameplayServiceJoinGameMessage,
  GameplayServiceJoinGamePattern,
} from '@lib/seidh-common/dto/gameplay/gameplay.join-game.msg';

import { Config } from './main';

@Injectable()
class InstanceIdGuard implements CanActivate {
  canActivate(context: ExecutionContext): boolean | Promise<boolean> | Observable<boolean> {
    const request: WsGameEvent = context.switchToRpc().getData();
    return request.gameplayServiceId == Config.GAMEPLAY_INSTANCE_ID;
  }
}

@Injectable()
class PlayerGuard implements CanActivate {
  canActivate(context: ExecutionContext): boolean | Promise<boolean> | Observable<boolean> {
    const request: WsGameEvent = context.switchToRpc().getData();
    return request.userId && GameplayService.ConnectedUsers.has(request.userId);
  }
}

@Controller()
export class GameplayController {
  constructor(private readonly gameplayService: GameplayService) {}

  @UseGuards(InstanceIdGuard, PlayerGuard)
  @MessagePattern(GameplayServiceInputPattern)
  input(message: GameplayServiceInputMessage) {
    this.gameplayService.input(message);
  }

  @MessagePattern(GameplayServiceCreateGamePattern)
  createGame(message: GameplayServiceCreateGameRequest) {
    return this.gameplayService.createGame(message);
  }

  @MessagePattern(GameplayServiceDisconnectedPattern)
  disconnected(message: GameplayServiceDisconnectedMessage) {
    this.gameplayService.disconnected(message);
  }

  @UseGuards(InstanceIdGuard)
  @MessagePattern(GameplayServiceJoinGamePattern)
  joinGame(message: GameplayServiceJoinGameMessage) {
    this.gameplayService.joinGame(message);
  }
}
