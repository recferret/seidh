package game.network;

import engine.base.BaseTypesAndClasses;
import engine.seidh.SeidhGameEngine.CharacterActionCallbackParams;
import game.event.EventManager;
import game.js.NativeWindowJS;
import haxe.Json;

typedef JoinGamePayload = {
	entities:Array<Dynamic>,
}

typedef DeleteEntityPayload = {
	entityId:String,
}

typedef GameStatePayload = {
	entities:Array<CharacterEntityMinStruct>,
}

typedef ActionsPayload = {
    actions:Array<CharacterActionCallbackParams>,
}

class Networking {

    private var joined = false;

    public function new() {
    }

    public function wsConnect() {
        NativeWindowJS.wsConnect(callback);
    }

    public function sendLogin() {
        final message = { msg: 'login', playerId: Player.instance.playerId };
        sendData(message);
    }

    public function sendJoin() {
        final message = { msg: 'join', playerId: Player.instance.playerId };
        sendData(message);
    }

    public function sendInput(input:PlayerInputCommand) {
        final message = { 
            msg: 'input', 
            playerId: Player.instance.playerId, 
            actionType: input.actionType,
            movAngle: null
        };
        if (input.actionType == CharacterActionType.MOVE) {
            message.movAngle = input.movAngle;
        }
        trace(message);
        sendData(message);
    }

    private function sendData(message:Dynamic) {
        NativeWindowJS.wsSend(Json.stringify(message));
    }

    private function callback(data:String) {
        final json = Json.parse(data);
        switch (json.msg) {
            case 'login':
                sendJoin();
            case 'joinGame':
                joined = true;
                EventManager.instance.notify(EventManager.EVENT_JOIN_GAME, json);
            case 'gameState':
                if (joined)
                    EventManager.instance.notify(EventManager.EVENT_GAME_STATE, json);
            case 'createEntity':
                if (joined)
                    EventManager.instance.notify(EventManager.EVENT_CREATE_ENTITY, json);
            case 'deleteEntity':
                if (joined)
                    EventManager.instance.notify(EventManager.EVENT_DELETE_ENTITY, json);    
            case 'performAction':
                if (joined)
                    EventManager.instance.notify(EventManager.EVENT_PERFORM_ACTION, json);
            default:
                trace('Unknown message');
        }
    }
}