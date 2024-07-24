import { Controller } from '@nestjs/common';
import { GameplayLobbyService } from './gameplay-lobby.service';
import { MessagePattern } from '@nestjs/microservices';
import {
  GameplayLobbyFindGamePattern,
  GameplayLobbyFindGameMessageRequest,
} from '@app/seidh-common/dto/gameplay-lobby/gameplay-lobby.find.game.msg';
import {
  GameplayLobbyUpdateGamesPattern,
  GameplayLobbyUpdateGamesMessage,
} from '@app/seidh-common/dto/gameplay-lobby/gameplay-lobby.update.games.msg';

@Controller()
export class GameplayLobbyController {
  constructor(private readonly gameplayLobbyService: GameplayLobbyService) {}

  @MessagePattern(GameplayLobbyUpdateGamesPattern)
  updateGames(data: GameplayLobbyUpdateGamesMessage) {
    this.gameplayLobbyService.updateGames(data);
  }

  @MessagePattern(GameplayLobbyFindGamePattern)
  findGame(data: GameplayLobbyFindGameMessageRequest) {
    return this.gameplayLobbyService.findGame(data);
  }
}
