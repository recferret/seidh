import { Controller } from '@nestjs/common';
import { MessagePattern } from '@nestjs/microservices';
import {
  GameServiceStartGamePattern,
  GameServiceStartGameRequest,
} from '@app/seidh-common/dto/game/game.start-game.msg';
import {
  GameServiceFinishGamePattern,
  GameServiceFinishGameRequest,
} from '@app/seidh-common/dto/game/game.finish-game.msg';
import { GameService } from './game.service';
import {
  GameServiceProgressGamePattern,
  GameServiceProgressGameRequest,
} from '@app/seidh-common/dto/game/game.progress-game.msg';
import {
  GameServiceGetGameConfigPattern,
  GameServiceGetGameConfigGameRequest,
} from '@app/seidh-common/dto/game/game.get-game-config.msg';

@Controller()
export class GameController {
  constructor(private readonly gameService: GameService) {}

  @MessagePattern(GameServiceGetGameConfigPattern)
  getGameConfig(request: GameServiceGetGameConfigGameRequest) {
    return this.gameService.getGameConfig(request);
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
