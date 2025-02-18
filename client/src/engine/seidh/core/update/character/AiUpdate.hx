package engine.seidh.core.update.character;

import engine.base.entity.impl.EngineCharacterEntity;
import engine.base.entity.base.EngineBaseEntity;

class AiUpdate extends BasicUpdate {

    public function new(allowServerLogic:Bool) {
        super(allowServerLogic);
    }

    public function update(dt:Float, characters:Array<EngineBaseEntity>) {
        absUpdate(dt, characters);
    }

    function absUpdate(dt:Float, characters:Array<EngineBaseEntity>) {
        if (allowServerLogic && SeidhConfig.AI_ENABLED) {
            for (e1 in characters) {
                final character1 = cast(e1, EngineCharacterEntity);
                    
                if (character1.isAlive && !character1.isPlayer()) {
                    // Find and set nearest player as a target
                    final targetPlayer = cast(getNearestPlayer(characters, character1), EngineCharacterEntity);
                    if (targetPlayer != null && targetPlayer.isAlive && character1.getTargetObject() != targetPlayer) {
                        character1.setTargetObject(targetPlayer, true);
                    } else {
                        character1.clearTargetObject();
                    }

                    // Restrict movement through objects
                    for (e2 in characters) {
                        final character2 = cast(e2, EngineCharacterEntity);
                        if (!character1.intersectsWithCharacter && character1.getId() != character2.getId() && character2.isAlive && !character2.isPlayer()) {
                            if (character2.getBodyRectangle().intersectsWithLine(character1.botForwardLookingLine)) {
                                character1.intersectsWithCharacter = true;
                                character1.canMove = false;
                            }
                        }
                    }

                    character1.intersectsWithCharacter = false;
                    character1.canMove = true;
                }
            }
        }
    }

}