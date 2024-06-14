package engine.seidh;

import engine.base.entity.impl.EngineCoinEntity;
import js.lib.Date;

import engine.base.BaseTypesAndClasses;
import engine.base.EngineConfig;
import engine.base.MathUtils;
import engine.base.entity.base.EngineBaseEntity;
import engine.base.entity.impl.EngineCharacterEntity;
import engine.base.entity.impl.EngineProjectileEntity;
import engine.base.core.BaseEngine;
import engine.seidh.entity.base.SeidhBaseEntity;
import engine.seidh.entity.factory.SeidhEntityFactory;

@:expose
class SeidhGameEngine extends BaseEngine {

    private var framesPassed = 0;
    private var timePassed = 0.0;

    private var allowSpawnMobs = false;
    private var mobsSpawned = 0;
    private var mobsKilled = 0;
    private var mobsLastSpawnTime = 0.0;
    private final mobsMax = 20;
    private final mobSpawnDelayMs = 3.500;
    
    private final playerZombieKills = new Map<String, Int>();

    public var characterActionCallbacks:Array<CharacterActionCallbackParams>->Void;
    public var gameStateCallback:GameState->Void;

    // TODO add coins here

    public static function main() {}

    public function new(engineMode:EngineMode) {
	    super(engineMode);
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

            // AI
            final allowServerLogic = engineMode == EngineMode.SERVER || engineMode == EngineMode.CLIENT_SINGLEPLAYER;

            if (allowServerLogic) {
                for (e1 in characterEntityManager.entities) {
                    final character1 = cast(e1, EngineCharacterEntity);
                    
                    // Ai movement and updates
                    if (character1.isAlive && !character1.isPlayer()) {
                        if (EngineConfig.AI_ENABLED) {
                            final targetPlayer = getNearestPlayer(character1);
                            if (targetPlayer != null && character1.getTargetObject() != targetPlayer) {
                                character1.setTargetObject(targetPlayer, true);
                            } else {
                                character1.clearTargetObject();
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

                        character1.intersectsWithCharacter = false;
                        character1.canMove = true;
                    }
                }
            }

            for (e in characterEntityManager.entities) {
                final character1 = cast(e, EngineCharacterEntity);

                if (character1.isAlive) {
                    character1.update(dt);

                    if (character1.isPlayer()) {
                        for (c in coinEntityManager.entities) {
                            final coin = cast(c, EngineCoinEntity);

                            if (character1.getBodyRectangle().containsRect(coin.getBodyRectangle())) {
                                deleteCoinEntity(coin.getId());
                            }
                        }
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
                            // TODO add distance check here
                            if (character2.isAlive && character1.getId() != character2.getId()) {
                                if (character1.getCurrentActionRect() != null && character1.getCurrentActionRect().containsRect(character2.getBodyRectangle())) {
                                    if (allowServerLogic) {
                                        final health = character2.subtractHealth(character1.actionToPerform.damage);
                                        if (health == 0) {
                                            // Zombie killed
                                            // Update counter, spawn token
                                            if (character2.getEntityType() == ZOMBIE_BOY || character2.getEntityType() == ZOMBIE_GIRL) {
                                                mobsKilled++;
                                                mobsSpawned--;

                                                playerZombieKills.set(character1.getOwnerId(), playerZombieKills.get(character1.getOwnerId()) + 1);

                                                final coinX = Std.int(character2.getBodyRectangle().x);
                                                final coinY = Std.int(character2.getBodyRectangle().y);
                                                
                                                createCoinEntity(SeidhEntityFactory.InitiateCoin(null, coinX, coinY, 1));
                                            }
                                            character2.isAlive = false;
                                            deadEntities.push(character2.getId());
                                            deleteCharacterEntity(character2.getId());

                                            // // Game lose condition if single player
                                            // if (engineMode == EngineMode.CLIENT_SINGLEPLAYER && localPlayerId != null) {
                                            //     if (localPlayerId == character2.getOwnerId()) {
                                            //         gameState = GameState.LOSE;
                                            //     }
                                            // }
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

            // Infinite play
            if (mobsKilled == mobsMax && allowServerLogic) {
                // gameState = GameState.WIN;
                // if (gameStateCallback != null) {
                //     gameStateCallback(gameState);
                // }
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

    public function allowMobsSpawn(allowSpawnMobs:Bool) {
        this.allowSpawnMobs = allowSpawnMobs;
    }

    public function spawnMobs() {
        final now = haxe.Timer.stamp();

        if (allowSpawnMobs && mobsSpawned < mobsMax && (mobsLastSpawnTime == 0 || mobsLastSpawnTime + mobSpawnDelayMs < now)) {
            mobsSpawned++;
            mobsLastSpawnTime = now;

            var positionX = 1800;
            var positionY = 1800;

            // final rnd = MathUtils.randomIntInRange(1, 4);
            // switch (rnd) {
            //     case 1:
            //         positionX = 800;
            //         positionY = 800;
            //     case 2:
            //         positionX = 2800;
            //         positionY = 800;
            //     case 3:
            //         positionX = 800;
            //         positionY = 2800;
            //     case 4:
            //         positionX = 2800;
            //         positionY = 2800;
            // }

            createCharacterEntity(SeidhEntityFactory.InitiateCharacter(null, null, positionX, positionY, MathUtils.randomIntInRange(1, 2) == 1 ? EntityType.ZOMBIE_BOY : EntityType.ZOMBIE_GIRL));
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

    public function getPlayerKills(playerId:String) {
        if (playerZombieKills.exists(playerId)) {
            return playerZombieKills.get(playerId);
        } else {
            return 0;
        }
    }

    public function clearPlayerKills(playerId:String) {
        playerZombieKills.remove(playerId);
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

    // ---------------------------------------------------
    // Getters
    // ---------------------------------------------------

    public function getGameState() {
        return gameState;
    }

    // ---------------------------------------------------
    // Setters
    // ---------------------------------------------------

    public function setGameState(gameState:GameState) {
        this.gameState = gameState;
        if (gameStateCallback != null) {
            gameStateCallback(gameState);
        }
    }
}