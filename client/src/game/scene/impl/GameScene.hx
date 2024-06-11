package game.scene.impl;

import haxe.Timer;

import engine.seidh.SeidhGameEngine;

import game.event.EventManager;
import game.event.EventManager.EventListener;
import game.network.Networking;
import game.scene.base.BasicScene;

enum abstract GameMode(Int) {
	var SINGLEPLAYER = 1;
	var MULTIPLAYER = 2;
}

class GameScene extends BasicScene implements EventListener {

    public function new(gameMode:GameMode) {
		super(new SeidhGameEngine());

		if (gameMode == GameMode.MULTIPLAYER) {
			EventManager.instance.subscribe(EventManager.EVENT_GAME_INIT, this);
			EventManager.instance.subscribe(EventManager.EVENT_LOOP_STATE, this);
			EventManager.instance.subscribe(EventManager.EVENT_GAME_STATE, this);
			EventManager.instance.subscribe(EventManager.EVENT_CREATE_CHARACTER, this);
			EventManager.instance.subscribe(EventManager.EVENT_DELETE_CHARACTER, this);
			EventManager.instance.subscribe(EventManager.EVENT_CHARACTER_ACTIONS, this);

			initNetwork();
			Timer.delay(function callback() {
                networking.findAndJoinGame();
            }, 1000);
		} else {
			createCharacterEntityFromMinimalStruct(Player.instance.playerEntityId, Player.instance.playerId, 2000, 2000, RAGNAR_LOH);
			seidhGameEngine.allowMobsSpawn(true);
		}

		SceneManager.Sound.playGameplayTheme();

		// var wsConnectButton:h2d.Flow;
		// var wsConnectButton:h2d.Flow; 

        // wsConnectButton = addButton('WS CONNECT', function callback(button:h2d.Flow) {
            // networking.wsConnect();
        // });

		// wsConnectButton = addButton('CONNECT', function callback(button:h2d.Flow) {
        //     networking.wsConnect();
        // });

        // addButton('LOGIN', function callback(button:h2d.Flow) {
        //     networking.findAndJoinGame();
		// 	fui.removeChild(button);
        // });
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
			case EventManager.EVENT_CHARACTER_ACTIONS:
				processCharacterActions(message);
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
			seidhGameEngine.createCharacterEntityFromFullStruct(characterStruct);
		}
		seidhGameEngine.setLocalPlayerId(Player.instance.playerId);
	}

	private function processLoopStateEvent(payload:LoopStatePayload) {
		seidhGameEngine.updateCharacterEntitiesByServer(payload.charactersMinStruct);
	}

	private function processGameStateEvent(payload:GameStatePayload) {
		seidhGameEngine.setGameState(payload.gameState);
	}

	private function processCreateCharacterEntityEvent(payload:CreateCharacterPayload) {
		seidhGameEngine.createCharacterEntityFromFullStruct(payload.characterEntityFullStruct);
	}

	private function processDeleteCharacterEntityEvent(payload:DeleteCharacterPayload) {
		seidhGameEngine.deleteCharacterEntity(payload.characterId);
	}

	private function processCharacterActions(payload:ActionsPayload) {
		for (action in payload.actions) {
			if (action.entityId != Player.instance.playerEntityId) {
				seidhGameEngine.setCharacterNextActionToPerform(action.entityId, action.actionType);
			}
		}
	}

}