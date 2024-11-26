import {
  CanActivate,
  Controller,
  ExecutionContext,
  Injectable,
  UseGuards,
} from '@nestjs/common';
import { GameplayService } from './gameplay.service';
import { MessagePattern } from '@nestjs/microservices';
import { Observable } from 'rxjs';
import { WsGameEvent } from '@app/seidh-common';
import {
  GameplayServiceJoinGamePattern,
  GameplayServiceJoinGameMessage,
} from '@app/seidh-common/dto/gameplay/gameplay.join-game.msg';
import {
  GameplayServiceInputPattern,
  GameplayServiceInputMessage,
} from '@app/seidh-common/dto/gameplay/gameplay.input.msg';
import { Config } from './main';
import {
  GameplayServiceDisconnectedPattern,
  GameplayServiceDisconnectedMessage,
} from '@app/seidh-common/dto/gameplay/gameplay.disconnected.msg';
import {
  GameplayServiceCreateGamePattern,
  GameplayServiceCreateGameRequest,
} from '@app/seidh-common/dto/gameplay/gameplay.create-game.msg';

@Injectable()
class InstanceIdGuard implements CanActivate {
  canActivate(
    context: ExecutionContext,
  ): boolean | Promise<boolean> | Observable<boolean> {
    const request: WsGameEvent = context.switchToRpc().getData();
    return request.gameplayServiceId == Config.GAMEPLAY_INSTANCE_ID;
  }
}

@Injectable()
class PlayerGuard implements CanActivate {
  canActivate(
    context: ExecutionContext,
  ): boolean | Promise<boolean> | Observable<boolean> {
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
