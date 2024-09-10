package engine.seidh.entity.impl;

import engine.base.MathUtils;
import engine.base.BaseTypesAndClasses;
import engine.seidh.entity.base.SeidhBaseEntity;

class ZombieBoyEntity extends SeidhBaseEntity {

    public function new(characterEntity:CharacterEntity) {
        super(characterEntity);
    }

    // ------------------------------------------------
	// Dummy stats hardcode instead of database
	// ------------------------------------------------

    public static function GenerateObjectEntity(id: String, ownerId: String, x:Int, y:Int) {
        final defaultSpeed = 3;
        final additionalRndSpeed = MathUtils.randomIntInRange(0, 7);

        var speedFactor = 10;

        switch (additionalRndSpeed) {
            case 0:
                speedFactor = 3;
            case 1:
                speedFactor = 5;
            case 3:
                speedFactor = 7;
            case 4:
                speedFactor = 9;
            case 5:
                speedFactor = 11;
            case 6:
                speedFactor = 13;
            case 7:
                speedFactor = 15;
        }

        return new CharacterEntity({
            base: {
                x: x, 
                y: y,
                entityType: EntityType.ZOMBIE_BOY,
                entityShape: {width: 200, height: 260, rectOffsetX: 0, rectOffsetY: 0},
                id: id,
                ownerId: ownerId,
                rotation: 0
            },
            health: 10,
            movement: {
                canWalk: true,
                canRun: true,
                runSpeed: defaultSpeed + additionalRndSpeed,
                speedFactor: speedFactor,
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
                    shape: {width: 300, height: 400, rectOffsetX: 0, rectOffsetY: 0},
                }
            }
        });
    }
    
}