package engine.seidh;

import engine.base.geometry.Point;
import js.lib.Date;

import engine.base.BaseTypesAndClasses;
import engine.base.EngineConfig;
import engine.base.MathUtils;
import engine.base.entity.base.EngineBaseEntity;
import engine.base.entity.impl.EngineConsumableEntity;
import engine.base.entity.impl.EngineCharacterEntity;
import engine.base.entity.impl.EngineProjectileEntity;
import engine.base.core.BaseEngine;
import engine.seidh.entity.base.SeidhBaseEntity;
import engine.seidh.entity.factory.SeidhEntityFactory;

@:expose
class SeidhGameEngine extends BaseEngine {

    // TODO move to config
    public static var ZOMBIE_DAMAGE = 5;

    private var lastDt = 0.0;
    private var framesPassed = 0;
    private var timePassed = 0.0;

    private var winCondition:WinCondition;

    private final aiManager:AiManager;

    private final playerZombieKills = new Map<String, Int>();
    private final playerTokensAccquired = new Map<String, Int>();
    private final playerExpGained = new Map<String, Int>();
    private final lineColliders = new Array<engine.base.geometry.Line>();

    public var characterActionCallbacks:Array<CharacterActionCallbackParams>->Void;
    public var gameStateCallback:GameState->Void;
    public var oneSecondCallback:Void->Void;

    public final playersSpawnPoints = [
        new Point(2500, 2500)
    ];

    public static final GameWorldSize = 5000;

    public static function main() {}

    public function new(engineMode:EngineMode, winCondition:WinCondition = WinCondition.INFINITE) {
	    super(engineMode);

        aiManager = new AiManager();

        this.winCondition = winCondition;

		addLineCollider(0, 0, GameWorldSize, 0);
		addLineCollider(0, GameWorldSize, GameWorldSize, GameWorldSize);
		addLineCollider(0, 0, 0, GameWorldSize);
		addLineCollider(GameWorldSize, 0, GameWorldSize, GameWorldSize);

        oneSecondTimer();
    }

    // ---------------------------------------------------
    // Create entity helpers
    // ---------------------------------------------------

    public function createCharacterEntityFromMinimalStruct(struct:CharacterEntityMinStruct) {
        createCharacterEntity(SeidhEntityFactory.InitiateCharacter(struct.id, struct.ownerId, struct.x, struct.y, struct.entityType));
    }

    public function createCharacterEntityFromFullStruct(struct:CharacterEntityFullStruct) {
        createCharacterEntity(SeidhEntityFactory.InitiateCharacterFromFullStruct(struct));
    }

    // ---------------------------------------------------
    // Abstract implementation
    // ---------------------------------------------------

    public function processInputCommands(playerInputCommands:Array<InputCommandEngineWrapped>) {
        for (i in playerInputCommands) {
			final input = cast(i.playerInputCommand, PlayerInputCommand);
			final inputInitiator = input.userId;
			final entityId = playerToEntityMap.get(inputInitiator);
			final entity = cast(characterEntityManager.getEntityById(entityId), SeidhBaseEntity);

			if (entity == null || entity.getOwnerId() != inputInitiator) {
				continue;
			}
        
            // Server request queue
			validatedInputCommands.push(input);

            if (input.actionType == CharacterActionType.MOVE) {
                entity.performMove(input);
            } else {
                entity.setNextActionToPerform(input.actionType);
            }
		}
    }

    public function engineLoopUpdate(dt:Float) {
        lastDt = dt;

        if (gameState == GameState.PLAYING) {
            final beginTime = Date.now();

            framesPassed++;
            timePassed += dt;

            final characterActionCallbackParams = new Array<CharacterActionCallbackParams>();

            for (e in projectileEntityManager.entities) {
                final projectile = cast(e, EngineProjectileEntity);

                if (projectile.allowMovement) {
                    projectile.update(dt);
                } else {
                    deleteProjectileEntity(projectile.getId());
                }
            }

            // AI
            final allowServerLogic = engineMode == EngineMode.SERVER || engineMode == EngineMode.CLIENT_SINGLEPLAYER;

            if (allowServerLogic && EngineConfig.AI_ENABLED) {
                for (e1 in characterEntityManager.entities) {
                    final character1 = cast(e1, EngineCharacterEntity);
                    
                    if (character1.isAlive && !character1.isPlayer()) {
                        // Find and set nearest player as a target
                        final targetPlayer = getNearestPlayer(character1);
                        if (targetPlayer != null && character1.getTargetObject() != targetPlayer) {
                            character1.setTargetObject(targetPlayer, true);
                        } else {
                            character1.clearTargetObject();
                        }

                        // Restrict movement through objects
                        for (e2 in characterEntityManager.entities) {
                            final character2 = cast(e2, EngineCharacterEntity);
                            if (!character1.intersectsWithCharacter && character1.getId() != character2.getId() && character2.isAlive && !character2.isPlayer()) {
                                if (character2.getBodyRectangle().intersectsWithLine(character1.botForwardLookingLine)) {
                                    character1.intersectsWithCharacter = true;
                                    character1.canMove = false;
                                }
                            }
                        }

                        character1.intersectsWithCharacter = false;
                        character1.canMove = true;
                    }
                }
            }

            for (e in characterEntityManager.entities) {
                final character1 = cast(e, EngineCharacterEntity);
                final character1Id = character1.getId();
                final character1OwnerId = character1.getOwnerId();

                if (character1.isAlive) {
                    character1.update(dt);

                    if (character1.isPlayer()) {
                        for (c in consumableEntityManager.entities) {
                            final consumable = cast(c, EngineConsumableEntity);

                            // Pick up items
                            if (character1.getBodyRectangle().getCenter().distance(consumable.getBodyRectangle().getCenter()) < 150) {
                                if (character1.getBodyRectangle().containsRect(consumable.getBodyRectangle())) {
                                    if (consumable.getEntityType() == EntityType.COIN) {
                                        // Increase tokens accquired
                                        final currentBalance = playerTokensAccquired.get(character1OwnerId);
                                        if (currentBalance != null) {
                                            playerTokensAccquired.set(character1OwnerId, currentBalance + 1);
                                        } else {
                                            playerTokensAccquired.set(character1OwnerId, 1);
                                        }
                                    } else {
                                        // Give health
                                        character1.addHealth(consumable.amount);
                                    }

                                    deleteConsumableEntity(consumable.getId(), character1Id);
                                }
                            }
                        }

                        // Restrict border movement
                        var intersectsWithLine = false;
                        for (line in lineColliders) {
                            if (character1.getForwardLookingLine(character1.playerForwardLookingLineLength).intersectsWithLine(line)) {
                                intersectsWithLine = true;
                                break;
                            }
                        }

                        if (intersectsWithLine) {
                            character1.canMove = false;
                        } else {
                            character1.canMove = true;
                        }
                    }

                    // Check projectile collisions against characters
                    for (e in projectileEntityManager.entities) {
                        final projectile = cast(e, EngineProjectileEntity);

                        // Skip self collision
                        if (projectile.getOwnerId() != character1OwnerId) {
                            final projectileRect = projectile.getBodyRectangle();
                            final characterRect = character1.getBodyRectangle();

                            // Skip far collisions
                            if (projectileRect.getCenter().distance(characterRect.getCenter()) < characterRect.w) {
                                // TODO hit by projectile
                                // TODO rename allowMovement
                                projectile.allowMovement = false;
                            }
                        }
                    }

                    // Perform character action
                    if (character1.isActing) {
                        final hurtEntities = new Array<String>();
                        final deadEntities = new Array<String>();

                        var actionShape:ShapeStruct = null;
                        if (character1.actionToPerform.projectileStruct != null) {
                            createProjectileEntity(createProjectileByCharacter(character1));
                            actionShape = character1.actionToPerform.projectileStruct.shape;
                        } else if (character1.actionToPerform.meleeStruct != null) {
                            actionShape = character1.actionToPerform.meleeStruct.shape;
                        }

                        for (e2 in characterEntityManager.entities) {
                            final character2 = cast(e2, EngineCharacterEntity);
                            // TODO add distance check here
                            if (character2.isAlive && character1Id != character2.getId()) {
                                final characterHasActionRect = character1.getCurrentActionRect() != null;
                                final chatacterHitsAnother = character1.getCurrentActionRect().containsRect(character2.getBodyRectangle()); 
                                final skipBotToBotAttack = character1.isBot() && character2.isBot();
                                if (characterHasActionRect && chatacterHitsAnother && !skipBotToBotAttack) {
                                    if (allowServerLogic) {
                                        final health = character2.subtractHealth(character1.actionToPerform.damage);
                                        if (health == 0) {
                                            // Zombie killed
                                            if (character2.isBot()) {
                                                aiManager.mobKilled();

                                                // Update player kills
                                                final currentKills = playerZombieKills.get(character1OwnerId);
                                                if (currentKills != null) {
                                                    playerZombieKills.set(character1OwnerId, currentKills + 1);
                                                } else {
                                                    playerZombieKills.set(character1OwnerId, 1);
                                                }

                                                // Update current player character exp
                                                final currentExp = playerExpGained.get(character1OwnerId);
                                                if (currentExp != null) {
                                                    playerExpGained.set(character1OwnerId, currentExp + 1);
                                                } else {
                                                    playerExpGained.set(character1OwnerId, 1);
                                                }

                                                // Create a new random consumable
                                                createConsumable(character2);
                                            }
                                            character2.isAlive = false;
                                            deadEntities.push(character2.getId());
                                            deleteCharacterEntity(character2.getId());
                                        } else {
                                            hurtEntities.push(character2.getId());
                                        }
                                    } else {
                                        hurtEntities.push(character2.getId());
                                    }
                                }
                            }
                        }

                        characterActionCallbackParams.push({
                            entityId: character1.getId(),
                            actionType: character1.actionToPerform.actionType,
                            shape: actionShape,
                            hurtEntities: hurtEntities,
                            deadEntities: deadEntities,
                        });
                    }

                    character1.isActing = false;
                    character1.actionToPerform = null;
                    character1.isRunning = false;
                    character1.isWalking = false;
                }
            }

            if (characterActionCallbacks != null && characterActionCallbackParams.length > 0) {
                characterActionCallbacks(characterActionCallbackParams);
            }

            if (winCondition != WinCondition.INFINITE) {
                if (winCondition == WinCondition.KILL_MOBS && aiManager.allMobsKilled() && allowServerLogic) {
                    gameState = GameState.WIN;
                    if (gameStateCallback != null) {
                        gameStateCallback(gameState);
                    }
                }
            }

            recentEngineLoopTime = Date.now() - beginTime;

            spawnMobs();
        } else if (gameState == GameState.LOSE) {
            lose();
        }
    }

    public function customDestroy() {
        // clear callbacks
        characterActionCallbacks = null;
    }

    // ---------------------------------------------------
    // Custom logic
    // ---------------------------------------------------

	public function addLineCollider(x1:Int, y1:Int, x2:Int, y2:Int) {
		lineColliders.push(new engine.base.geometry.Line(x1, y1, x2, y2));
	}

    public function allowMobsSpawn(allowSpawnMobs:Bool) {
        aiManager.allowMobsSpawn(allowSpawnMobs);
    }

    public function spawnMobs() {
        final player = characterEntityManager.getEntityById("entity_" + localPlayerId);
        if (player != null) {
            final spawnMob = aiManager.spawnMob(player.getX(), player.getY());
            if (spawnMob.spawn) {
                createCharacterEntity(SeidhEntityFactory.InitiateCharacter(
                    null,
                    null, 
                    spawnMob.positionX, 
                    spawnMob.positionY,
                    spawnMob.entityType
                ));
            }
        }
    }

    public function cleanAllMobs() {
        for (entity in characterEntityManager.getEntitiesByEntityType(EntityType.ZOMBIE_BOY)) {
            characterEntityManager.delete(entity.getId());
        };
        for (entity in characterEntityManager.getEntitiesByEntityType(EntityType.ZOMBIE_GIRL)) {
            characterEntityManager.delete(entity.getId());
        };
        aiManager.cleanAllMobs();
    }

    public function clearPlayerGainings(playerId:String) {
        playerZombieKills.remove(playerId);
        playerTokensAccquired.remove(playerId);
        playerExpGained.remove(playerId);
    }

    public function lose() {
        if (gameState == GameState.LOSE) {
            if (gameStateCallback != null) {
                gameStateCallback(gameState);
            }
            gameState = GameState.ENDED;
        }
    }

    private function createProjectileByCharacter(character:EngineCharacterEntity) {
        // final ownerRect = character.getBodyRectangle();
        // final projectileEntity = new EngineProjectileEntity(new ProjectileEntity({
        //     base: {
        //         x: Std.int(ownerRect.getCenter().x),
        //         y: Std.int(ownerRect.getCenter().y),
        //         entityType: EntityType.PROJECTILE_MAGIC_ARROW,
        //         entityShape: character.actionToPerform.projectileStruct.shape,
        //         ownerId: character.getOwnerId(),
        //         rotation: character.getRotation(),
        //     },
	    //     projectile: character.actionToPerform.projectileStruct
        // }));
        // return projectileEntity;
        return null;
    }

    private function getNearestPlayer(entity:EngineBaseEntity) {
        var nearestPlayer:EngineBaseEntity = null;
        var nearestPlayerDistance:Float = 0.0;

        for (targetEntity in characterEntityManager.entities) {
            if (targetEntity.isPlayer()) {
                final dist = entity.getBodyRectangle().getCenter().distance(targetEntity.getBodyRectangle().getCenter());
                if (nearestPlayer == null || dist < nearestPlayerDistance) {
                    nearestPlayer = targetEntity;
                    nearestPlayerDistance = dist;
                }
            }
        }

        return nearestPlayer;
    }

    private function createConsumable(character:EngineCharacterEntity) {
        final x = Std.int(character.getBodyRectangle().x);
        final y = Std.int(character.getBodyRectangle().y);

        final rnd = MathUtils.randomIntInRange(1, 40);
        if (rnd == 1) {
            createConsumableEntity(SeidhEntityFactory.InitiateCoin(x, y, 25));
        } else if (rnd < 6) {
            createConsumableEntity(SeidhEntityFactory.InitiateHealthPotion(x, y, 10));
        } else {
            createConsumableEntity(SeidhEntityFactory.InitiateCoin(x, y, 1));
        }
    }

    private function oneSecondTimer() {
        haxe.Timer.delay(function delay() {
            if (gameState == GameState.PLAYING) {
                if (oneSecondCallback != null) {
                    oneSecondCallback();
                }
                aiManager.secondPassed();
                oneSecondTimer();
            }
        }, 1000);
    }

    // ---------------------------------------------------
    // Getters
    // ---------------------------------------------------

    public function getLastDt() {
        return lastDt;
    }

    public function getGameState() {
        return gameState;
    }

    public function getLineColliders() {
        return lineColliders;
    }

    public function getPlayersSpawnPoints() {
        return playersSpawnPoints;
    }

    public function getMobsSpawnPoints() {
        return aiManager.getMobsSpawnPoints();
    }

    public function getMobsMax() {
        return aiManager.getMobsMax();
    }

    public function getPlayersCount() {
        return 
            characterEntityManager.getEntitiesByEntityType(EntityType.RAGNAR_LOH).length +
            characterEntityManager.getEntitiesByEntityType(EntityType.RAGNAR_NORM).length;
    }

    public function getPlayerGainings(playerId:String) {
        return {
            kills: playerZombieKills.exists(playerId) ? playerZombieKills.get(playerId) : 0,
            tokens: playerTokensAccquired.exists(playerId) ? playerTokensAccquired.get(playerId) : 0,
            exp: playerExpGained.exists(playerId) ? playerExpGained.get(playerId) : 0,
        };
    }

    public function getMobsCount() {
        return 
            characterEntityManager.getEntitiesByEntityType(EntityType.ZOMBIE_BOY).length +
            characterEntityManager.getEntitiesByEntityType(EntityType.ZOMBIE_GIRL).length;
    }

    public function getWinCondition() {
        return winCondition;
    }

    // ---------------------------------------------------
    // Setters
    // ---------------------------------------------------

    public function setZombieDamage(damage:Int) {
        SeidhGameEngine.ZOMBIE_DAMAGE = damage;
    }

    public function setGameState(gameState:GameState) {
        this.gameState = gameState;
        if (gameStateCallback != null) {
            gameStateCallback(gameState);
        }
    }

    public function setMobsMax(mobsMax:Int) {
        aiManager.setMobsMax(mobsMax);
    }

    public function setWinCondition(winCondition:WinCondition) {
        this.winCondition = winCondition;
    }
}