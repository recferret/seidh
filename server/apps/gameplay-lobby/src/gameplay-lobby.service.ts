import { ServiceName } from '@app/seidh-common';
import { 
  GameplayLobbyFindGameMessageRequest, 
  GameplayLobbyFindGameMessageResponse 
} from '@app/seidh-common/dto/gameplay-lobby/gameplay-lobby.find.game.msg';
import { 
  GameplayLobbyGameplayInstanceInfo, 
  GameplayLobbyUpdateGamesMessage 
} from '@app/seidh-common/dto/gameplay-lobby/gameplay-lobby.update.games.msg';
import { Inject, Injectable } from '@nestjs/common';
import { ClientProxy } from '@nestjs/microservices';
import { Cron, CronExpression } from '@nestjs/schedule';

@Injectable()
export class GameplayLobbyService {
 
  private readonly gameplayServices = new Map<string, GameplayLobbyGameplayInstanceInfo>();

  constructor(
    @Inject(ServiceName.Gameplay) private gameplayService: ClientProxy
  ) {}

  updateGames(data: GameplayLobbyUpdateGamesMessage) {
    this.gameplayServices.set(data.gameplayServiceId, { 
      gameplayServiceId: data.gameplayServiceId,
      games: data.games,
      lastUpdateTime: Date.now(),
    });
  }

  async findGame(data: GameplayLobbyFindGameMessageRequest) {
      if (this.gameplayServices.size > 0) {
        let gameplayServiceId: string = undefined;

        // Need to get an instance id to communicate with
        this.gameplayServices.forEach((service, id) => {
          // Pick the first game instance for testing purposes
          gameplayServiceId = id;
        });
  
        const response: GameplayLobbyFindGameMessageResponse = {
          gameplayServiceId
        };
        
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
  
    gameplayServicesToDrop.forEach(serviceId => this.gameplayServices.delete(serviceId));
  }

}
