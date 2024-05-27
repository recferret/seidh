import { Server, Socket } from 'socket.io';
import { MessageBody, SubscribeMessage, WebSocketGateway, WebSocketServer } from '@nestjs/websockets';
import { Inject, Logger, OnModuleInit } from '@nestjs/common';
import { ClientProxy } from '@nestjs/microservices';
import { ServiceName } from '@app/seidh-common';
import { FindGameDto } from './dto/find.game.dto';
import { GameplayJoinGameMessage, GameplayJoinGamePattern } from '@app/seidh-common/dto/gameplay/gameplay.join.game.msg';
import { WsGatewayGameBaseMsg } from '@app/seidh-common/dto/ws-gateway/ws-gateway.game.base.msg';
import { GameplayDisconnectedMessage, GameplayDisconnectedPattern } from '@app/seidh-common/dto/gameplay/gameplay.disconnected.msg';
import { InputDto } from './dto/input.dto';
import { GameplayInputMessage, GameplayInputPattern } from '@app/seidh-common/dto/gameplay/gameplay.input.msg';

export enum WsProtocolMessage {
  // Client -> Server
  FindGame = 'FindGame',
  Input = 'Input',

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

  // TODO single entity for each player socket
  private readonly playerSockets = new Map<string, Socket>();
  private readonly playerIdToGameId = new Map<string, string>();
  private readonly playerIdToGameplayService = new Map<string, string>();
  private readonly socketIdToPlayerId = new Map<string, string>();

  private inputsReceived = 0;

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

          const playerId = this.socketIdToPlayerId.get(socket.id);

          if (playerId) {
            const request: GameplayDisconnectedMessage = {
              playerId
            };
            this.gameplayService.emit(GameplayDisconnectedPattern, request);

            this.playerSockets.delete(this.socketIdToPlayerId.get(socket.id));
            this.socketIdToPlayerId.delete(socket.id);
            this.playerIdToGameId.delete(playerId);
            this.playerIdToGameplayService.delete(playerId);
          }
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

  @SubscribeMessage(WsProtocolMessage.FindGame)
  async handleFindGame(@MessageBody() data: FindGameDto) {
    const request: GameplayJoinGameMessage = {
      playerId: data.playerId,
      gameplayServiceId: data.gameplayServiceId,
    };
    this.gameplayService.emit(GameplayJoinGamePattern, request);
    this.playerIdToGameplayService.set(data.playerId, data.gameplayServiceId);
  }

  @SubscribeMessage(WsProtocolMessage.Input)
  async handleInput(@MessageBody() data: InputDto) {
    const request: GameplayInputMessage = {
      playerId: data.playerId,
      gameId: this.playerIdToGameId.get(data.playerId),
      gameplayServiceId: this.playerIdToGameplayService.get(data.playerId),
      actionType: data.actionType,
      movAngle: data.movAngle,
    };
    this.gameplayService.emit(GameplayInputPattern, request);

    this.inputsReceived++;

    console.log('inputsReceived: ' + this.inputsReceived);
  }

  // ----------------------------------------------
  // Server -> Client
  // ----------------------------------------------

  broadcast(wsProtocolMessage: WsProtocolMessage, data: WsGatewayGameBaseMsg) {
    if (data.targetPlayerId) {
      const socket = this.playerSockets.get(data.targetPlayerId);
      if (socket && socket.connected) {
        // Connect player and game for the first time
        if (wsProtocolMessage == WsProtocolMessage.GameInit) {
          this.playerIdToGameId.set(data.targetPlayerId, data.gameId);
        }

        // Drop extra fields
        delete data.targetPlayerId;
        delete data.gameId;

        socket.emit(wsProtocolMessage, data);
      } else {
        Logger.error('Socket is not connected', wsProtocolMessage, data);
      }
    } else {
      for (const [playerId, socket] of this.playerSockets) {
        if (socket && socket.connected) {
          // Skip excluded players and players that are not in the game
          if (data.excludePlayerId && data.excludePlayerId == playerId || !this.playerIdToGameId.has(playerId)) {
            continue;
          }

          // Drop extra fields
          delete data.excludePlayerId;
          delete data.gameId;
          socket.emit(wsProtocolMessage, data);
        } else {
         Logger.error('Socket is not connected', wsProtocolMessage, data);
        }
      }
    }
  }

}
