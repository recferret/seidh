package engine.base.core;

import engine.base.BaseTypesAndClasses;
import engine.base.core.GameLoop;
import engine.base.entity.base.EngineBaseEntityManager;
import engine.base.entity.impl.EngineCharacterEntity;
import engine.base.entity.impl.EngineConsumableEntity;
import engine.base.entity.impl.EngineProjectileEntity;

typedef CreateCharacterEntityTask = {
	var entity:EngineCharacterEntity;
}

typedef CreateConsumableEntityTask = {
	var entity:EngineConsumableEntity;
}

typedef DeleteConsumableEntityTask = {
	var entityId:String;
	var takenByCharacterId:String;
}

typedef CreateProjectileEntityTask = {
	var entity:EngineProjectileEntity;
}

enum abstract GameState(Int) {
	var PLAYING = 1;
	var WIN = 2;
    var LOSE = 3;
	var ENDED = 4;
}

@:expose
abstract class BaseEngine {
	final gameLoop:GameLoop;

    public var gameState = GameState.PLAYING;

	public var tick:Int;

	public var recentEngineLoopTime:Float;
	public final okLoopTime:Int;
	public final engineMode:EngineMode;

	// Callbacks
	public var postLoopCallback:Void->Void;
	public var createCharacterCallback:EngineCharacterEntity->Void;
	public var deleteCharacterCallback:EngineCharacterEntity->Void;
	public var createConsumableCallback:EngineConsumableEntity->Void;
	public var deleteConsumableCallback:DeleteConsumableEntityTask->Void;
	public var createProjectileCallback:EngineProjectileEntity->Void;
	public var deleteProjectileCallback:EngineProjectileEntity->Void;

	public final characterEntityManager = new EngineBaseEntityManager();
	public final projectileEntityManager = new EngineBaseEntityManager();
	public final consumableEntityManager = new EngineBaseEntityManager();

	public final playerToEntityMap = new Map<String, String>();

	public var validatedInputCommands = new Array<PlayerInputCommand>();

	// Both chars, projectiles and coins has lots of common, need some better abstraction
	private var createCharacterEntityQueue = new Array<CreateCharacterEntityTask>();
	private var deleteCharacterEntityQueue = new Array<String>();

	private var createConsumableEntityQueue = new Array<CreateConsumableEntityTask>();
	private var deleteConsumableEntityQueue = new Array<DeleteConsumableEntityTask>();

	private var createProjectileEntityQueue = new Array<CreateProjectileEntityTask>();
	private var deleteProjectileEntityQueue = new Array<String>();

	var localPlayerId:String;

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
			processDeleteCharacterQueue();

			processCreateConsumableQueue();
			processDeleteConsumableQueue();

			processCreateProjectileQueue();
			processDeleteProjectileQueue();

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

	function createCharacterEntity(entity:EngineCharacterEntity) {
		createCharacterEntityQueue.push({
			entity: entity
		});
	}

	public function deleteCharacterEntityByOwnerId(ownerId:String) {
		deleteCharacterEntityQueue.push(getCharacterEntityIdByOwnerId(ownerId));
	}

	public function deleteCharacterEntity(entityId:String) {
		deleteCharacterEntityQueue.push(entityId);
	}

	public function getCharacterEntityById(id:String) {
		return characterEntityManager.getEntityById(id);
	}

	public function getCharacterEntityIdByOwnerId(id:String) {
		return playerToEntityMap.get(id);
	}

	public function getCharacterEntityByOwnerId(id:String) {
		return characterEntityManager.getEntityById(playerToEntityMap.get(id));
	}

	public function updateCharacterEntitiesByServer(minEntities:Array<CharacterEntityMinStruct>) {
		for (minEntity in minEntities) {
			final entity = cast(characterEntityManager.entities.get(minEntity.id), EngineCharacterEntity);
			if (entity != null) {
				entity.setHealth(minEntity.health);

				// Skip local player position update if it is close to the server
				if (entity.getOwnerId() == localPlayerId) {
					final xDiff = Math.abs(entity.getX() - minEntity.x);
					final yDiff = Math.abs(entity.getY() - minEntity.y);
					if (xDiff + yDiff <= (entity.getMovementSpeed() * 3)) {
						continue;
					}
				}
				
				entity.setX(minEntity.x);
				entity.setY(minEntity.y);
				entity.setSide(minEntity.side);
			}
		}
	}

	public function setCharacterNextActionToPerform(entityId:String, characterActionType:CharacterActionType) {
		final entity = characterEntityManager.getEntityById(entityId);
		if (entity != null) {
			cast (entity, EngineCharacterEntity).setNextActionToPerform(characterActionType);
		}
	}

	public function getCharacterEntitiesMap() {
		return characterEntityManager.entities;
	}

	public function getCharactersStruct(params:Dynamic) {
		final result = new Array<Dynamic>();
		for (entity in characterEntityManager.entities) {
			if (params.changed == true && !entity.isChanged()) {
				continue;
			}
			var entityStruct:Dynamic;
			if (params.full == true) {
				entityStruct = cast(entity, EngineCharacterEntity).getEntityFullStruct();
			} else {
				entityStruct = cast(entity, EngineCharacterEntity).getEntityMinStruct();
			}
			result.push(entityStruct);
		}
		return result;
	}

	function processCreateCharacterQueue() {
		for (queueTask in createCharacterEntityQueue) {
			characterEntityManager.add(queueTask.entity);
			if (queueTask.entity.getEntityType() == RAGNAR_LOH || queueTask.entity.getEntityType() == RAGNAR_NORM) {
				playerToEntityMap.set(queueTask.entity.getOwnerId(), queueTask.entity.getId());
			}
			if (createCharacterCallback != null) {
				createCharacterCallback(queueTask.entity);
			}
		}
		createCharacterEntityQueue = [];
	}

	function processDeleteCharacterQueue() {
		for (entityId in deleteCharacterEntityQueue) {
			final entity = cast (characterEntityManager.getEntityById(entityId), EngineCharacterEntity);
			if (entity != null) {
				if (deleteCharacterCallback != null) {
					deleteCharacterCallback(cast (entity, EngineCharacterEntity));
				}
				playerToEntityMap.remove(entity.getOwnerId());
				characterEntityManager.delete(entity.getId());

				// Game lose if player died
				if (localPlayerId != null) {
					if (localPlayerId == entity.getOwnerId()) {
						gameState = GameState.LOSE;
					}
				}
			}
		}
		deleteCharacterEntityQueue = [];
	}

	// -----------------------------------
	// Projectiles
	// -----------------------------------

	function createProjectileEntity(entity:EngineProjectileEntity) {
		createProjectileEntityQueue.push({
			entity: entity
		});
	}

	function deleteProjectileEntity(entityId:String) {
		deleteProjectileEntityQueue.push(entityId);
	}

	function processCreateProjectileQueue() {
		for (queueTask in createProjectileEntityQueue) {
			projectileEntityManager.add(queueTask.entity);
			if (createProjectileCallback != null) {
				createProjectileCallback(queueTask.entity);
			}
		}
		createProjectileEntityQueue = [];
	}

	function processDeleteProjectileQueue() {
		for (entityId in deleteProjectileEntityQueue) {
			final entity = cast (projectileEntityManager.getEntityById(entityId), EngineProjectileEntity);
			if (entity != null) {
				if (deleteProjectileCallback != null) {
					deleteProjectileCallback(entity);
				}
				projectileEntityManager.delete(entity.getId());
			}
		}
		deleteProjectileEntityQueue = [];
	}

	// -----------------------------------
	// Consumables
	// -----------------------------------

	public function createConsumableEntity(entity:EngineConsumableEntity) {
		createConsumableEntityQueue.push({
			entity: entity
		});
	}

	public function deleteConsumableEntity(entityId:String, takenByCharacterId:String) {
		deleteConsumableEntityQueue.push({entityId: entityId, takenByCharacterId: takenByCharacterId});
	}

	function processCreateConsumableQueue() {
		for (queueTask in createConsumableEntityQueue) {
			consumableEntityManager.add(queueTask.entity);
			if (createConsumableCallback != null) {
				createConsumableCallback(queueTask.entity);
			}
		}
		createConsumableEntityQueue = [];
	}

	function processDeleteConsumableQueue() {
		for (task in deleteConsumableEntityQueue) {
			final entity = cast (consumableEntityManager.getEntityById(task.entityId), EngineConsumableEntity);
			if (entity != null) {
				if (deleteConsumableCallback != null) {
					deleteConsumableCallback(task);
				}
				consumableEntityManager.delete(task.entityId);
			}
		}
		deleteConsumableEntityQueue = [];
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

	// TODO Better client input check
	public function addInputCommandServer(input:PlayerInputCommand) {
		// final entityId = getCharacterEntityIdByOwnerId(input.playerId);
		// var allow = false;

		// Roll it back, looks like server cuts some of inputs because of spam check
		// if (input.actionType == CharacterActionType.MOVE) {
		// 	allow = checkLocalMovementInputAllowance(entityId);
		// } else {
		// 	allow = checkLocalActionInputAllowance(entityId, input.actionType);
		// }

		// if (allow) {
		addInputCommandClient(new PlayerInputCommand(input.actionType, input.movAngle, input.userId));
		// }
	}

	public function addInputCommandClient(input:PlayerInputCommand) {
		if (input.actionType != null && input.userId != null) {
			final wrappedCommand = new InputCommandEngineWrapped(input, tick);
			hotInputCommands.push(wrappedCommand);
			coldInputCommands.push(wrappedCommand);
		}
	}

	// -----------------------------------
	// General
	// -----------------------------------

	public function setLocalPlayerId(localPlayerId:String) {
		this.localPlayerId = localPlayerId;
	}

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
