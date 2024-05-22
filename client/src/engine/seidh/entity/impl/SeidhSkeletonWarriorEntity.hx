package engine.seidh.entity.impl;

import engine.base.BaseTypesAndClasses;
import engine.seidh.entity.base.SeidhBaseEntity;

class SeidhSkeletonWarriorEntity extends SeidhBaseEntity {

    public function new(characterEntity:CharacterEntity) {
        super(characterEntity);
    }

    // ------------------------------------------------
	// Dummy stats hardcode instead of database
	// ------------------------------------------------

    public static function GenerateObjectEntity(id: String, ownerId: String, x:Int, y:Int) {
        return new CharacterEntity({
            base: {
                x: x, 
                y: y,
                entityType: EntityType.SKELETON_WARRIOR,
                entityShape: new EntityShape(64, 64, 64, 100),
                id: id,
                ownerId: ownerId,
                rotation: 0
            },
            health: 10,
            characterMovementStruct: {
                canWalk: true,
                canRun: true,
                walkSpeed: 20,
                runSpeed: 35,
                movementDelay: 0.100,
                vitality: 100,
                vitalityConsumptionPerSec: 20,
                vitalityRegenPerSec: 10,
            },
            characterActionMainStruct: {
                actionType: CharacterActionType.ACTION_MAIN,
                damage: 10,
                inputDelay: 1,
                meleeStruct: {
                    aoe: false,
                    shape: new EntityShape(140, 100, 80, 100),
                }
            }
        });
    }
    
}