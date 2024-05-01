import { ReadableStreamDefaultReader, WritableStreamDefaultWriter } from "stream/web";
import { WebTransportSession } from "@fails-components/webtransport";
import { ServerTransport, TransportType } from "./transport.js";
import { Router } from "./router.js";
import { Events, EventType } from "./events.js";

export class WebTransportServerClient extends Router {

    private datagramReader: ReadableStreamDefaultReader;
    private datagramWriter: WritableStreamDefaultWriter;
  
    private bidiReader: ReadableStreamDefaultReader;
    private bidiWriter: WritableStreamDefaultWriter;
  
    private ready = false;
    private playerId:string;
  
    constructor(wtSession: WebTransportSession ) {
      super();

      wtSession.ready.then(() => {
        wtSession.createBidirectionalStream().then((bidi) => {
          this.bidiReader = bidi.readable.getReader();
          this.bidiWriter = bidi.writable.getWriter();
  
          this.bidiReader.closed.catch((e) => { console.error("Bidi reader closed with error!", e); });
          this.bidiWriter.closed.catch((e) => { console.error("Bidi writer closed with error!", e); });
  
          this.ready = true;
  
          this.readData('reliable');
        });

        this.datagramReader = wtSession.datagrams.readable.getReader();
        this.datagramWriter = wtSession.datagrams.writable.getWriter();
  
        this.datagramReader.closed.catch((e: any) => console.error("Datagram reader closed with error!", e));
        this.datagramWriter.closed.catch((e: any) => console.error("Datagram writer closed with error!", e));
  
        this.readData('unreliable');
      });

      wtSession.closed
        .then((e) => {
          Events.eventEmitter.emit(EventType.DISCONNECT, { playerId: this.playerId });
          ServerTransport.PlayerLeft(this.playerId, TransportType.WEBSOCKET);

          console.log('WT client disconnected', e);
        })
        .catch((e: any) => {
          Events.eventEmitter.emit(EventType.DISCONNECT, { playerId: this.playerId });
          ServerTransport.PlayerLeft(this.playerId, TransportType.WEBSOCKET);

          console.log('WT client disconnected', e);
        });
    }
  
    async readData(streamType: string) {
        let read = undefined;
        const reader = streamType === 'unreliable'? this.datagramReader : this.bidiReader;

        while (this.ready) {
            try {
                read = await reader.read();
            } catch (e) {
                return;
            }
            if (read.done) {
                return;
            }
            await this.routeData(ServerTransport.BinArrayToJson(read.value, 'wt'));
        }
    }

    async writeData(streamType: string, data: any) {
        const writer = streamType === 'unreliable' ? this.datagramWriter : this.bidiWriter;

        try {
            if (writer) {
                await writer.write(data);
            } 
        } catch (err) {
            console.error('Write bidi data error:', err);
        }
    }
  
    async routeData(json: any) {
        switch (json.msg) {
            case 'login':
                this.playerId = json.playerId;
                ServerTransport.WTClients.set(this.playerId, this);
                ServerTransport.PlayerJoined(this.playerId, TransportType.WEBTRANSPORT);
                await this.writeData('reliable', ServerTransport.StrToBinArray(JSON.stringify({msg: 'login'}), 'wt'));
                break;
            default:
                this.routeMessage(json);
        }
    }
  
}
