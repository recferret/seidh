package engine.seidh.entity.impl;

import engine.base.MathUtils;
import engine.base.types.TypesBaseEntity;
import engine.seidh.entity.base.SeidhCharacterEntity;

class ZombieBoyEntity extends SeidhCharacterEntity {

    public function new(characterEntity:CharacterEntity) {
        super(characterEntity);
    }

    // ------------------------------------------------
	// Dummy stats hardcode instead of database
	// ------------------------------------------------

    public static function GenerateObjectEntity(struct:CharacterEntityMinStruct) {
        final defaultSpeed = 3;
        final additionalRndSpeed = MathUtils.randomIntInRange(0, 7);

        var speedFactor = 0;

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
                x: struct.x, 
                y: struct.y,
                entityType: EntityType.ZOMBIE_BOY,
                entityShape: {
                    width: 200,
                    height: 260,
                    rectOffsetX: 0,
                    rectOffsetY: 0,
                    radius: 0,
                },
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
                    shape: {
                        width: 300,
                        height: 400,
                        rectOffsetX: 0,
                        rectOffsetY: 0,
                        radius: 0,
                    },
                }
            }
        });
    }
    
}