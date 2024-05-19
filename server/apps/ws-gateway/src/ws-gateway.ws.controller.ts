import { Server, Socket } from 'socket.io';
import { MessageBody, SubscribeMessage, WebSocketGateway, WebSocketServer } from '@nestjs/websockets';
import { Inject, Logger, OnModuleInit } from '@nestjs/common';
import { ClientProxy } from '@nestjs/microservices';
import { ServiceName } from '@app/seidh-common';
import { FindGameDto } from './dto/find.game.dto';
import { GameplayJoinGameMessage, GameplayJoinGamePattern } from '@app/seidh-common/dto/gameplay/gameplay.join.game.msg';
import { WsGatewayGameBaseMsg } from '@app/seidh-common/dto/ws-gateway/ws-gateway.game.base.msg';

export enum WsProtocol {
  // Client -> Server
  FindGame = 'FindGame',

  // Server -> Client
  GameInit = 'GameInit',
  CreateCharacter = 'CreateCharacter',
  DeleteCharacter = 'DeleteCharacter',
  CreateProjectile = 'CreateProjectile',
  DeleteProjectile = 'DeleteProjectile',
  CharacterActions = 'CharacterActions',
  GameState = 'GameState',
}

@WebSocketGateway({
  cors: {
      origin: '*',
      methods: ['GET', 'POST']
  },
})
export class WsGatewayWsController implements OnModuleInit {
  
  @WebSocketServer()
  server: Server;

  private readonly playerSockets = new Map<string, Socket>();
  private readonly socketIdToPlayerId = new Map<string, string>();

  constructor(@Inject(ServiceName.Gameplay) private gameplayService: ClientProxy) {
  }

  async onModuleInit() {
    this.server.on('connection', (socket: Socket) => {
      Logger.log('Socket connected');

      const playerId = socket.handshake.auth.playerId;

      if (playerId) {
        this.socketIdToPlayerId.set(socket.id, playerId);
        this.playerSockets.set(playerId, socket);

        socket.on('disconnect', () => {
          Logger.log('Socket disconnected, playerId:', this.socketIdToPlayerId.get(socket.id));

          this.playerSockets.delete(this.socketIdToPlayerId.get(socket.id));
          this.socketIdToPlayerId.delete(socket.id);
        });
      } else {
        Logger.error('Bad handshake', socket.handshake.auth);
        socket.disconnect();
      }
    });
  }

  // ----------------------------------------------
  // Client -> Server
  // ----------------------------------------------

  @SubscribeMessage(WsProtocol.FindGame)
  async handleFindGame(@MessageBody() data: FindGameDto) {
    Logger.log('handleFindGame', data);
    const request: GameplayJoinGameMessage = {
      playerId: data.playerId,
      gameplayServiceId: data.gameplayServiceId,
    };
    this.gameplayService.emit(GameplayJoinGamePattern, request);
  }

  // ----------------------------------------------
  // Server -> Client
  // ----------------------------------------------

  broadcast(wsProtocol: WsProtocol, data: WsGatewayGameBaseMsg) {
    Logger.log('broadcast', wsProtocol, data);
    if (data.targetPlayerId) {
      const socket = this.playerSockets.get(data.targetPlayerId);
      if (socket && socket.connected) {
        data.targetPlayerId = null;
        socket.emit(wsProtocol, data);
      } else {
        Logger.error('Socket is not connected', wsProtocol, data);
      }
    } else {
      for (const [playerId, socket] of this.playerSockets) {
        if (socket && socket.connected) {
          if (data.excludePlayerId && data.excludePlayerId == playerId) {
            continue;
          }
          socket.emit(wsProtocol, data);
        } else {
         Logger.error('Socket is not connected', wsProtocol, data);
        }
      }
    }
  }

}
