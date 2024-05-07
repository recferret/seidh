package engine.base.core;

import engine.base.entity.base.EngineBaseEntity;
import engine.base.entity.base.EngineBaseEntityManager;
import engine.base.BaseTypesAndClasses;
import engine.base.core.GameLoop;
import engine.base.entity.impl.EngineCharacterEntity;
import engine.base.entity.impl.EngineProjectileEntity;

enum EngineMode {
	Client;
	Server;
}

typedef CreateCharacterEntityTask = {
	var fireCallback:Bool;
	var entity:EngineCharacterEntity;
}

typedef CreateProjectileEntityTask = {
	var fireCallback:Bool;
	var entity:EngineProjectileEntity;
}

@:expose
abstract class BaseEngine {
	final gameLoop:GameLoop;

	public var tick:Int;

	public var recentEngineLoopTime:Float;
	public final okLoopTime:Int;
	public final engineMode:EngineMode;

	public var postLoopCallback:Void->Void;
	public var createCharacterCallback:EngineCharacterEntity->Void;
	public var deleteCharacterCallback:EngineCharacterEntity->Void;
	public var createProjectileCallback:EngineProjectileEntity->Void;
	public var deleteProjectileCallback:EngineProjectileEntity->Void;

	public final characterEntityManager = new EngineBaseEntityManager();
	public final projectileEntityManager = new EngineBaseEntityManager();

	public final playerToEntityMap = new Map<String, String>();

	public var validatedInputCommands = new Array<PlayerInputCommand>();

	private var createCharacterEntityQueue = new Array<CreateCharacterEntityTask>();
	private var removeCharacterEntityQueue = new Array<String>();

	private var createProjectileEntityQueue = new Array<CreateProjectileEntityTask>();
	private var removeProjectileEntityQueue = new Array<String>();

	// Команды от пользователей, которые будут применены в начале каждого тика
	private var hotInputCommands = new Array<InputCommandEngineWrapped>();

	// История команд за последние N тиков
	public var ticksSinceLastPop = 0;
	public final coldInputCommandsTreshhold = 10;
	public final coldInputCommands = new Array<InputCommandEngineWrapped>();

	public function new(engineMode:EngineMode) {
		this.engineMode = engineMode;
		
		gameLoop = new GameLoop(function loop(dt:Float, tick:Int) {
			this.tick = tick;

			// Remove outdated inputs from cache
			if (ticksSinceLastPop == coldInputCommandsTreshhold) {
				ticksSinceLastPop = 0;
				coldInputCommands.shift();
			}
			ticksSinceLastPop++;

			processCreateCharacterQueue();
			processRemoveCharacterQueue();

			processCreateProjectileQueue();
			processRemoveProjectileQueue();

			// Update all entities
			engineLoopUpdate(dt);

			// Apply inputs
			if (hotInputCommands.length > 0) {
				processInputCommands(hotInputCommands);
				hotInputCommands = [];
			}

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
	// Character entity management
	// -----------------------------------

	function createCharacterEntity(entity:EngineCharacterEntity, fireCallback = false) {
		createCharacterEntityQueue.push({
			entity: entity,
			fireCallback: fireCallback
		});
	}

	public function removeCharacterEntity(entityId:String) {
		removeCharacterEntityQueue.push(entityId);
	}

	public function getCharacterEntityById(id:String) {
		return characterEntityManager.getEntityById(id);
	}

	public function getMainEntityIdByOwnerId(id:String) {
		return playerToEntityMap.get(id);
	}

	public function getMainEntityByOwnerId(id:String) {
		return characterEntityManager.getEntityById(playerToEntityMap.get(id));
	}

	public function updateCharacterEntitiesByServer(minEntities:Array<CharacterEntityMinStruct>) {
		for (minEntity in minEntities) {
			final entity = characterEntityManager.entities.get(minEntity.id);
			if (entity != null) {
				entity.setX(minEntity.x);
				entity.setY(minEntity.y);
				cast (entity, EngineCharacterEntity).currentDirectionSide = minEntity.side;
			}
		}
	}

	public function setCharacterNextActionToPerform(entityId:String, characterActionType:CharacterActionType) {
		final entity = characterEntityManager.getEntityById(entityId);
		if (entity != null) {
			cast (entity, EngineCharacterEntity).setNextActionToPerform(characterActionType);
		}
	}

	public function getCharacterEntities() {
		return characterEntityManager.entities;
	}

	public function getCharacterEntitiesChanged() {
		final result = new Array<EngineBaseEntity>();
		for (entity in characterEntityManager.entities) {
			if (entity.isChanged()) 
				result.push(entity);
		}
		return result;
	}

	function processCreateCharacterQueue() {
		for (queueTask in createCharacterEntityQueue) {
			characterEntityManager.add(queueTask.entity);
			playerToEntityMap.set(queueTask.entity.getOwnerId(), queueTask.entity.getId());
			if (queueTask.fireCallback && createCharacterCallback != null) {
				createCharacterCallback(queueTask.entity);
			}
		}
		createCharacterEntityQueue = [];
	}

	function processRemoveCharacterQueue() {
		for (entityId in removeCharacterEntityQueue) {
			final entity = cast (characterEntityManager.getEntityById(entityId), EngineCharacterEntity);
			if (entity != null) {
				if (deleteCharacterCallback != null) {
					deleteCharacterCallback(cast (entity, EngineCharacterEntity));
				}
				playerToEntityMap.remove(entity.getOwnerId());
				characterEntityManager.remove(entity.getId());
			}
		}
		removeCharacterEntityQueue = [];
	}

	// -----------------------------------
	// Projectiles
	// -----------------------------------

	function createProjectileEntity(entity:EngineProjectileEntity, fireCallback = false) {
		createProjectileEntityQueue.push({
			entity: entity,
			fireCallback: fireCallback
		});
	}

	function removeProjectileEntity(entityId:String) {
		removeProjectileEntityQueue.push(entityId);
	}

	function processCreateProjectileQueue() {
		for (queueTask in createProjectileEntityQueue) {
			projectileEntityManager.add(queueTask.entity);
			if (queueTask.fireCallback && createProjectileCallback != null) {
				createProjectileCallback(queueTask.entity);
			}
		}
		createProjectileEntityQueue = [];
	}

	function processRemoveProjectileQueue() {
		for (entityId in removeProjectileEntityQueue) {
			final entity = cast (projectileEntityManager.getEntityById(entityId), EngineProjectileEntity);
			if (entity != null) {
				if (deleteProjectileCallback != null) {
					deleteProjectileCallback(entity);
				}
				projectileEntityManager.remove(entity.getId());
			}
		}
		removeProjectileEntityQueue = [];
	}

	// -----------------------------------
	// Input
	// -----------------------------------

	public function checkLocalMovementInputAllowance(entityId:String) {
		final entity = cast (characterEntityManager.getEntityById(entityId), EngineCharacterEntity);
		if (entity == null) {
			return false;
		} else {
			return entity.checkLocalMovementInput() && entity.canPerformMove();
		}
	}

	public function checkLocalActionInputAllowance(entityId:String, characterActionType:CharacterActionType) {
		final entity = cast (characterEntityManager.getEntityById(entityId), EngineCharacterEntity);
		if (entity == null) {
			return false;
		} else {
			return entity.checkLocalActionInput(characterActionType) && entity.canPerformAction(characterActionType);
		}
	}

	public function addInputCommandServer(struct:Dynamic) {
		final entityId = getMainEntityIdByOwnerId(struct.playerId);
		var allow = false;

		if (struct.actionType == CharacterActionType.MOVE) {
			allow = checkLocalMovementInputAllowance(entityId);
		} else {
			allow = checkLocalActionInputAllowance(entityId, struct.actionType);
		}

		if (allow) {
			addInputCommandClient(new PlayerInputCommand(struct.actionType, struct.movAngle, struct.playerId));
		}
	}

	public function addInputCommandClient(playerInputCommand:PlayerInputCommand) {
		if (playerInputCommand.actionType != null && playerInputCommand.playerId != null) {
			final wrappedCommand = new InputCommandEngineWrapped(playerInputCommand, tick);
			hotInputCommands.push(wrappedCommand);
			coldInputCommands.push(wrappedCommand);
		}
	}

	// -----------------------------------
	// General
	// -----------------------------------

	public function destroy() {
		postLoopCallback = null;
		createCharacterCallback = null;
		deleteCharacterCallback = null;
		createProjectileCallback = null;
		deleteProjectileCallback = null;

		gameLoop.stopLoop();

		characterEntityManager.destroy();
		projectileEntityManager.destroy();

		customDestroy();
	}
}
