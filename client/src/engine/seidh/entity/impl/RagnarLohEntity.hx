package engine.seidh.entity.impl;

import engine.base.BaseTypesAndClasses;
import engine.seidh.entity.base.SeidhBaseEntity;

class RagnarLohEntity extends SeidhBaseEntity {

    public function new(characterEntity:CharacterEntity) {
        super(characterEntity);
    }

    // ------------------------------------------------
	// Dummy stats hardcode instead of database
	// ------------------------------------------------

    public static function GenerateObjectEntity(struct:CharacterEntityMinStruct) {
        return new CharacterEntity({
            base: {
                x: struct.x, 
                y: struct.y,
                entityType: EntityType.RAGNAR_LOH,
                entityShape: {
                    width: 180,
                    height: 260,
                    rectOffsetX: 0,
                    rectOffsetY: 0,
                    radius: 150 * struct.pickUpModifier,
                },
                id: struct.id,
                ownerId: struct.ownerId,
                rotation: 0
            },
            health: 100,
            movement: {
                canRun: false,
                runSpeed: 40,
                speedFactor: 10,
                inputDelay: 0.100,
            },
            actionMain: {
                actionType: CharacterActionType.ACTION_MAIN,
                damage: 5,
                inputDelay: 1,
                meleeStruct: {
                    aoe: true,
                    shape: {
                        width: 350, 
                        height: 260, 
                        rectOffsetX: 175 - 90, 
                        rectOffsetY: 0,
                    },
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
                    shape: {
                        width: 30, 
                        height: 10, 
                        rectOffsetX: 0, 
                        rectOffsetY: 0,
                    },
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
                    aoeShape: {width: 100, height: 100, rectOffsetX: 0, rectOffsetY: 0},
                    shape: {width: 25, height: 25, rectOffsetX: 0, rectOffsetY: 0},
                },
            },
            action3: {
                actionType: CharacterActionType.ACTION_3,
                damage: 0,
                inputDelay: 3,
                meleeStruct: {
                    aoe: true,
                    shape: {width: 100, height: 100, rectOffsetX: 0, rectOffsetY: 0},
                }
            }
        });
    }
    
}