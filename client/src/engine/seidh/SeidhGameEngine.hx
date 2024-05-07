package engine.seidh;

import js.lib.Date;

import engine.base.BaseTypesAndClasses;
import engine.base.entity.base.EngineBaseEntity;
import engine.base.entity.impl.EngineProjectileEntity;
import engine.base.core.BaseEngine;
import engine.base.entity.impl.EngineCharacterEntity;
import engine.seidh.entity.base.SeidhBaseEntity;
import engine.seidh.entity.factory.SeidhEntityFactory;

typedef CharacterActionCallbackParams = { 
    entityId:String, 
    actionType:CharacterActionType, 
    shape:EntityShape, 
    hurtEntities: Array<String>,
    deadEntities: Array<String> 
};

@:expose
class SeidhGameEngine extends BaseEngine {

    private var framesPassed = 0;
    private var timePassed = 0.0;

    public var characterActionCallbacks:Array<CharacterActionCallbackParams>->Void;

    public static function main() {}

    public function new(engineMode = EngineMode.Server) {
	    super(engineMode);
    }

    public function createCharacterEntityFromMinimalStruct(struct:Dynamic) {
        createCharacterEntity(SeidhEntityFactory.InitiateEntity(struct.id, struct.ownerId, struct.x, struct.y, struct.entityType), true);
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
        final beginTime = Date.now();

		framesPassed++;
		timePassed += dt;

        final characterActionCallbackParams = new Array<CharacterActionCallbackParams>();

        for (e in projectileEntityManager.entities) {
            final projectile = cast(e, EngineProjectileEntity);

            if (projectile.allowMovement) {
                projectile.update(dt);
            } else {
                removeProjectileEntity(projectile.getId());
            }
        }

        for (e in characterEntityManager.entities) {
            final character = cast(e, EngineCharacterEntity);
            if (character.isAlive) {
                if (character.getEntityType() == EntityType.SKELETON_WARRIOR) {
                    final targetPlayer = getNearestPlayer(character);
                    if (targetPlayer != null) {
                        character.setTargetObject(targetPlayer);
                        // if (entity.ifTargetInAttackRange()) {
                        //     entity.aiMeleeAttack();
                        // }
                    }
                }

                character.update(dt);

                if (character.isActing) {
                    final hurtEntities = new Array<String>();
                    final deadEntities = new Array<String>();

                    if (character.actionToPerform.projectileStruct != null) {
                        createProjectileEntity(createProjectileByCharacter(character), true);
                    } else {
                        
                    }

                    // for (e2 in characterEntityManager.entities) {
                    //     final entity2 = cast(e2, EngineCharacterEntity);
                    //     if (entity2.isAlive && entity.getId() != entity2.getId()) {
                    //         if (entity.getCurrentActionRect().containsRect(entity2.getBodyRectangle())) {
                    //             final health = entity2.subtractHealth(entity.actionToPerform.damage);
                    //             if (health == 0) {
                    //                 entity2.isAlive = false;
                    //                 deadEntities.push(entity2.getId());
                    //                 removeCharacterEntity(entity2.getId());
                    //             } else {
                    //                 hurtEntities.push(entity2.getId());
                    //             }
                    //         }
                    //     }
                    // }

                    characterActionCallbackParams.push({
                        entityId: character.getId(),
                        actionType: character.actionToPerform.actionType,
                        shape: character.actionToPerform.shape,
                        hurtEntities: hurtEntities,
                        deadEntities: deadEntities,
                    });

                    character.isActing = false;
                }

                character.isRunning = false;
                character.isWalking = false;
            }
        }

        if (characterActionCallbacks != null && characterActionCallbackParams.length > 0) {
            characterActionCallbacks(characterActionCallbackParams);
        }

        recentEngineLoopTime = Date.now() - beginTime;
    }

    private function createProjectileByCharacter(character:EngineCharacterEntity) {
        final ownerRect = character.getBodyRectangle();
        final projectileEntity = new EngineProjectileEntity(new ProjectileEntity({
            base: {
                x: ownerRect.getCenter().x,
                y: ownerRect.getCenter().y,
                entityType: EntityType.PROJECTILE_MAGIC_ARROW,
                entityShape: character.actionToPerform.shape,
                id: character.getId(),
                ownerId: character.getOwnerId(),
                rotation: character.getRotation(),
            },
	        projectile: character.actionToPerform.projectileStruct
        }));
        return projectileEntity;
    }

    private function getNearestPlayer(entity:EngineBaseEntity) {
        var nearestPlayer:EngineBaseEntity = null;
        var nearestPlayerDistance:Float = 0.0;

        for (targetEntity in characterEntityManager.entities) {
            if (targetEntity.getEntityType() == EntityType.KNIGHT) {
                final dist = entity.getBodyRectangle().getCenter().distance(targetEntity.getBodyRectangle().getCenter());
                if (nearestPlayer == null || dist < nearestPlayerDistance) {
                    nearestPlayer = targetEntity;
                    nearestPlayerDistance = dist;
                }
            }
        }

        return nearestPlayer;
    }

    public function customDestroy() {
        // clear callbacks
        characterActionCallbacks = null;
    }

}