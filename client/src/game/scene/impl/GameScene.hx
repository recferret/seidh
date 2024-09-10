package game.scene.impl;

import engine.base.geometry.Rectangle;
import engine.base.BaseTypesAndClasses;
import engine.seidh.SeidhGameEngine;
import engine.seidh.entity.factory.SeidhEntityFactory;

import game.entity.terrain.ClientTerrainEntity;
import game.event.EventManager;
import game.event.EventManager.EventListener;
import game.network.Networking;
import game.scene.base.BasicScene;
import game.sound.SoundManager;
import game.utils.Utils;

class GameScene extends BasicScene implements EventListener {

	public static final TERRAIN_LAYER = 1;
	public static final ITEM_LAYER = 1;
	public static final ZOMBIE_CHARACTER_LAYER = 0;
	public static final RAGNAR_CHARACTER_LAYER = 0;

    public function new(engineMode:EngineMode) {
		super(new SeidhGameEngine(engineMode));

		if (engineMode == EngineMode.CLIENT_MULTIPLAYER) {
			EventManager.instance.subscribe(EventManager.EVENT_GAME_INIT, this);
			EventManager.instance.subscribe(EventManager.EVENT_LOOP_STATE, this);
			EventManager.instance.subscribe(EventManager.EVENT_GAME_STATE, this);
			EventManager.instance.subscribe(EventManager.EVENT_CREATE_CHARACTER, this);
			EventManager.instance.subscribe(EventManager.EVENT_DELETE_CHARACTER, this);
			EventManager.instance.subscribe(EventManager.EVENT_CREATE_CONSUMABLE, this);
			EventManager.instance.subscribe(EventManager.EVENT_DELETE_CONSUMABLE, this);
			EventManager.instance.subscribe(EventManager.EVENT_CHARACTER_ACTIONS, this);

            BasicScene.NetworkingInstance.findAndJoinGame();
		} else if (engineMode == EngineMode.CLIENT_SINGLEPLAYER) {
			createCharacterEntityFromMinimalStruct(
				Player.instance.userEntityId, 
				Player.instance.userId, 
				Std.int(seidhGameEngine.getPlayersSpawnPoints()[0].x), 
				Std.int(seidhGameEngine.getPlayersSpawnPoints()[0].y), 
				RAGNAR_LOH
			);
			seidhGameEngine.allowMobsSpawn(true);
			seidhGameEngine.setLocalPlayerId(Player.instance.userId);
		}

		SoundManager.instance.playGameplayTheme();

		// -------------------------------------------
		// Visual borders
		// -------------------------------------------

		if (GameConfig.instance.Production) {
			// Top
			final topBorder = new h2d.Bitmap(h2d.Tile.fromColor(0x000000, SeidhGameEngine.GameWorldSize, Std.int(SeidhGameEngine.GameWorldSize / 2), 1));
			topBorder.setPosition(0, -topBorder.tile.height);
			topBorder.zOrder = 99;
			add(topBorder);

			// Bottom
			final bottomBorder = new h2d.Bitmap(h2d.Tile.fromColor(0x000000, SeidhGameEngine.GameWorldSize, Std.int(SeidhGameEngine.GameWorldSize / 2), 1));
			bottomBorder.setPosition(0, SeidhGameEngine.GameWorldSize);
			bottomBorder.zOrder = 99;
			add(bottomBorder);

			// Left
			final leftBorder = new h2d.Bitmap(h2d.Tile.fromColor(0x000000, SeidhGameEngine.GameWorldSize, SeidhGameEngine.GameWorldSize * 2, 1));
			leftBorder.setPosition(-leftBorder.tile.width, -SeidhGameEngine.GameWorldSize / 2);
			leftBorder.zOrder = 99;
			add(leftBorder);

			// Right
			final rightBorder = new h2d.Bitmap(h2d.Tile.fromColor(0x000000, SeidhGameEngine.GameWorldSize, SeidhGameEngine.GameWorldSize * 2, 1));
			rightBorder.setPosition(SeidhGameEngine.GameWorldSize, -SeidhGameEngine.GameWorldSize / 2);
			rightBorder.zOrder = 99;
			add(rightBorder);
		}
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
			case EventManager.EVENT_LOOP_STATE:
				processLoopStateEvent(message);
			case EventManager.EVENT_CREATE_CHARACTER:
				processCreateCharacterEntityEvent(message);
			case EventManager.EVENT_DELETE_CHARACTER:
				processDeleteCharacterEntityEvent(message);
			case EventManager.EVENT_CREATE_CONSUMABLE:
				processCreateConsumableEntityEvent(message);
			case EventManager.EVENT_DELETE_CONSUMABLE:
				processDeleteConsumableEntityEvent(message);
			case EventManager.EVENT_CHARACTER_ACTIONS:
				processCharacterActions(message);
		}
	}

	public function start() {
	}

	// Update client part and visuals
	public function customUpdate(dt:Float, fps:Float) {
		final characterToEnvIntersections = new Array<Dynamic>();

		for (character in clientCharacterEntities) {
			character.update(dt, fps);

			characterToEnvIntersections.push(character);

			// final characterBottom = character.getBottomRect().getCenter();
			final characterRect = character.getRect();

			for (terrain in terrainManager.terrainArray) {
				// final treeBottom = tree.getBottomRect().getCenter();
				final terrainRect = terrain.getRect();
	
				if (terrainRect.getCenter().distance(characterRect.getCenter()) < 200) {
					if (terrainRect.intersectsWithRect(characterRect)) {
						characterToEnvIntersections.push(terrain);
					}
		
					if (characterToEnvIntersections.length > 1) {
						characterToEnvIntersections.sort((a, b) -> {
							final aBottom = a.getBottomRect().getCenter();
							final bBottom = b.getBottomRect().getCenter();
							return aBottom.y - bBottom.y;
						});
		
						for (index => env in characterToEnvIntersections) {
							env.zOrder = index;
						}
					}
				}
			}
		}

		if (characterToEnvIntersections.length > 0) {
			sortObjectsByZOrder();
		}

		for (consumable in clientConsumableEntities) {
			consumable.update(dt, fps);
		}

		if (GameConfig.instance.DebugDraw) {
			for (line in seidhGameEngine.getLineColliders()) {
				Utils.DrawLine(
					debugGraphics,
					line.x1,
					line.y1,
					line.x2,
					line.y2, 
					GameConfig.RedColor
				);
			}

			for (character in clientCharacterEntities) {
				character.debugDraw(debugGraphics);
			}

			for (consumable in clientConsumableEntities) {
				consumable.debugDraw(debugGraphics);
			}

			for (spawnPoint in seidhGameEngine.getMobsSpawnPoints()) {
				Utils.DrawRectFilled(
					debugGraphics,
					new Rectangle(spawnPoint.x, spawnPoint.y, 50, 50, 0),
					GameConfig.RedColor
				);
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
		seidhGameEngine.setLocalPlayerId(Player.instance.userId);
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

	private function processCreateConsumableEntityEvent(payload:CreateConsumablePayload) {
		final consumableStruct = payload.consumableEntityStruct.baseEntityStruct;
		switch (payload.consumableEntityStruct.baseEntityStruct.entityType) {
			case COIN:
				seidhGameEngine.createConsumableEntity(SeidhEntityFactory.InitiateCoin(consumableStruct.id, consumableStruct.x, consumableStruct.y, payload.consumableEntityStruct.amount));
			case HEALTH_POTION:
				seidhGameEngine.createConsumableEntity(SeidhEntityFactory.InitiateHealthPotion(consumableStruct.id, consumableStruct.x, consumableStruct.y, payload.consumableEntityStruct.amount));
			case LOSOS:
				seidhGameEngine.createConsumableEntity(SeidhEntityFactory.InitiateLosos(consumableStruct.id, consumableStruct.x, consumableStruct.y, payload.consumableEntityStruct.amount));
			default:
		}
	}

	private function processDeleteConsumableEntityEvent(payload:DeleteConsumablePayload) {
		seidhGameEngine.deleteConsumableEntity(payload.entityId, payload.takenByCharacterId);
	}

	private function processCharacterActions(payload:ActionsPayload) {
		for (action in payload.actions) {
			if (action.entityId != Player.instance.userEntityId) {
				seidhGameEngine.setCharacterNextActionToPerform(action.entityId, action.actionType);
			}
		}
	}

}