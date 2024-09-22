import { Controller } from '@nestjs/common';
import { MessagePattern } from '@nestjs/microservices';
import {
  GameStartGamePattern,
  GameStartGameServiceRequest,
} from '@app/seidh-common/dto/game/game.start.game.msg';
import {
  GameFinishGamePattern,
  GameFinishGameServiceRequest,
} from '@app/seidh-common/dto/game/game.finish.game.msg';
import { GameService } from './game.service';
import { GameProgressGameServiceRequest } from '@app/seidh-common/dto/game/game.progress.game.msg';

@Controller()
export class GameController {
  constructor(private readonly gameService: GameService) {}

  @MessagePattern(GameStartGamePattern)
  startGame(request: GameStartGameServiceRequest) {
    return this.gameService.startGame(request);
  }

  @MessagePattern(GameFinishGamePattern)
  progressGame(request: GameProgressGameServiceRequest) {
    return this.gameService.progressGame(request);
  }

  @MessagePattern(GameFinishGamePattern)
  finishGame(request: GameFinishGameServiceRequest) {
    return this.gameService.finishGame(request);
  }
}
