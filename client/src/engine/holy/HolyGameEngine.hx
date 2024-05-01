package engine.holy;

import js.lib.Date;

import engine.base.BaseTypesAndClasses;
import engine.base.core.BaseEngine;
import engine.base.entity.EngineBaseGameEntity;
import engine.holy.entity.base.HolyBaseEntity;
import engine.holy.entity.factory.HolyEntityFactory;
import engine.holy.entity.manager.HolyEntityManager;

typedef EntityActionCallbackParams = { 
    entityId:String, 
    actionType:EntityActionType, 
    shape:EntityShape, 
    hurtEntities: Array<String>,
    deadEntities: Array<String> 
};

@:expose
class HolyGameEngine extends BaseEngine {

    private var framesPassed = 0;
    private var timePassed = 0.0;

    public var entityActionCallback:Array<EntityActionCallbackParams>->Void;

    public static function main() {}

    public function new(engineMode = EngineMode.Server) {
	    super(engineMode, new HolyEntityManager());
    }

    public function buildEngineEntityFromMinimalStruct(struct:Dynamic) {
        createMainEntity(HolyEntityFactory.InitiateEntity(struct.id, struct.ownerId, struct.x, struct.y, struct.entityType), true);
    }

    // ---------------------------------------------------
    // Abstract implementation
    // ---------------------------------------------------

    public function processInputCommands(playerInputCommands:Array<InputCommandEngineWrapped>) {
        for (i in playerInputCommands) {
			final input = cast(i.playerInputCommand, PlayerInputCommand);
			final inputInitiator = input.playerId;
			final entityId = playerToEntityMap.get(inputInitiator);
			final entity = cast(mainEntityManager.getEntityById(entityId), HolyBaseEntity);

			if (entity == null || entity.getOwnerId() != inputInitiator) {
				continue;
			}
        
            // Server request queue
			validatedInputCommands.push(input);

            if (input.inputType == MELEE_ATTACK || input.inputType == RANGED_ATTACK || input.inputType == DEFEND) {
                entity.markForAction(input.inputType, Side.RIGHT);
            } else {
                entity.performMove(input);
            }
		}
    }

    public function engineLoopUpdate(dt:Float) {
        final beginTime = Date.now();

		framesPassed++;
		timePassed += dt;

        final entityActionCallbacks = new Array<EntityActionCallbackParams>();

        for (entity in mainEntityManager.entities) {
			if (entity.isAlive) {
                if (entity.getEntityType() == EntityType.SKELETON_WARRIOR) {
                    final targetPlayer = getNearestPlayer(entity);
                    if (targetPlayer != null) {
                        entity.setTargetObject(targetPlayer);
                    }
                }

                entity.update(dt);

                if (entity.isActing) {
                    final hurtEntities = new Array<String>();
                    final deadEntities = new Array<String>();

                    for (entity2 in mainEntityManager.entities) {
                        if (entity2.isAlive && entity.getId() != entity2.getId()) {
                            if (entity.getCurrentActionRect().containsRect(entity2.getBodyRectangle())) {
                                final health = entity2.subtractHealth(entity.actionToPerform.damage);
                                if (health == 0) {
                                    entity2.isAlive = false;
                                    deadEntities.push(entity2.getId());
                                    removeMainEntity(entity2.getId());
                                } else {
                                    hurtEntities.push(entity2.getId());
                                }
                            }
                        }
                    }

                    entityActionCallbacks.push({
                        entityId: entity.getId(),
                        actionType: entity.actionToPerform.actionType,
                        shape: entity.actionToPerform.shape,
                        hurtEntities: hurtEntities,
                        deadEntities: deadEntities,
                    });

                    entity.isActing = false;
                }

                entity.isRunning = false;
                entity.isWalking = false;
            }
        }

        if (entityActionCallback != null && entityActionCallbacks.length > 0) {
            entityActionCallback(entityActionCallbacks);
        }

        recentEngineLoopTime = Date.now() - beginTime;
    }

    private function getNearestPlayer(entity:EngineBaseGameEntity) {
        var nearestPlayer:EngineBaseGameEntity = null;
        var nearestPlayerDistance:Float = 0.0;

        for (targetEntity in mainEntityManager.entities) {
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
        entityActionCallback = null;
    }

}