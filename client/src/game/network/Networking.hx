package game.network;

import engine.base.BaseTypesAndClasses;
import engine.seidh.SeidhGameEngine.CharacterActionCallbackParams;
import game.event.EventManager;
import game.js.NativeWindowJS;

typedef GameInitPayload = {
    gameId:String,
	charactersFullStruct :Array<CharacterEntityFullStruct>,
}

typedef CreateCharacterPayload = {
    characterEntityFullStruct:CharacterEntityFullStruct,
}

typedef DeleteCharacterPayload = {
	characterId:String,
}

typedef GameStatePayload = {
	charactersMinStruct:Array<CharacterEntityMinStruct>,
}

typedef ActionsPayload = {
    actions:Array<CharacterActionCallbackParams>,
}

class Networking {

    private var joined = false;

    public function new() {
        NativeWindowJS.networkInit(Player.instance.playerId, callback);
    }

    // public function wsConnect() {
        // NativeWindowJS.wsConnect(callback);
    // }

    // public function sendLogin() {
    //     final message = { msg: 'login', playerId: Player.instance.playerId };
    //     sendData(message);
    // }

    // public function sendJoin() {
    //     final message = { msg: 'join', playerId: Player.instance.playerId };
    //     sendData(message);
    // }

    public function findAndJoinGame() {
        NativeWindowJS.networkFindAndJoinGame(Player.instance.playerId);
    }

    public function input(input:PlayerInputCommand) {
        NativeWindowJS.networkInput(input.actionType, input.movAngle);
    }

    private function callback(message:Dynamic) {
        final type:String = message.type;
        final data:Dynamic = message.data;

        switch (type) {
            case 'GameInit':
                EventManager.instance.notify(EventManager.EVENT_GAME_INIT, data);
            case 'GameState':
                EventManager.instance.notify(EventManager.EVENT_GAME_STATE, data);
            case 'CreateCharacter':
                EventManager.instance.notify(EventManager.EVENT_CREATE_CHARACTER, data);
            case 'DeleteCharacter':
                EventManager.instance.notify(EventManager.EVENT_DELETE_CHARACTER, data);
            default:
                trace('Unknown message');
        }

        // switch (json.msg) {
        //     case 'login':
        //         sendJoin();
        //     case 'joinGame':
        //         joined = true;
        //         EventManager.instance.notify(EventManager.EVENT_JOIN_GAME, json);
        //     case 'gameState':
        //         if (joined)
        //             EventManager.instance.notify(EventManager.EVENT_GAME_STATE, json);
        //     case 'createEntity':
        //         if (joined)
        //             EventManager.instance.notify(EventManager.EVENT_CREATE_ENTITY, json);
        //     case 'deleteEntity':
        //         if (joined)
        //             EventManager.instance.notify(EventManager.EVENT_DELETE_ENTITY, json);    
        //     case 'performAction':
        //         if (joined)
        //             EventManager.instance.notify(EventManager.EVENT_PERFORM_ACTION, json);
        //     default:
        //         trace('Unknown message');
        // }
    }
}