package engine.seidh.entity.base;

import haxe.Int32;
import engine.base.Utils.EngineUtils;
import engine.base.BaseTypesAndClasses;
import engine.base.entity.impl.EngineCharacterEntity;

class SeidhBaseEntity extends EngineCharacterEntity {

    public function new(characterEntity:CharacterEntity) {
        super(characterEntity);
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
        if (playerInputType == PlayerInputType.DEFEND && baseEntity.entityType != EntityType.KNIGHT || 
            playerInputType == PlayerInputType.RANGED_ATTACK && baseEntity.entityType == EntityType.KNIGHT)
            return false;
        return true;
    }

    public function updateHashImpl():Int32 {
        final e = baseEntity;
        final c = characterEntity;
		final s:String = e.id + e.x + e.y + c.health;
        return EngineUtils.HashString(s);
    }

}