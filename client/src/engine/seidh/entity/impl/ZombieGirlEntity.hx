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

    public static function GenerateObjectEntity(struct:CharacterEntityMinStruct) {
        final defaultSpeed = 3;
        final additionalRndSpeed = MathUtils.randomIntInRange(0, 7);
        var speedFactor = 10;

        switch (additionalRndSpeed) {
            case 0:
                speedFactor = 6;
            case 1:
                speedFactor = 7;
            case 3:
                speedFactor = 8;
            case 4:
                speedFactor = 9;
            case 5:
                speedFactor = 10;
            case 6:
                speedFactor = 11;
            case 7:
                speedFactor = 12;
        }

        return new CharacterEntity({
            base: {
                x: struct.x, 
                y: struct.y,
                entityType: EntityType.ZOMBIE_GIRL,
                entityShape: {width: 200, height: 260, rectOffsetX: 0, rectOffsetY: 0},
                id: struct.id,
                ownerId: struct.ownerId,
                rotation: 0
            },
            health: 10,
            movement: {
                canRun: true,
                runSpeed: defaultSpeed + additionalRndSpeed,
                speedFactor: speedFactor,
                inputDelay: 0.100,
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