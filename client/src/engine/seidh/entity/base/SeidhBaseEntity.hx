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
        performMoveNextUpdate = true;
    }

	// ------------------------------------------------
	// Abstract implementation
	// ------------------------------------------------

    // canPerformMove and canPerformAction has to be reimplemented due to server input double check 
    public function canPerformMove():Bool {
        return true;
    }

    public function canPerformAction(characterActionType:CharacterActionType):Bool {
        return true;
    }

    public function updateHashImpl():Int32 {
        final e = baseEntity;
        final c = characterEntity;
		final s:String = e.id + e.x + e.y + c.health;
        return EngineUtils.HashString(s);
    }

}