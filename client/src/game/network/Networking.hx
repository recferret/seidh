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

class Networking {

    private var joined = false;

    public function new() {
        NativeWindowJS.networkInit(Player.instance.playerId, callback);
    }

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
            case 'LoopState':
                EventManager.instance.notify(EventManager.EVENT_LOOP_STATE, data);
            case 'GameState':
                EventManager.instance.notify(EventManager.EVENT_GAME_STATE, data);
            case 'CreateCharacter':
                EventManager.instance.notify(EventManager.EVENT_CREATE_CHARACTER, data);
            case 'DeleteCharacter':
                EventManager.instance.notify(EventManager.EVENT_DELETE_CHARACTER, data);
            case 'CreateConsumable':
                EventManager.instance.notify(EventManager.EVENT_CREATE_CONSUMABLE, data);
            case 'DeleteConsumable':
                EventManager.instance.notify(EventManager.EVENT_DELETE_CONSUMABLE, data);
            case 'CharacterActions':
                EventManager.instance.notify(EventManager.EVENT_CHARACTER_ACTIONS, data);
            default:
                trace('Unknown message');
        }
    }
}