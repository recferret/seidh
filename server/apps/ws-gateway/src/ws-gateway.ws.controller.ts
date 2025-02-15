import { ServiceName } from '@lib/seidh-common/seidh-common.internal-protocol';
import { Server, Socket } from 'socket.io';

import { Inject, Logger, OnModuleInit } from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import { ClientProxy } from '@nestjs/microservices';
import { ConnectedSocket, MessageBody, SubscribeMessage, WebSocketGateway, WebSocketServer } from '@nestjs/websockets';

import { FindGameDto } from './dto/find.game.dto';
import { InputDto } from './dto/input.dto';
import {
  GameplayServiceDisconnectedMessage,
  GameplayServiceDisconnectedPattern,
} from '@lib/seidh-common/dto/gameplay/gameplay.disconnected.msg';
import {
  GameplayServiceInputMessage,
  GameplayServiceInputPattern,
} from '@lib/seidh-common/dto/gameplay/gameplay.input.msg';
import {
  GameplayServiceJoinGameMessage,
  GameplayServiceJoinGamePattern,
} from '@lib/seidh-common/dto/gameplay/gameplay.join-game.msg';
import { WsGatewayBaseMsg } from '@lib/seidh-common/dto/ws-gateway/ws-gateway.base.msg';
import { WsGatewayGameBaseMsg } from '@lib/seidh-common/dto/ws-gateway/ws-gateway.game.base.msg';

export enum WsProtocolMessage {
  // Client -> Server
  FindGame = 'FindGame',
  Input = 'Input',

  // Server -> Client

  // Game
  GameInit = 'GameInit',
  CreateCharacter = 'CreateCharacter',
  DeleteCharacter = 'DeleteCharacter',
  CreateConsumable = 'CreateConsumable',
  DeleteConsumable = 'DeleteConsumable',
  CreateProjectile = 'CreateProjectile',
  DeleteProjectile = 'DeleteProjectile',
  CharacterActions = 'CharacterActions',
  LoopState = 'LoopState',
  GameState = 'GameState',

  // User
  UserrBalance = 'UserBalance',
}

@WebSocketGateway({
  cors: {
    origin: '*',
    methods: ['GET', 'POST'],
  },
})
export class WsGatewayWsController implements OnModuleInit {
  @WebSocketServer()
  server: Server;

  private readonly userSockets = new Map<string, Socket>();
  private readonly userIdToGameId = new Map<string, string>();
  private readonly userIdToGameplayService = new Map<string, string>();
  private readonly socketIdToUserId = new Map<string, string>();

  constructor(
    private readonly jwtService: JwtService,
    @Inject(ServiceName.Gameplay) private gameplayService: ClientProxy,
  ) {}

  async onModuleInit() {
    this.server.on('connection', async (socket: Socket) => {
      try {
        const decodedToken = await this.jwtService.verifyAsync(socket.handshake.auth.authToken.split(' ')[1]);
        const userId = decodedToken.userId;

        this.socketIdToUserId.set(socket.id, userId);
        this.userSockets.set(userId, socket);

        socket.on('disconnect', () => {
          Logger.log('Socket disconnected, userId:', this.socketIdToUserId.get(socket.id));

          const userId = this.socketIdToUserId.get(socket.id);

          if (userId) {
            const request: GameplayServiceDisconnectedMessage = {
              userId,
            };
            this.gameplayService.emit(GameplayServiceDisconnectedPattern, request);

            this.userSockets.delete(this.socketIdToUserId.get(socket.id));
            this.socketIdToUserId.delete(socket.id);
            this.userIdToGameId.delete(userId);
            this.userIdToGameplayService.delete(userId);
          }
        });
      } catch {
        Logger.error('Bad handshake', socket.handshake.auth);
        socket.disconnect();
      }
    });
  }

  // ----------------------------------------------
  // Client -> Server
  // ----------------------------------------------

  @SubscribeMessage(WsProtocolMessage.FindGame)
  async handleFindGame(@ConnectedSocket() client: Socket, @MessageBody() data: FindGameDto) {
    const userId = this.socketIdToUserId.get(client.id);
    const request: GameplayServiceJoinGameMessage = {
      userId,
      gameId: data.gameId,
      gameplayServiceId: data.gameplayServiceId,
    };
    this.gameplayService.emit(GameplayServiceJoinGamePattern, request);
    this.userIdToGameplayService.set(userId, data.gameplayServiceId);
  }

  @SubscribeMessage(WsProtocolMessage.Input)
  async handleInput(@ConnectedSocket() client: Socket, @MessageBody() data: InputDto) {
    const userId = this.socketIdToUserId.get(client.id);
    const request: GameplayServiceInputMessage = {
      userId,
      gameId: this.userIdToGameId.get(userId),
      gameplayServiceId: this.userIdToGameplayService.get(userId),
      actionType: data.actionType,
      movAngle: data.movAngle,
    };
    this.gameplayService.emit(GameplayServiceInputPattern, request);
  }

  // ----------------------------------------------
  // Server -> Client
  // ----------------------------------------------

  gameBroadcast(wsProtocolMessage: WsProtocolMessage, data: WsGatewayGameBaseMsg) {
    if (data.targetUserId) {
      const socket = this.userSockets.get(data.targetUserId);
      if (socket && socket.connected) {
        // Connect user and game for the first time
        if (wsProtocolMessage == WsProtocolMessage.GameInit) {
          this.userIdToGameId.set(data.targetUserId, data.gameId);
        }

        // Drop extra fields
        delete data.targetUserId;
        delete data.gameId;

        socket.emit(wsProtocolMessage, data);
      } else {
        Logger.error('Socket is not connected', wsProtocolMessage, data);
      }
    } else {
      for (const [userId, socket] of this.userSockets) {
        if (socket && socket.connected) {
          // Skip excluded users and users that are not in the game
          if ((data.excludeUserId && data.excludeUserId == userId) || !this.userIdToGameId.has(userId)) {
            continue;
          }

          // Drop extra fields
          delete data.excludeUserId;
          delete data.gameId;
          socket.emit(wsProtocolMessage, data);
        } else {
          Logger.error('Socket is not connected', wsProtocolMessage, data);
        }
      }
    }
  }

  broadcast(wsProtocolMessage: WsProtocolMessage, data: WsGatewayBaseMsg) {
    if (data.targetUserId) {
      const socket = this.userSockets.get(data.targetUserId);
      if (socket && socket.connected) {
        // Drop extra fields
        delete data.targetUserId;
        socket.emit(wsProtocolMessage, data);
      } else {
        Logger.error('Socket is not connected', wsProtocolMessage, data);
      }
    }
  }
}
