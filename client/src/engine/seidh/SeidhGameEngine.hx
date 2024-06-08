package engine.seidh;

import js.lib.Date;

import engine.base.BaseTypesAndClasses;
import engine.base.EngineConfig;
import engine.base.MathUtils;
import engine.base.entity.base.EngineBaseEntity;
import engine.base.entity.impl.EngineProjectileEntity;
import engine.base.entity.impl.EngineCharacterEntity;
import engine.base.core.BaseEngine;
import engine.seidh.entity.base.SeidhBaseEntity;
import engine.seidh.entity.factory.SeidhEntityFactory;

enum abstract GameState(Int) {
	var PLAYING = 1;
	var WIN = 2;
}

@:expose
class SeidhGameEngine extends BaseEngine {

    private var gameState = GameState.PLAYING;
    private var framesPassed = 0;
    private var timePassed = 0.0;
    
    private var allowSpawnMobs = false;
    private var mobsSpawned = 0;
    private var mobsKilled = 0;
    private var mobsLastSpawnTime = 0.0;
    private final mobsMax = 10;

    // TODO change this value if backend
    private final mobSpawnDelayMs = 0.500;
    
    public var characterActionCallbacks:Array<CharacterActionCallbackParams>->Void;
    public var gameStateCallback:GameState->Void;

    public static function main() {}

    public function new(engineMode = EngineMode.Server) {
	    super(engineMode);
    }

    public function setGameState(gameState:GameState) {
        this.gameState = gameState;
        if (gameStateCallback != null) {
            gameStateCallback(gameState);
        }
    }

    public function createCharacterEntityFromMinimalStruct(struct:CharacterEntityMinStruct) {
        createCharacterEntity(SeidhEntityFactory.InitiateEntity(struct.id, struct.ownerId, struct.x, struct.y, struct.entityType));
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
			final inputInitiator = input.playerId;
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

            for (e1 in characterEntityManager.entities) {
                final character1 = cast(e1, EngineCharacterEntity);
                
                // Ai movement and updates
                if (character1.isAlive && !character1.isPlayer()) {
                    if (EngineConfig.AI_ENABLED) {
                        final targetPlayer = getNearestPlayer(character1);
                        if (targetPlayer != null && character1.getTargetObject() != targetPlayer) {
                            character1.setTargetObject(targetPlayer, true);
                        }
                    }

                    for (e2 in characterEntityManager.entities) {
                        final character2 = cast(e2, EngineCharacterEntity);
                        if (!character1.intersectsWithCharacter && character1.getId() != character2.getId() && character2.isAlive && !character2.isPlayer()) {
                            if (character2.getBodyRectangle().intersectsWithLine(character1.botForwardLookingLine)) {
                                character1.intersectsWithCharacter = true;
                                character1.canMove = false;
                            }
                        }
                    }

                    character1.update(dt);

                    character1.intersectsWithCharacter = false;
                    character1.canMove = true;
                }
            }

            for (e in characterEntityManager.entities) {
                final character1 = cast(e, EngineCharacterEntity);
                if (character1.isAlive) {
                    if (character1.isPlayer()) {
                        character1.update(dt);
                    }
                    
                    // Check projectile collisions against characters
                    for (e in projectileEntityManager.entities) {
                        final projectile = cast(e, EngineProjectileEntity);

                        // Skip self collision
                        if (projectile.getOwnerId() != character1.getOwnerId()) {
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
                            if (character2.isAlive && character1.getId() != character2.getId()) {
                                if (character1.getCurrentActionRect() != null && character1.getCurrentActionRect().containsRect(character2.getBodyRectangle())) {
                                    final health = character2.subtractHealth(character1.actionToPerform.damage);
                                    if (health == 0) {
                                        if (character2.getEntityType() == ZOMBIE_BOY || character2.getEntityType() == ZOMBIE_GIRL) {
                                            mobsKilled++;
                                        }
                                        character2.isAlive = false;
                                        deadEntities.push(character2.getId());
                                        deleteCharacterEntity(character2.getId());
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

                        character1.isActing = false;
                        character1.actionToPerform = null;
                    }

                    character1.isRunning = false;
                    character1.isWalking = false;
                }
            }

            if (characterActionCallbacks != null && characterActionCallbackParams.length > 0) {
                characterActionCallbacks(characterActionCallbackParams);
            }

            if (mobsKilled == mobsMax) {
                gameState = GameState.WIN;
                if (gameStateCallback != null) {
                    gameStateCallback(gameState);
                }
            }

            // TODO add callback if all players are dead

            recentEngineLoopTime = Date.now() - beginTime;
            spawnMobs();
        }
    }

    public function customDestroy() {
        // clear callbacks
        characterActionCallbacks = null;
    }

    // ---------------------------------------------------
    // Custom logic
    // ---------------------------------------------------

    public function allowMobsSpawn(allowSpawnMobs:Bool) {
        this.allowSpawnMobs = allowSpawnMobs;
    }

    public function spawnMobs() {
        final now = haxe.Timer.stamp();

        if (allowSpawnMobs && mobsSpawned < mobsMax && (mobsLastSpawnTime == 0 || mobsLastSpawnTime + mobSpawnDelayMs < now)) {
            mobsSpawned++;
            mobsLastSpawnTime = now;

            // if (lastLocalMovementInputCheck == 0 || lastLocalMovementInputCheck + characterEntity.movement.movementDelay < now) {
            //     lastLocalMovementInputCheck = now;
            //     return true;
            // } else {
            //     return false;
            // }

            // final positionX = MathUtils.randomIntInRange(0, 5000);
            // final positionY = MathUtils.randomIntInRange(0, 5000);

            final positionX = 1000;
            final positionY = 1000;

            createCharacterEntity(SeidhEntityFactory.InitiateEntity(null, null, positionX, positionY, MathUtils.randomIntInRange(1, 2) == 1 ? EntityType.ZOMBIE_BOY : EntityType.ZOMBIE_GIRL));
            // Timer.delay(function callback() {
            //     spawnMobs();
            // }, mobSpawnDelayMs);
        }
    }

    public function cleanAllMobs() {
        mobsSpawned = 0;
        for (entity in characterEntityManager.getEntitiesByEntityType(EntityType.ZOMBIE_BOY)) {
            characterEntityManager.delete(entity.getId());
        };
        for (entity in characterEntityManager.getEntitiesByEntityType(EntityType.ZOMBIE_GIRL)) {
            characterEntityManager.delete(entity.getId());
        };
    }

    public function getPlayersCount() {
        return 
            characterEntityManager.getEntitiesByEntityType(EntityType.RAGNAR_LOH).length +
            characterEntityManager.getEntitiesByEntityType(EntityType.RAGNAR_NORM).length;
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
            if (targetEntity.getEntityType() == EntityType.RAGNAR_LOH || targetEntity.getEntityType() == EntityType.RAGNAR_NORM) {
                final dist = entity.getBodyRectangle().getCenter().distance(targetEntity.getBodyRectangle().getCenter());
                if (nearestPlayer == null || dist < nearestPlayerDistance) {
                    nearestPlayer = targetEntity;
                    nearestPlayerDistance = dist;
                }
            }
        }

        return nearestPlayer;
    }

}