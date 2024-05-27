package game.scene.impl;

import game.event.EventManager;
import game.event.EventManager.EventListener;
import game.network.Networking;
import game.scene.base.BasicScene;
import engine.seidh.SeidhGameEngine;

class SceneNetworkTest extends BasicScene implements EventListener {

    public function new() {
		super(new SeidhGameEngine());

		// var wsConnectButton:h2d.Flow;
		// var wsConnectButton:h2d.Flow; 

        // wsConnectButton = addButton('WS CONNECT', function callback(button:h2d.Flow) {
            // networking.wsConnect();
        // });

		// wsConnectButton = addButton('CONNECT', function callback(button:h2d.Flow) {
        //     networking.wsConnect();
        // });

        addButton('LOGIN', function callback(button:h2d.Flow) {
            networking.findAndJoinGame();
			fui.removeChild(button);
        });

		EventManager.instance.subscribe(EventManager.EVENT_GAME_INIT, this);
		EventManager.instance.subscribe(EventManager.EVENT_GAME_STATE, this);
		EventManager.instance.subscribe(EventManager.EVENT_CREATE_CHARACTER, this);
		EventManager.instance.subscribe(EventManager.EVENT_DELETE_CHARACTER, this);
		EventManager.instance.subscribe(EventManager.EVENT_PERFORM_ACTION, this);

		initNetwork();
    }

    // --------------------------------------
	// Impl
	// --------------------------------------

	public function notify(event:String, message:Dynamic) {
		switch (event) {
			case EventManager.EVENT_GAME_INIT:
				processGameInitEvent(message);
			case EventManager.EVENT_GAME_STATE:
				processGameStateEvent(message);
			case EventManager.EVENT_CREATE_CHARACTER:
				processCreateCharacterEntityEvent(message);
			case EventManager.EVENT_DELETE_CHARACTER:
				processDeleteCharacterEntityEvent(message);
			case EventManager.EVENT_PERFORM_ACTION:
				processPerformActionEvent(message);
		}
	}

	public function start() {
	}

	// Update client part and visuals
	public function customUpdate(dt:Float, fps:Float) {
		for (character in clientCharacterEntities) {
			character.update(dt);

			if (GameConfig.DebugDraw) {
				character.debugDraw(debugGraphics);
			}
		}
	}

	// ---------------------------------------
	// Server -> Client socket events
	// ---------------------------------------

	private function processGameInitEvent(payload:GameInitPayload) {
		for (characterStruct in payload.charactersFullStruct ) {
			baseEngine.createCharacterEntityFromFullStruct(characterStruct);
		}
		baseEngine.setLocalPlayerId(Player.instance.playerId);
	}

	private function processGameStateEvent(payload:GameStatePayload) {
		baseEngine.updateCharacterEntitiesByServer(payload.charactersMinStruct);
	}

	private function processCreateCharacterEntityEvent(payload:CreateCharacterPayload) {
		baseEngine.createCharacterEntityFromFullStruct(payload.characterEntityFullStruct);
	}

	private function processDeleteCharacterEntityEvent(payload:DeleteCharacterPayload) {
		baseEngine.deleteCharacterEntity(payload.characterId);
	}

	private function processPerformActionEvent(payload:ActionsPayload) {
		for (action in payload.actions) {
			if (action.entityId != Player.instance.playerEntityId) {
				baseEngine.setCharacterNextActionToPerform(action.entityId, action.actionType);
			}
		}
	}

}