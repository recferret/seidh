import * as WS from 'ws';
import { Router } from './router.js';
import { EventType, Events } from "./events.js";
import { Server } from "node:https";
import { ServerTransport, TransportType } from './transport.js';

export class WebSocket extends Router {

    private readonly wss: any;
    private readonly playerSockets = new Map<string, any>();

    constructor(server: Server) {
        super();

        this.wss = new WS.WebSocketServer({ server }); //{ port: 3000 });
  
        const self = this;

        this.wss.on('connection', function connection(ws) {
            console.log('SOME ONE CONNECTED');

            function disconnect() {
                self.playerSockets.forEach((v, k) => {
                    if (v === ws) {
                        Events.eventEmitter.emit(EventType.DISCONNECT, { playerId: k });
                        ServerTransport.PlayerLeft(k, TransportType.WEBSOCKET);
                    }
                });
            }

            ws.on('close', function error(reason) {
                console.log('WS CLOSED');
                console.error(reason);

                disconnect();
            });

            ws.on('error', function error(error) { 
                console.log('WS ERROR');
                console.error(error);

                disconnect();
            });
        
            ws.on('message', function message(data) {
                const json = ServerTransport.BinArrayToJson(data, 'ws');
                switch (json.msg) {
                    case 'login':
                        self.playerSockets.set(json.playerId, ws);
                        ServerTransport.PlayerJoined(json.playerId, TransportType.WEBSOCKET);
                        ws.send(ServerTransport.StrToBinArray(JSON.stringify({msg: 'login'}), 'ws'));
                        break;
                    default:
                        self.routeMessage(json);
                }
            });
        });
    }

    public notifyPlayer(playerId: string, message: any) {
        const playerSocket = this.playerSockets.get(playerId);
        if (playerSocket && playerSocket.readyState === WS.WebSocket.OPEN) {
            playerSocket.send(message);
        }
    }

    public notifyAll(message: any, excludePlayerId?: string) {
        const playerSocket = this.playerSockets.get(excludePlayerId);
        this.wss.clients.forEach(function each(client: any) {
            if ((excludePlayerId && playerSocket != client || !excludePlayerId) && client.readyState === WS.WebSocket.OPEN) {
                client.send(message);
            }
        });
    }

}