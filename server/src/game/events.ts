import EventEmitter from 'node:events';
import { TransportType } from './transport.js';

export enum EventType {
    DISCONNECT = 'disconnect',
    JOIN = 'join',
    INPUT = 'input',
}

export type JoinEvent = {
    playerId: string,
    transportType: TransportType,
}

export type DisconnectedEvent = {
    playerId: string,
    transportType: TransportType,
}

export interface PlayerInputType {
    MOVE_UP: 1;
	MOVE_DOWN: 2;
	MOVE_LEFT: 3;
	MOVE_RIGHT: 4;

	MOVE_UP_LEFT: 5;
	MOVE_UP_RIGHT: 6;
	MOVE_DOWN_LEFT: 7;
	MOVE_DOWN_RIGHT: 8;

	MELEE_ATTACK: 9;
	RANGED_ATTACK: 10;
	DEFEND: 11;
}

export type InputEvent = {
    playerId: string,
    inputType: PlayerInputType,
}

export class Events {

    public static eventEmitter = new EventEmitter();
    static Events: any;
    static EventType: any;

}