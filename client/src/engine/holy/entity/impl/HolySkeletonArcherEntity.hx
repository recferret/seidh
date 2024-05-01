package engine.holy.entity.impl;

import engine.base.BaseTypesAndClasses;
import engine.holy.entity.base.HolyBaseEntity;

class HolySkeletonArcherEntity extends HolyBaseEntity {

    public function new(baseObjectEntity:BaseObjectEntity) {
        super(baseObjectEntity);
    }

    // ------------------------------------------------
	// Dummy stats hardcode instead of database
	// ------------------------------------------------

    public static function GenerateObjectEntity(id: String, ownerId: String, x:Int, y:Int) {
        return new BaseObjectEntity({
            x: x, 
            y: y,
            entityType: EntityType.SKELETON_ARCHER,
            entityShape: new EntityShape(64, 64, 32, 100),
            id: id,
            ownerId: ownerId,
            health: 100,
            dodgeChance: 20,
            entityMovementStruct: GetMovementStruct(),
            entityActionStruct: GetActionsStruct()
        });
    }

    public static function GetMovementStruct():EntityMovementStruct {
        final movement:EntityMovementStruct = {
            canWalk: true,
            canRun: false,
            walkSpeed: 10,
            runSpeed: 0,
            movementDelay: 0.100,
            vitality:0,
            vitalityConsumptionPerSec:0,
            vitalityRegenPerSec:0,
        };
        return movement;
    }

    public static function GetActionsStruct():Array<EntityActionStruct> {
        final actions = new Array<EntityActionStruct>();

        actions.push({
            actionType: EntityActionType.MELEE_ATTACK_1,
            damage: 10,
            aoe: true,
            penetration: false,
            shape: new EntityShape(100, 100),
            inputDelay: 1,
        });
        actions.push({
            actionType: EntityActionType.MELEE_ATTACK_2,
            damage: 10,
            aoe: true,
            penetration: false,
            shape: new EntityShape(100, 100),
            inputDelay: 1,
        });
        actions.push({
            actionType: EntityActionType.MELEE_ATTACK_3,
            damage: 10,
            aoe: true,
            penetration: false,
            shape: new EntityShape(100, 100),
            inputDelay: 1,
        });
        actions.push({
            actionType: EntityActionType.RANGED_ATTACK1,
            damage: 10,
            aoe: false,
            penetration: true,
            shape: new EntityShape(10, 10),
            inputDelay: 3,
        });
        actions.push({
            actionType: EntityActionType.RANGED_ATTACK2,
            damage: 10,
            aoe: false,
            penetration: true,
            shape: new EntityShape(10, 10),
            inputDelay: 3,
        });

        return actions;
    }

}