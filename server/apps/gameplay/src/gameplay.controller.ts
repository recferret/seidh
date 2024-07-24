import { CanActivate, Controller, ExecutionContext, Injectable, UseGuards } from '@nestjs/common';
import { GameplayService } from './gameplay.service';
import { MessagePattern } from '@nestjs/microservices';
import { Observable } from 'rxjs';
import { WsGameEvent } from '@app/seidh-common';
import { GameplayJoinGameMessage, GameplayJoinGamePattern } from '@app/seidh-common/dto/gameplay/gameplay.join.game.msg';
import { GameplayInputPattern, GameplayInputMessage } from '@app/seidh-common/dto/gameplay/gameplay.input.msg';
import { Config } from './main';
import { GameplayDisconnectedPattern, GameplayDisconnectedMessage } from '@app/seidh-common/dto/gameplay/gameplay.disconnected.msg';

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
    const request:WsGameEvent = context.switchToRpc().getData();
    return request.userId && GameplayService.ConnectedUsers.has(request.userId);
  }
}

@Controller()
export class GameplayController {
  constructor(private readonly gameplayService: GameplayService) {}

  @UseGuards(InstanceIdGuard, PlayerGuard)
  @MessagePattern(GameplayInputPattern)
  input(message: GameplayInputMessage) {
    this.gameplayService.input(message);
  }

  @MessagePattern(GameplayDisconnectedPattern)
  disconnected(message: GameplayDisconnectedMessage) {
    this.gameplayService.disconnected(message);
  }

  @UseGuards(InstanceIdGuard)
  @MessagePattern(GameplayJoinGamePattern)
  joinGame(message: GameplayJoinGameMessage) {
    this.gameplayService.joinGame(message);
  }
}
