package engine.holy.entity.impl;

import engine.base.BaseTypesAndClasses;
import engine.holy.entity.base.HolyBaseEntity;

class HolySkeletonWarriorEntity extends HolyBaseEntity {

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
            entityType: EntityType.SKELETON_WARRIOR,
            entityShape: new EntityShape(64, 64, 64, 100),
            id: id,
            ownerId: ownerId,
            health: 10,
            dodgeChance: 0,
            entityMovementStruct: GetMovementStruct(),
            entityActionStruct: GetActionsStruct()
        });
    }

    public static function GetMovementStruct() {
        final movement:EntityMovementStruct = {
            canWalk: true,
            canRun: true,
            walkSpeed: 20,
            runSpeed: 35,
            movementDelay: 0.100,
            vitality: 100,
            vitalityConsumptionPerSec: 20,
            vitalityRegenPerSec: 10,
        };
        return movement;
    }

    public static function GetActionsStruct() {
        final actions = new Array<EntityActionStruct>();

        actions.push({
            actionType: EntityActionType.MELEE_ATTACK_1,
            damage: 10,
            aoe: true,
            penetration: false,
            shape: new EntityShape(140, 100, 80, 100),
            inputDelay: 1,
        });
        actions.push({
            actionType: EntityActionType.MELEE_ATTACK_2,
            damage: 10,
            aoe: true,
            penetration: false,
            shape: new EntityShape(140, 100, 80, 100),
            inputDelay: 1,
        });
        actions.push({
            actionType: EntityActionType.MELEE_ATTACK_3,
            damage: 10,
            aoe: true,
            penetration: false,
            shape: new EntityShape(140, 100, 80, 100),
            inputDelay: 1,
        });
        actions.push({
            actionType: EntityActionType.RUN_ATTACK,
            damage: 10,
            aoe: true,
            penetration: false,
            shape: new EntityShape(140, 100, 80, 100),
            inputDelay: 1,
        });

        return actions;
    }
}