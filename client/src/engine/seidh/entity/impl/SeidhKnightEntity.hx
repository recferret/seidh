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
            characterMovementStruct: GetMovementStruct(),
            characterActionStruct: GetActionsStruct()
        });
    }

    private static function GetMovementStruct() {
        final movement:CharacterMovementStruct = {
            canWalk: true,
            canRun: false,
            walkSpeed: 10,
            runSpeed: 0,
            movementDelay: 0.100,
            vitality: 100,
            vitalityConsumptionPerSec: 20,
            vitalityRegenPerSec: 10,
        };
        return movement;
    }

    private static function GetActionsStruct() {
        final actions = new Array<CharacterActionStruct>();

        actions.push({
            actionType: CharacterActionType.MELEE_ATTACK_1,
            damage: 5,
            shape: new EntityShape(140, 100, 80, 100),
            inputDelay: 1,
        });
        actions.push({
            actionType: CharacterActionType.MELEE_ATTACK_2,
            damage: 5,
            shape: new EntityShape(140, 100, 80, 100),
            inputDelay: 1,
        });
        actions.push({
            actionType: CharacterActionType.MELEE_ATTACK_3,
            damage: 5,
            shape: new EntityShape(140, 100, 80, 100),
            inputDelay: 1,
        });
        actions.push({
            actionType: CharacterActionType.RUN_ATTACK,
            damage: 10,
            shape: new EntityShape(10, 10),
            inputDelay: 3,
        });
        actions.push({
            actionType: CharacterActionType.DEFEND,
            damage: 0,
            shape: new EntityShape(100, 100),
            inputDelay: 3,
        });

        return actions;
    }

}