package game.scene.impl;

import game.event.EventManager;
import game.event.EventManager.EventListener;
import game.network.Networking;
import game.scene.base.BasicScene;
import engine.holy.HolyGameEngine;

class SceneNetworkTest extends BasicScene implements EventListener {

    public function new() {
		super(new HolyGameEngine());

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
				processCreacteEntityEvent(message);
			case EventManager.EVENT_DELETE_ENTITY:
				processDeleteEntityEvent(message);
			case EventManager.EVENT_PERFORM_ACTION:
				processPerformActionEvent(message);
		}
	}

	public function start() {
	}

	// Update client part and visuals
	public function customUpdate(dt:Float, fps:Float) {
		if (GameConfig.DebugDraw) {
			debugGraphics.clear();
		}
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
			baseEngine.buildEngineEntityFromMinimalStruct(entityStruct);
		}
	}

	private function processGameStateEvent(payload:GameStatePayload) {
		baseEngine.updateEntitiesByServer(payload.entities);
	}

	private function processCreacteEntityEvent(payload:Dynamic) {
		baseEngine.buildEngineEntityFromMinimalStruct(payload.entity);
	}

	private function processDeleteEntityEvent(payload:DeleteEntityPayload) {
		baseEngine.removeMainEntity(payload.entityId);
	}

	private function processPerformActionEvent(payload:ActionsPayload) {
		for (action in payload.actions) {
			if (action.entityId != Player.instance.playerEntityId) {
				baseEngine.setEntityNextActionToPerform(action.entityId, action.actionType);
			}
		}
	}

}