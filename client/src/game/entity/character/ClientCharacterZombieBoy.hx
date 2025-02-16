package game.entity.character;

import engine.seidh.types.TypesSeidhEntity.CharacterAnimationState;
import engine.base.entity.impl.EngineCharacterEntity;
import game.sound.SoundManager;
import engine.base.geometry.Rectangle;

class ClientCharacterZombieBoy extends ClientCharacterEntity {

    public function new(s2d:h2d.Scene, engineEntity:EngineCharacterEntity) {
        super(s2d, engineEntity);

        animation.setAnimationState(CharacterAnimationState.SPAWN);
        adjustRunAnimationSpeed();
    }

    public function fxDeath() {
        SoundManager.instance.playZombieDeath();
        animation.setAnimationState(DEATH);
    }

    public function getRect() {
        return new Rectangle(x, y, 160, 235, 0);
    }

    public function getBottomRect() {
        return new Rectangle(x, y + 190 / 2, 160, 40, 0);
    }
}