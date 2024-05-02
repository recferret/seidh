package engine.holy.entity.base;

import haxe.Int32;
import engine.base.Utils.EngineUtils;
import engine.base.BaseTypesAndClasses;
import engine.base.entity.EngineBaseGameEntity;

class HolyBaseEntity extends EngineBaseGameEntity {

    public function new(baseObjectEntity:BaseObjectEntity) {
        super(baseObjectEntity);
    }

    public function performMove(playerInput:PlayerInputCommand) {
        setRotation(playerInput.movAngle);
        determenisticMove();
    }

    public function markForAction() {
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
        final e = baseObjectEntity;
		final s:String = e.id + e.x + e.y + e.health;
        return EngineUtils.HashString(s);
    }

}