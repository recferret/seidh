const serverAddress = '23.111.202.19';

let _webSocket;
let _wtClient;

function BinArrayToStr(binArray, transport) {
    if (transport === 'ws') {
        const enc = new TextDecoder();
        return enc.decode(binArray);
    } else {
        let str = "";
        for (let i = 0; i < binArray.length; i++) {
          str += String.fromCharCode(parseInt(binArray[i]));
        }
        return str;
    }
}

function StrToBinArray(str, transport) {
    if (transport === 'ws') {
        const enc = new TextEncoder();
        return enc.encode(str);
    } else if (transport === 'wt') {
        const ret = new Uint8Array(str.length);
        for (let i = 0; i < str.length; i++) {
          ret[i] = str.charCodeAt(i);
        }
        return ret;
    }
}

// ---------------------------------
// WebSocket 
// ---------------------------------

function wsConnect(callback) {
    _webSocket = new WebSocket(`wss://${serverAddress}:3000`);
    // _webSocket = new WebSocket(`wss://localhost:3000`);
    _webSocket.binaryType = "arraybuffer";

    _webSocket.onopen = (event) => {
        console.log('WS Connected');
    };
    _webSocket.onmessage = (event) => {
        if (callback)
            callback(BinArrayToStr(event.data, 'ws'));
    };
}

function wsSend(message) {
    _webSocket.send(StrToBinArray(message, 'ws'));
}

// ---------------------------------
// WebTransport 
// ---------------------------------

class WebTransportClient {
    constructor(transport, callback) {
        this.callback = callback;

        this.datagramsReader = transport.datagrams.readable.getReader();
        this.datagramsWriter = transport.datagrams.writable.getWriter();
        this.bidiStreams = transport.incomingBidirectionalStreams;

        this.bidirectionalInit();
        this.readData('unreliable');
    }

    async bidirectionalInit() {
        const reader = this.bidiStreams.getReader();
        while (true) {
            const { done, value } = await reader.read();
            if (done) {
                break;
            }

            if (!this.bidiReader) {
                this.bidiReader = value.readable.getReader();
                this.bidiReader.closed.catch(e => console.log("Bidi readable closed", e.toString()));
            }

            if (!this.bidiWriter) {
                this.bidiWriter = value.writable.getWriter();
                this.bidiWriter.closed.catch(e => console.log("Bidi writable closed", e.toString()));
            }

            await this.readData('reliable');
        }
    }

    async writeData(streamType, data) {
        const writer = streamType === 'unreliable' ? this.datagramsWriter : this.bidiWriter;

        try {
            if (writer) {
            await writer.write(data);
            } 
        } catch (err) {
            console.error('Write bidi data error:', err);
        }
    }
  
    async readData(streamType) {
        const streamReader = streamType === 'unreliable' ? this.datagramsReader : this.bidiReader;

        if (streamReader) {
            let isOpen = true;

            streamReader.closed
                .catch((e) => console.error("Failed to close", e.toString()))
                .finally(() => isOpen = false);

            while (isOpen) {
                try {
                    const { done, value } = await streamReader.read();
                    if (done) { break; }
                    if (this.callback) this.callback(BinArrayToStr(value, 'wt'));
                } catch (e) {
                    console.error("Failed to read...", e.toString());
                    break;
                }
            }
        }
    }

}

function wtConnect(callback) {
    const webTransport = new WebTransport(`https://${serverAddress}:3000`);
    webTransport.ready.then(() => {
        _wtClient = new WebTransportClient(webTransport, callback);
        console.log('WT Connected');
    });
}

function wtSend(message) {
    _wtClient.writeData('reliable', StrToBinArray(message, 'wt'));
}
