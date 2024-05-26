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
                rotation: 0
            },
            health: 100,
            movement: {
                canWalk: true,
                canRun: false,
                walkSpeed: 10,
                runSpeed: 0,
                movementDelay: 0.100,
                vitality: 100,
                vitalityConsumptionPerSec: 20,
                vitalityRegenPerSec: 10,
            },
            actionMain: {
                actionType: CharacterActionType.ACTION_MAIN,
                damage: 5,
                inputDelay: 1,
                meleeStruct: {
                    aoe: true,
                    shape: new EntityShape(140, 100, 80, 100),
                }
            },
            action1: {
                actionType: CharacterActionType.ACTION_1,
                damage: 5,
                inputDelay: 1,
                projectileStruct: {
                    aoe: false,
                    penetration: false,
                    speed: 200,
                    travelDistance: 900,
                    projectiles: 1,
                    shape: new EntityShape(30, 10, 0, 0),
                },
            },
            action2: {
                actionType: CharacterActionType.ACTION_2,
                damage: 5,
                inputDelay: 1,
                projectileStruct: {
                    aoe: true,
                    penetration: false,
                    speed: 10,
                    travelDistance: 200,
                    projectiles: 1,
                    aoeShape: new EntityShape(100, 100, 0, 0),
                    shape: new EntityShape(25, 25, 0, 0),
                },
            },
            action3: {
                actionType: CharacterActionType.ACTION_3,
                damage: 0,
                inputDelay: 3,
                meleeStruct: {
                    aoe: true,
                    shape: new EntityShape(100, 100),
                }
            }
        });
    }
    
}