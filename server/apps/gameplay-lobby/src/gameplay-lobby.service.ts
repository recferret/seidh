import { ServiceName } from '@lib/seidh-common/seidh-common.internal-protocol';

import { Inject, Injectable, Logger } from '@nestjs/common';
import { ClientProxy } from '@nestjs/microservices';
import { Cron, CronExpression } from '@nestjs/schedule';

import { firstValueFrom } from 'rxjs';

import {
  GameplayServiceLobbyFindGameRequest,
  GameplayServiceLobbyFindGameResponse,
  GameplayType,
} from '@lib/seidh-common/dto/gameplay-lobby/gameplay-lobby.find-game.msg';
import {
  GameplayLobbyGameplayInstanceInfo,
  GameplayLobbyServiceUpdateGamesMessage,
} from '@lib/seidh-common/dto/gameplay-lobby/gameplay-lobby.update-games.msg';
import {
  GameplayServiceCreateGamePattern,
  GameplayServiceCreateGameRequest,
  GameplayServiceCreateGameResponse,
} from '@lib/seidh-common/dto/gameplay/gameplay.create-game.msg';

@Injectable()
export class GameplayLobbyService {
  private readonly privateGameMaxUsers: number;
  private readonly publicGameMaxUsers: number;
  private readonly testGameMaxUsers: number;

  private readonly gameplayServices = new Map<string, GameplayLobbyGameplayInstanceInfo>();

  constructor(@Inject(ServiceName.Gameplay) private gameplayService: ClientProxy) {
    this.privateGameMaxUsers = Number(process.env.PRIVATE_GAME_MAX_USERS);
    this.publicGameMaxUsers = Number(process.env.PUBLIC_GAME_MAX_USERS);
    this.testGameMaxUsers = Number(process.env.TEST_GAME_MAX_USERS);
  }

  updateGames(data: GameplayLobbyServiceUpdateGamesMessage) {
    this.gameplayServices.set(data.gameplayServiceId, {
      gameplayServiceId: data.gameplayServiceId,
      games: data.games,
      lastUpdateTime: Date.now(),
    });
  }

  async findGame(data: GameplayServiceLobbyFindGameRequest) {
    const response: GameplayServiceLobbyFindGameResponse = {
      success: false,
    };

    if (this.gameplayServices.size > 0) {
      let maxUsers = this.testGameMaxUsers;
      if (data.gameplayType == GameplayType.PrivateGame) {
        maxUsers = this.privateGameMaxUsers;
      } else if (data.gameplayType == GameplayType.PublicGame) {
        maxUsers = this.publicGameMaxUsers;
      }

      let gameFound = false;

      this.gameplayServices.forEach((service) => {
        const filteredGames = service.games.filter(
          (game) => game.gameplayType === data.gameplayType && game.users < maxUsers,
        );
        if (filteredGames.length == 1) {
          response.success = true;
          response.gameplayServiceId = service.gameplayServiceId;
          response.gameId = filteredGames[0].gameId;
          gameFound = true;
        } else if (filteredGames.length > 1) {
          const sortedGames = filteredGames.sort((a, b) => a.users - b.users);
          response.success = true;
          response.gameplayServiceId = service.gameplayServiceId;
          response.gameId = sortedGames[0].gameId;
          gameFound = true;
        }
      });

      if (!gameFound) {
        const createGameRequest: GameplayServiceCreateGameRequest = {
          gameplayType: data.gameplayType,
        };

        const createGameResponse: GameplayServiceCreateGameResponse = await firstValueFrom(
          this.gameplayService.send(GameplayServiceCreateGamePattern, createGameRequest),
        );

        if (createGameResponse.success) {
          response.success = true;
          response.gameId = createGameResponse.gameId;
          response.gameplayServiceId = createGameResponse.gameplayServiceId;
        }
      }
    } else {
      Logger.error('No gameplay services available');
    }

    return response;
  }

  @Cron(CronExpression.EVERY_5_SECONDS)
  dropOutdatedGameplaySerives() {
    const now = Date.now();
    const gameplayServicesToDrop = [];

    this.gameplayServices.forEach((service, serviceId) => {
      if (now - service.lastUpdateTime > 2000) {
        gameplayServicesToDrop.push(serviceId);
      }
    });

    gameplayServicesToDrop.forEach((serviceId) => this.gameplayServices.delete(serviceId));
  }

  @Cron(CronExpression.EVERY_10_SECONDS)
  gameServicesInfo() {
    let games = 0;
    let users = 0;
    let mobs = 0;
    let avgDt = 0;

    this.gameplayServices.forEach((service) => {
      service.games.forEach((game) => {
        games++;
        users += game.users;
        mobs += game.mobs;
        avgDt += game.lastDt;
      });
      avgDt /= games;
    });
    Logger.log({
      games,
      users,
      mobs,
      avgDt,
    });
  }
}
