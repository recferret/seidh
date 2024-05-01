package engine.holy.entity.base;

import engine.base.MathUtils;
import haxe.Int32;
import engine.base.BaseTypesAndClasses;
import engine.base.entity.EngineBaseGameEntity;

class HolyBaseEntity extends EngineBaseGameEntity {

    public function new(baseObjectEntity:BaseObjectEntity) {
        super(baseObjectEntity);
    }

    public function performMove(playerInput:PlayerInputCommand) {
        // setRotation(MathUtils.directionToRads(playerInputType));
        setRotation(playerInput.movementAngle);
        determenisticMove();
    }

    public function markForAction(playerInputType:PlayerInputType, side:Side) {
        isActing = true;
    }

	// ------------------------------------------------
	// Abstract implementation
	// ------------------------------------------------

    public function canPerformMove(playerInputType:PlayerInputType):Bool {
        return true;
    }

    public function canPerformAction(playerInputType:PlayerInputType):Bool {
        if (playerInputType == PlayerInputType.DEFEND && baseObjectEntity.entityType != EntityType.KNIGHT || 
            playerInputType == PlayerInputType.RANGED_ATTACK && baseObjectEntity.entityType == EntityType.KNIGHT)
            return false;
        return true;
    }

    public function updateHashImpl():Int32 {
        return 123;
    }

}