package engine.seidh.entity.base;

import haxe.Int32;

import engine.base.EngineConfig;
import engine.base.MathUtils;
import engine.base.Utils.EngineUtils;
import engine.base.entity.impl.EngineCharacterEntity;
import engine.base.types.TypesBaseEntity;
import engine.base.types.TypesBaseMultiplayer;

abstract class SeidhCharacterEntity extends EngineCharacterEntity {

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

	// AI 

    public function aiLookAtTarget() {
		if (hasTargetObject() && !isPlayer()) {
			// Rotate bot in the target direction
			final angleBetweenEntities = MathUtils.angleBetweenPoints(getBodyRectangle().getCenter(), targetObjectEntity.getBodyRectangle().getCenter());
			baseEntity.rotation = angleBetweenEntities;

			// Bot line sight for debug
			final l = getForwardLookingLine(botForwardLookingLineLength);
			botForwardLookingLine.x1 = l.x1;
			botForwardLookingLine.y1 = l.y1; 
			botForwardLookingLine.x2 = l.x2;
			botForwardLookingLine.y2 = l.y2;
		}
    }

	public function aiFollowAndAttack() {
		if (hasTargetObject() && !isPlayer() && canChangeState) {
			if (ifTargetInAttackRange()) {
				performMoveNextUpdate = false;
				if (EngineConfig.AI_ACTION_ENABLED && canChangeState) {
					if (checkLocalActionInput(CharacterActionType.ACTION_MAIN)) {
						canChangeState = false;
						setNextActionToPerform(CharacterActionType.ACTION_MAIN);
					}
				}
			} else {
				performMoveNextUpdate = true;
			}
		}
	}

	public function aiApplyAction1() {
		if (EngineConfig.AI_ACTION_ENABLED && actionState == CharacterActionState.READY) {
			if (checkLocalActionInput(CharacterActionType.ACTION_1)) {
				setNextActionToPerform(CharacterActionType.ACTION_1);
			}
		}
	}

	public function aiApplyAction2() {
		if (EngineConfig.AI_ACTION_ENABLED && actionState == CharacterActionState.READY) {
			if (checkLocalActionInput(CharacterActionType.ACTION_2)) {
				setNextActionToPerform(CharacterActionType.ACTION_2);
			}
		}
	}

}