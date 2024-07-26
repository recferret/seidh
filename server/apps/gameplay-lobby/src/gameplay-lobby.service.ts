import { ServiceName } from '@app/seidh-common';
import {
  GameplayLobbyFindGameMessageRequest,
  GameplayLobbyFindGameMessageResponse,
} from '@app/seidh-common/dto/gameplay-lobby/gameplay-lobby.find.game.msg';
import {
  GameplayLobbyGameplayInstanceInfo,
  GameplayLobbyUpdateGamesMessage,
} from '@app/seidh-common/dto/gameplay-lobby/gameplay-lobby.update.games.msg';
import { Inject, Injectable } from '@nestjs/common';
import { ClientProxy } from '@nestjs/microservices';
import { Cron, CronExpression } from '@nestjs/schedule';
import { firstValueFrom } from 'rxjs';
import {
  GameplayCreatedRoomMsg,
  GameplayCreateNewGamePattern,
  GameplayCreateNewRoomMsg,
} from '@app/seidh-common/dto/gameplay/gameplay.createNewRoom.msg';

@Injectable()
export class GameplayLobbyService {
  private readonly maxUserAllowedTest = Number(
    process.env.MAX_ALLOWED_USER_TEST,
  );
  private readonly gameplayServices = new Map<
    string,
    GameplayLobbyGameplayInstanceInfo
  >();

  constructor(
    @Inject(ServiceName.Gameplay) private gameplayService: ClientProxy,
  ) {}

  updateGames(data: GameplayLobbyUpdateGamesMessage) {
    this.gameplayServices.set(data.gameplayServiceId, {
      gameplayServiceId: data.gameplayServiceId,
      games: data.games,
      lastUpdateTime: Date.now(),
    });
  }

  async findGame(data: GameplayLobbyFindGameMessageRequest) {
    const response: GameplayLobbyFindGameMessageResponse = {
      gameplayId: '',
      gameplayServiceId: '',
    };

    if (this.gameplayServices.size > 0) {
      this.gameplayServices.forEach((service) => {
        const filteredGames = service.games.filter(
          (game) =>
            game.gameType === data.gameType &&
            game.usersOnline <= this.maxUserAllowedTest,
        );
        console.log(filteredGames);
        if (filteredGames.length > 0) {
          const sortedGames = filteredGames.sort(
            (a, b) => a.usersOnline - b.usersOnline,
          );
          response.gameplayServiceId = service.gameplayServiceId;
          response.gameplayId = sortedGames[0].gameId;
        }
      });
      if (response.gameplayId == '') {
        const responseFromService: GameplayCreatedRoomMsg =
          await firstValueFrom(
            this.gameplayService.send(GameplayCreateNewGamePattern, {
              gameType: data.gameType,
            } as GameplayCreateNewRoomMsg),
          );
        return {
          gameplayId: responseFromService.gameInstance,
          gameplayServiceId: responseFromService.gamePlayInstance,
        };
      }
      return response;
    } else {
      throw new Error('no gameplay services available');
    }
  }

  @Cron(CronExpression.EVERY_SECOND)
  dropOutdatedGameplaySerives() {
    const now = Date.now();
    const gameplayServicesToDrop = [];

    this.gameplayServices.forEach((service, serviceId) => {
      if (now - service.lastUpdateTime > 2000) {
        gameplayServicesToDrop.push(serviceId);
      }
    });

    gameplayServicesToDrop.forEach((serviceId) =>
      this.gameplayServices.delete(serviceId),
    );
  }
}
