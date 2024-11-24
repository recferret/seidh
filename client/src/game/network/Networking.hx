package game.network;

import engine.base.core.BaseEngine.GameState;
import engine.base.BaseTypesAndClasses;
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

typedef CreateConsumablePayload = {
    consumableEntityStruct: {
        baseEntityStruct: BaseEntityStruct,
        amount:Int,
    }
}

typedef DeleteConsumablePayload = {
	entityId:String,
    takenByCharacterId:String,
}

typedef LoopStatePayload = {
	charactersMinStruct:Array<CharacterEntityMinStruct>,
}

typedef GameStatePayload = {
	gameState:GameState,
}

typedef ActionsPayload = {
    actions:Array<CharacterActionCallbackParams>,
}

typedef UserBalancePayload = {
    coins:Int,
    teeth:Int,
}

class Networking {

    private var joined = false;

    public function new() {
        NativeWindowJS.networkWsInit(callback);
    }

    public function findAndJoinGame() {
        NativeWindowJS.networkFindAndJoinGame(GameClientConfig.instance.JoinGameType);
    }

    public function input(input:PlayerInputCommand) {
        NativeWindowJS.networkInput(input.actionType, input.movAngle);
    }

    private function callback(message:Dynamic) {
        final type:String = message.type;
        final data:Dynamic = message.data;

        switch (type) {
            case EventManager.EVENT_GAME_INIT:
                EventManager.instance.notify(EventManager.EVENT_GAME_INIT, data);
            case EventManager.EVENT_LOOP_STATE:
                EventManager.instance.notify(EventManager.EVENT_LOOP_STATE, data);
            case EventManager.EVENT_GAME_STATE:
                EventManager.instance.notify(EventManager.EVENT_GAME_STATE, data);
            case EventManager.EVENT_CREATE_CHARACTER:
                EventManager.instance.notify(EventManager.EVENT_CREATE_CHARACTER, data);
            case EventManager.EVENT_DELETE_CHARACTER:
                EventManager.instance.notify(EventManager.EVENT_DELETE_CHARACTER, data);
            case EventManager.EVENT_CREATE_CONSUMABLE:
                EventManager.instance.notify(EventManager.EVENT_CREATE_CONSUMABLE, data);
            case EventManager.EVENT_DELETE_CONSUMABLE:
                EventManager.instance.notify(EventManager.EVENT_DELETE_CONSUMABLE, data);
            case EventManager.EVENT_CHARACTER_ACTIONS:
                EventManager.instance.notify(EventManager.EVENT_CHARACTER_ACTIONS, data);
            case EventManager.EVENT_USER_BALANCE:
                EventManager.instance.notify(EventManager.EVENT_USER_BALANCE, data);
            default:
                trace('Unknown message');
        }
    }
}