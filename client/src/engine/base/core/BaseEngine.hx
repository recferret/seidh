package engine.base.core;

import engine.base.BaseTypesAndClasses;
import engine.base.core.GameLoop;
import engine.base.entity.EngineBaseGameEntity;
import engine.base.entity.BaseEntityManager;

enum EngineMode {
	Client;
	Server;
}

typedef CreateMainEntityTask = {
	var fireCallback:Bool;
	var entity:EngineBaseGameEntity;
}

@:expose
abstract class BaseEngine {
	final gameLoop:GameLoop;

	public var tick:Int;

	public var recentEngineLoopTime:Float;
	public final okLoopTime:Int;
	public final engineMode:EngineMode;

	public var postLoopCallback:Void->Void;
	public var createMainEntityCallback:EngineBaseGameEntity->Void;
	public var deleteMainEntityCallback:EngineBaseGameEntity->Void;

	public final mainEntityManager:BaseEntityManager;
	public final playerToEntityMap = new Map<String, String>();

	public var validatedInputCommands = new Array<PlayerInputCommand>();

	private var addMainEntityQueue = new Array<CreateMainEntityTask>();
	private var removeMainEntityQueue = new Array<String>();

	// Команды от пользователей, которые будут применены в начале каждого тика
	private var hotInputCommands = new Array<InputCommandEngineWrapped>();

	// История команд за последние N тиков
	public var ticksSinceLastPop = 0;
	public final coldInputCommandsTreshhold = 10;
	public final coldInputCommands = new Array<InputCommandEngineWrapped>();

	public function new(engineMode:EngineMode, mainEntityManager:BaseEntityManager) {
		this.engineMode = engineMode;
		this.mainEntityManager = mainEntityManager;

		gameLoop = new GameLoop(function loop(dt:Float, tick:Int) {
			this.tick = tick;

			// Remove outdated inputs from cache
			if (ticksSinceLastPop == coldInputCommandsTreshhold) {
				ticksSinceLastPop = 0;
				coldInputCommands.shift();
			}
			ticksSinceLastPop++;

			processCreateEntityQueue();
			processRemoveEntityQueue();

			// Apply inputs
			if (hotInputCommands.length > 0) {
				processInputCommands(hotInputCommands);
				hotInputCommands = [];
			}

			// Update all entities
			engineLoopUpdate(dt);

			if (postLoopCallback != null) {
				postLoopCallback();
			}
			validatedInputCommands = [];
		});

		okLoopTime = Std.int(1000 / gameLoop.targetFps);
	}

	// -----------------------------------
	// Abstract functions
	// -----------------------------------

	public abstract function processInputCommands(playerInputCommands:Array<InputCommandEngineWrapped>):Void;

	public abstract function engineLoopUpdate(dt:Float):Void;

	public abstract function customDestroy():Void;

	// -----------------------------------
	// Main entity management
	// -----------------------------------

	function createMainEntity(entity:EngineBaseGameEntity, fireCallback = false) {
		addMainEntityQueue.push({
			entity: entity,
			fireCallback: fireCallback
		});
	}

	public function removeMainEntity(entityId:String) {
		removeMainEntityQueue.push(entityId);
	}

	public function getMainEntityById(id:String) {
		return mainEntityManager.getEntityById(id);
	}

	public function getMainEntityIdByOwnerId(id:String) {
		return playerToEntityMap.get(id);
	}

	public function getMainEntityByOwnerId(id:String) {
		return mainEntityManager.getEntityById(playerToEntityMap.get(id));
	}

	public function updateEntitiesByServer(minEntities:Array<EntityMinStruct>) {
		for (minEntity in minEntities) {
			final entity = mainEntityManager.entities.get(minEntity.id);
			if (entity != null) {
				entity.setX(minEntity.x);
				entity.setY(minEntity.y);
				entity.currentDirectionSide = minEntity.side;
			}
		}
	}

	public function setEntityNextActionToPerform(entityId:String, entityActionType:EntityActionType) {
		final entity = mainEntityManager.getEntityById(entityId);
		if (entity != null) {
			entity.setNextActionToPerform(entityActionType);
		}
	}

	public function getMainEntities() {
		return mainEntityManager.entities;
	}

	public function processCreateEntityQueue() {
		for (queueTask in addMainEntityQueue) {
			mainEntityManager.add(queueTask.entity);
			playerToEntityMap.set(queueTask.entity.getOwnerId(), queueTask.entity.getId());
			if (queueTask.fireCallback) {
				if (createMainEntityCallback != null) {
					createMainEntityCallback(queueTask.entity);
				}
			}
		}
		addMainEntityQueue = [];
	}

	public function processRemoveEntityQueue() {
		for (entityId in removeMainEntityQueue) {
			final entity = mainEntityManager.getEntityById(entityId);
			if (entity != null) {
				if (deleteMainEntityCallback != null) {
					deleteMainEntityCallback(entity);
				}
				playerToEntityMap.remove(entity.getOwnerId());
				mainEntityManager.remove(entity.getId());
			}
		}
		removeMainEntityQueue = [];
	}

	// -----------------------------------
	// Input
	// -----------------------------------

	public function checkLocalMovementInputAllowance(entityId:String, playerInputType:PlayerInputType) {
		final entity = mainEntityManager.getEntityById(entityId);
		if (entity == null) {
			return false;
		} else {
			return entity.checkLocalMovementInput() && entity.canPerformMove(playerInputType);
		}
	}

	public function checkLocalActionInputAllowance(entityId:String, playerInputType:PlayerInputType) {
		final entity = mainEntityManager.getEntityById(entityId);
		if (entity == null) {
			return false;
		} else {
			return entity.checkLocalActionInputAndPrepare(playerInputType) && entity.canPerformAction(playerInputType);
		}
	}

	public function addInputCommandServer(struct:Dynamic) {
		final entityId = getMainEntityIdByOwnerId(struct.playerId);
		var allow = false;

		if (struct.inputType < 9) {
			allow = checkLocalMovementInputAllowance(entityId, struct.inputType);
		} else {
			allow = checkLocalActionInputAllowance(entityId, struct.inputType);
		}

		if (allow) {
			addInputCommandClient(new PlayerInputCommand(struct.inputType, struct.movAngle, struct.playerId));
		}
	}

	public function addInputCommandClient(playerInputCommand:PlayerInputCommand) {
		if (playerInputCommand.inputType != null && playerInputCommand.playerId != null) {
			final wrappedCommand = new InputCommandEngineWrapped(playerInputCommand, tick);
			hotInputCommands.push(wrappedCommand);
			coldInputCommands.push(wrappedCommand);
		}
	}

	// -----------------------------------
	// General
	// -----------------------------------

	public function destroy() {
		gameLoop.stopLoop();

		mainEntityManager.destroy();

		postLoopCallback = null;
		createMainEntityCallback = null;
		deleteMainEntityCallback = null;

		customDestroy();
	}
}
