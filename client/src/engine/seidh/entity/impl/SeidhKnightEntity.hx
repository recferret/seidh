package engine.seidh.entity.impl;

import engine.base.BaseTypesAndClasses;
import engine.seidh.entity.base.SeidhBaseEntity;

class SeidhKnightEntity extends SeidhBaseEntity {

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
                entityType: EntityType.KNIGHT,
                entityShape: new EntityShape(64, 64, 32, 100),
                id: id,
                ownerId: ownerId,
            },
            health: 100,
            dodgeChance: 0,
            characterMovementStruct: {
                canWalk: true,
                canRun: false,
                walkSpeed: 10,
                runSpeed: 0,
                movementDelay: 0.100,
                vitality: 100,
                vitalityConsumptionPerSec: 20,
                vitalityRegenPerSec: 10,
            },
            characterActionMainStruct: {
                actionType: CharacterActionType.ACTION_MAIN,
                damage: 5,
                shape: new EntityShape(140, 100, 80, 100),
                inputDelay: 1,
            },
            characterAction1Struct: {
                actionType: CharacterActionType.ACTION_1,
                damage: 5,
                shape: new EntityShape(10, 10, 0, 0),
                inputDelay: 1,
                projectileStruct: {
                    aoe: false,
                    penetration: false,
                    speed: 10,
                    travelDistance: 200,
                    projectiles: 1,
                },
            },
            characterAction2Struct: {
                actionType: CharacterActionType.ACTION_2,
                damage: 5,
                shape: new EntityShape(25, 25, 0, 0),
                inputDelay: 1,
                projectileStruct: {
                    aoe: true,
                    penetration: false,
                    speed: 10,
                    travelDistance: 200,
                    projectiles: 1,
                    aoeShape: new EntityShape(100, 100, 0, 0),
                },
            },
            characterAction3Struct: {
                actionType: CharacterActionType.ACTION_3,
                damage: 0,
                shape: new EntityShape(100, 100),
                inputDelay: 3,
            }
        });
    }
    
}