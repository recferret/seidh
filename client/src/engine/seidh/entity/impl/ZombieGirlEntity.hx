package engine.seidh.entity.impl;

import engine.base.MathUtils;
import engine.base.BaseTypesAndClasses;
import engine.seidh.entity.base.SeidhBaseEntity;

class ZombieGirlEntity extends SeidhBaseEntity {

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
                entityType: EntityType.ZOMBIE_GIRL,
                entityShape: {width: 200, height: 260, rectOffsetX: 0, rectOffsetY: 0},
                id: id,
                ownerId: ownerId,
                rotation: 0
            },
            health: 10,
            movement: {
                canWalk: true,
                canRun: true,
                runSpeed: 60 + MathUtils.randomIntInRange(10, 50),
                movementDelay: 0.100,
                vitality: 100,
                vitalityConsumptionPerSec: 20,
                vitalityRegenPerSec: 10,
            },
            actionMain: {
                actionType: CharacterActionType.ACTION_MAIN,
                damage: SeidhGameEngine.ZOMBIE_DAMAGE,
                inputDelay: 1,
                meleeStruct: {
                    aoe: false,
                    shape: {width: 300, height: 380, rectOffsetX: 0, rectOffsetY: 0},
                }
            }
        });
    }
    
}