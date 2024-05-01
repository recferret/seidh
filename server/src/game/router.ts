import { EventType, Events } from "./events.js";

export enum ProtocolMessage { 
    join = 'join',
    input = 'input',
}

export class Router {
    protected routeMessage(jsonMsg: any) {
        switch (jsonMsg.msg) {
            case ProtocolMessage.join:
                Events.eventEmitter.emit(EventType.JOIN, { playerId: jsonMsg.playerId });
                break;
            case ProtocolMessage.input:
                Events.eventEmitter.emit(EventType.INPUT, { 
                    playerId: jsonMsg.playerId, 
                    inputType: jsonMsg.inputType,
                    movAngle: jsonMsg.movAngle,
                });
                break;
            default:
                console.log('Unknown message received');
        }
    }
}