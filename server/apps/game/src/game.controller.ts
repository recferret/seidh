import { Controller } from '@nestjs/common';
import { MessagePattern } from '@nestjs/microservices';

import { GameService } from './game.service';

import {
  GameServiceFinishGamePattern,
  GameServiceFinishGameRequest,
} from '@lib/seidh-common/dto/game/game.finish-game.msg';
import { GameServiceGetGameConfigPattern } from '@lib/seidh-common/dto/game/game.get-game-config.msg';
import {
  GameServiceProgressGamePattern,
  GameServiceProgressGameRequest,
} from '@lib/seidh-common/dto/game/game.progress-game.msg';
import {
  GameServiceStartGamePattern,
  GameServiceStartGameRequest,
} from '@lib/seidh-common/dto/game/game.start-game.msg';

@Controller()
export class GameController {
  constructor(private readonly gameService: GameService) {}

  @MessagePattern(GameServiceGetGameConfigPattern)
  getGameConfig() {
    return this.gameService.getGameConfig();
  }

  @MessagePattern(GameServiceStartGamePattern)
  startGame(request: GameServiceStartGameRequest) {
    return this.gameService.startGame(request);
  }

  @MessagePattern(GameServiceProgressGamePattern)
  progressGame(request: GameServiceProgressGameRequest) {
    return this.gameService.progressGame(request);
  }

  @MessagePattern(GameServiceFinishGamePattern)
  finishGame(request: GameServiceFinishGameRequest) {
    return this.gameService.finishGame(request);
  }
}
