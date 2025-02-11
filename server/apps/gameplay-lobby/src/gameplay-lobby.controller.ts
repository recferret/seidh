import { Controller } from '@nestjs/common';
import { MessagePattern } from '@nestjs/microservices';

import { GameplayLobbyService } from './gameplay-lobby.service';

import {
  GameplayServiceLobbyFindGamePattern,
  GameplayServiceLobbyFindGameRequest,
} from '@lib/seidh-common/dto/gameplay-lobby/gameplay-lobby.find-game.msg';
import {
  GameplayLobbyServiceUpdateGamesMessage,
  GameplayLobbyServiceUpdateGamesPattern,
} from '@lib/seidh-common/dto/gameplay-lobby/gameplay-lobby.update-games.msg';

@Controller()
export class GameplayLobbyController {
  constructor(private readonly gameplayLobbyService: GameplayLobbyService) {}

  @MessagePattern(GameplayLobbyServiceUpdateGamesPattern)
  updateGames(data: GameplayLobbyServiceUpdateGamesMessage) {
    this.gameplayLobbyService.updateGames(data);
  }

  @MessagePattern(GameplayServiceLobbyFindGamePattern)
  findGame(data: GameplayServiceLobbyFindGameRequest) {
    return this.gameplayLobbyService.findGame(data);
  }
}
