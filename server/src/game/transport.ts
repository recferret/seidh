import { readFile } from "node:fs/promises";
import { createServer } from "node:https";
// import { Http3Server } from "@fails-components/webtransport";
import { WebSocket } from "./ws.js"
import { WebTransportServerClient } from "./wt.js";

export enum TransportType {
    WEBSOCKET = 'websocket',
    WEBTRANSPORT = 'webtransport',
}

export class ServerTransport {
    private key: Buffer;
    private cert: Buffer;
  
    // private http3Server: Http3Server;
    // private isListening = false;

    private webSocketServer: WebSocket;

    private static WTConnectedPlayers = new Set<string>();
    private static WSConnectedPlayers = new Set<string>();
    private static InitiatedPlayers = new Set<string>();

    public static WTClients = new Map<string, WebTransportServerClient>();

    constructor() {
        this.readCert()
          .then(async ({ key, cert }) => {
            this.key = key;
            this.cert = cert;
            await this.initHttpServer();
            // await this.initHttp3Server();
          });
    }
    
    public async notifyPlayer(playerId: string, wtStreamType: string, messageJson: string) {
        if (ServerTransport.WSConnectedPlayers.has(playerId)) {
            this.webSocketServer.notifyPlayer(playerId, ServerTransport.StrToBinArray(messageJson, 'ws'));
        } else if (ServerTransport.WTConnectedPlayers.has(playerId)) {
            await ServerTransport.WTClients.get(playerId).writeData(wtStreamType, ServerTransport.StrToBinArray(messageJson, 'wt'));
        }
    }

    public async notifyAll(messageJson: string, wtStreamType: string, excludePlayerId?: string) {
        this.webSocketServer.notifyAll(ServerTransport.StrToBinArray(messageJson, 'ws'), excludePlayerId);

        for (const [key, value] of ServerTransport.WTClients) {
            if (ServerTransport.WTConnectedPlayers.has(key) && (!excludePlayerId || excludePlayerId && excludePlayerId !== key)) {
              await value.writeData(wtStreamType, ServerTransport.StrToBinArray(messageJson, 'wt'));
            }
        }
        // ServerTransport.WTClients.forEach((value, key) => {
        //     if (ServerTransport.WTConnectedPlayers.has(key)) {
        //         value.writeData('reliable', ServerTransport.StrToBinArray(messageJson, 'wt'));
        //     }
        // });
      }

    public static PlayerJoined(playerId: string, transportType: TransportType) {
        if (transportType === TransportType.WEBSOCKET) {
            ServerTransport.WSConnectedPlayers.add(playerId);
        } else {
            ServerTransport.WTConnectedPlayers.add(playerId);
        }
    }

    public static PlayerLeft(playerId: string, transportType: TransportType) {
        if (transportType === TransportType.WEBSOCKET) {
          ServerTransport.WSConnectedPlayers.delete(playerId);
        } else {
          ServerTransport.WTConnectedPlayers.delete(playerId);
        }
        ServerTransport.InitiatedPlayers.delete(playerId);
    }

    public static PlayerInitiated(playerId: string) {
        return ServerTransport.InitiatedPlayers.has(playerId);
    }

    public static InitiatePlayer(playerId: string) {
      ServerTransport.InitiatedPlayers.add(playerId);
    }

    // 
    // Инициализация всей транспортной логики
    //

    private async readCert() {
        const key = await readFile("./cert/key.pem");
        const cert = await readFile("./cert/cert.pem");
        return { key, cert };
    }

    private async initHttpServer() {
        const server = createServer({
          key: this.key,
          cert: this.cert
         }, async (req, res) => {
          if (req.method === "GET" && req.url === "/") {
            const content = await readFile("./src/game/client/index.html");
            res.writeHead(200, {
              "content-type": "text/html"
            });
            res.write(content);
            res.end();
          } else if (req.method === "GET" && req.url === "/game.js") {
            const content = await readFile("./src/game/client/game.js");
            res.writeHead(200, {
              "content-type": "text/html"
            });
            res.write(content);
            res.end();
          } else if (req.method === "GET" && req.url === "/network.js") {
            const content = await readFile("./src/game/client/network.js");
            res.writeHead(200, {
              "content-type": "text/html"
            });
            res.write(content);
            res.end();
          } else {
            res.writeHead(404).end(); 
          }
        });
              
        const port = process.env.PORT || 3000;
           
        this.webSocketServer =new WebSocket(server);

        server.listen(port, () => {
          console.log(`server listening at https://localhost:${port}`);
        });
    }
    
    // private async initHttp3Server() {
    //     this.http3Server = new Http3Server({
    //       host: '0.0.0.0',
    //       port: '3000',
    //       secret: "changeit",
    //       cert: this.cert,
    //       privKey: this.key,
    //     });
            
    //     this.http3Server.startServer();
    //     this.isListening = true;
    //     await this.acceptIncomingHttp3Sessions();
    // }
    
    // private async acceptIncomingHttp3Sessions() {
    //     try {
    //       const sessionStream = await this.http3Server.sessionStream("/");
    //       const sessionReader = sessionStream.getReader();
    //       sessionReader.closed.catch((e: any) => console.log("session reader closed with error!", e));
        
    //       while (this.isListening) {
    //         const { done, value } = await sessionReader.read();
    //         if (done) { break; }
    
    //         new WebTransportServerClient(value);
    //       }
    //     } catch (e) {
    //       console.error("error:", e);
    //     }
    // }

    //
    // Сереализация и десереализация данных
    //

    public static BinArrayToJson(binArray: any, transport: string) {
        if (transport === 'ws') {
            const enc = new TextDecoder();
            return JSON.parse(enc.decode(binArray));
        } else {
            let str = "";
            for (let i = 0; i < binArray.length; i++) {
              str += String.fromCharCode(parseInt(binArray[i]));
            }
            return JSON.parse(str)
        }
    }
  
    public static StrToBinArray(str: string, transport: string) {
        if (transport === 'ws') {
            const enc = new TextEncoder();
            return enc.encode(str);
        } else {
            const ret = new Uint8Array(str.length);
            for (let i = 0; i < str.length; i++) {
              ret[i] = str.charCodeAt(i);
            }
            return ret
        }
    }

}