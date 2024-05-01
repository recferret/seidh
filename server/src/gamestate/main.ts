import { readFile } from "node:fs/promises";
import { createServer } from "node:https";
import { ReadableStreamDefaultReader, WritableStreamDefaultWriter } from "stream/web";
import { Http3Server, WebTransportSession } from "@fails-components/webtransport";
import { WebSocketServer } from 'ws';

let gameStateIndex = 0;

setInterval(() => {
  gameStateIndex++;
}, 32);

class WebTransportServerClient {

  private datagramReader: ReadableStreamDefaultReader;
  private datagramWriter: WritableStreamDefaultWriter;

  private bidiReader: ReadableStreamDefaultReader;
  private bidiWriter: WritableStreamDefaultWriter;

  private readyState = 0;

  constructor(wtSession: WebTransportSession ) {
    wtSession.ready.then(() => {
      this.readyState = 1;

      this.datagramReader = wtSession.datagrams.readable.getReader();
      this.datagramWriter = wtSession.datagrams.writable.getWriter();

      this.datagramReader.closed.catch((e: any) => console.error("Datagram reader closed with error!", e));
      this.datagramWriter.closed.catch((e: any) => console.error("Datagram writer closed with error!", e));

      this.readIncomingUnreliable();

      setInterval(async () => {
        await this.datagramWriter.write(this.jsonToBinArray({ msg: 'gameState', gameStateIndex }));
      }, 100)

    });
  }

  async readIncoming() {
    let read = undefined;
    while (this.readyState === 1) {
      try {
        read = await this.bidiReader.read();
      } catch (e) {
        return;
      }
      if (read.done) {
        return;
      }
      await this.routeData(this.binArrayToJson(read.value), false);
    }
  }
    
  async readIncomingUnreliable() {
    let read = undefined;
   
    while (this.readyState === 1) {
      try {
        read = await this.datagramReader.read();
      } catch (e) {
        return;
      }
      if (read.done) {
        return;
      }
      await this.routeData(this.binArrayToJson(read.value), true);
    }
  }

  async routeData(json: any, isUnreliable = false) {
    const writer = isUnreliable? this.datagramWriter : this.bidiWriter;
    if (writer) {
      switch (json.msg) {
        default:
          console.log('Unknown message received');
      }
    } else {
      console.error('No writer available');
    } 
  }

  private binArrayToJson(binArray: any) {
    let str = "";
    for (let i = 0; i < binArray.length; i++) {
      str += String.fromCharCode(parseInt(binArray[i]));
    }
    return JSON.parse(str)
  }
  
  private jsonToBinArray(json: any) {
    const str = JSON.stringify(json, null, 0);
    const ret = new Uint8Array(str.length);
    for (let i = 0; i < str.length; i++) {
      ret[i] = str.charCodeAt(i);
    }
    return ret
  };
}

class NodeServer {
  private key: Buffer;
  private cert: Buffer;

  private http3Server: Http3Server;
  private isListening = false;

  constructor() {
    this.readCert()
      .then(async ({ key, cert }) => {
        this.key = key;
        this.cert = cert;
        await this.initHttpServer();
        await this.initHttp3Server();
      });
  }

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
        const content = await readFile("./src/gamestate/index.html");
        res.writeHead(200, {
          "content-type": "text/html"
        });
        res.write(content);
        res.end();
      } else {
        res.writeHead(404).end(); 
      }
    });
          
    const port = process.env.PORT || 3001;
       
    const wss = new WebSocketServer({ server });

    wss.on('connection', function connection(ws) {
      let wssGameStateInterval = setInterval(() => {
        ws.send(JSON.stringify({ msg: 'gameState', gameStateIndex }));
      }, 100);

      ws.on('error', function error(error) { 
        console.error(error);
        clearInterval(wssGameStateInterval);
      });
    });

    server.listen(port, () => {
      console.log(`server listening at https://localhost:${port}`);
    });
  }

  private async initHttp3Server() {
    this.http3Server = new Http3Server({
      host: '0.0.0.0',
      port: '3001',
      secret: "changeit",
      cert: this.cert,
      privKey: this.key,
    });
        
    this.http3Server.startServer();
    this.isListening = true;
    await this.acceptIncomingSessions();
  }

  async acceptIncomingSessions() {
    try {
      const sessionStream = await this.http3Server.sessionStream("/");
      const sessionReader = sessionStream.getReader();
      sessionReader.closed.catch((e: any) => console.log("session reader closed with error!", e));
    
      while (this.isListening) {
        const { done, value } = await sessionReader.read();
        if (done) { break; }

        new WebTransportServerClient(value);
      }
    } catch (e) {
      console.error("error:", e);
    }
  }
}

new NodeServer();