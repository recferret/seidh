package game.scene.impl;

import game.event.EventManager;
import game.event.EventManager.EventListener;
import game.network.Networking;
import game.scene.base.BasicScene;
import engine.seidh.SeidhGameEngine;

class SceneNetworkTest extends BasicScene implements EventListener {

    public function new() {
		super(new SeidhGameEngine());

		camera.scale(2, 2);

		initNetwork();

		// var wsConnectButton:h2d.Flow;
		var wsConnectButton:h2d.Flow; 

        // wsConnectButton = addButton('WS CONNECT', function callback(button:h2d.Flow) {
            // networking.wsConnect();
        // });

		wsConnectButton = addButton('CONNECT', function callback(button:h2d.Flow) {
            networking.wsConnect();
        });

        addButton('LOGIN', function callback(button:h2d.Flow) {
            networking.sendLogin();
			// fui.removeChild(wsConnectButton);
			fui.removeChild(wsConnectButton);
			fui.removeChild(button);

        });

		EventManager.instance.subscribe(EventManager.EVENT_JOIN_GAME, this);
		EventManager.instance.subscribe(EventManager.EVENT_GAME_STATE, this);
		EventManager.instance.subscribe(EventManager.EVENT_CREATE_ENTITY, this);
		EventManager.instance.subscribe(EventManager.EVENT_DELETE_ENTITY, this);
		EventManager.instance.subscribe(EventManager.EVENT_PERFORM_ACTION, this);
    }

    // --------------------------------------
	// Impl
	// --------------------------------------

	public function notify(event:String, message:Dynamic) {
		switch (event) {
			case EventManager.EVENT_JOIN_GAME:
				processJoinGameEvent(message);
			case EventManager.EVENT_GAME_STATE:
				processGameStateEvent(message);
			case EventManager.EVENT_CREATE_ENTITY:
				processCreateCharacterEntityEvent(message);
			case EventManager.EVENT_DELETE_ENTITY:
				processRemoveCharacterEntityEvent(message);
			case EventManager.EVENT_PERFORM_ACTION:
				processPerformActionEvent(message);
		}
	}

	public function start() {
	}

	// Update client part and visuals
	public function customUpdate(dt:Float, fps:Float) {
		for (clientEntity in clientMainEntities) {
			clientEntity.update(dt);

			if (GameConfig.DebugDraw) {
				clientEntity.debugDraw(debugGraphics);
			}
		}
	}

	//

	private function processJoinGameEvent(payload:JoinGamePayload) {
		for (entityStruct in payload.entities) {
			baseEngine.createCharacterEntityFromMinimalStruct(entityStruct);
		}
	}

	private function processGameStateEvent(payload:GameStatePayload) {
		baseEngine.updateCharacterEntitiesByServer(payload.entities);
	}

	private function processCreateCharacterEntityEvent(payload:Dynamic) {
		baseEngine.createCharacterEntityFromMinimalStruct(payload.entity);
	}

	private function processRemoveCharacterEntityEvent(payload:DeleteEntityPayload) {
		baseEngine.removeCharacterEntity(payload.entityId);
	}

	private function processPerformActionEvent(payload:ActionsPayload) {
		for (action in payload.actions) {
			if (action.entityId != Player.instance.playerEntityId) {
				baseEngine.setCharacterNextActionToPerform(action.entityId, action.actionType);
			}
		}
	}

}