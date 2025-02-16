package game.entity.character;

import engine.base.entity.impl.EngineCharacterEntity;
import game.sound.SoundManager;
import engine.base.geometry.Rectangle;

class ClientCharacterRagnarLoh extends ClientCharacterEntity {

    public function new(s2d:h2d.Scene, engineEntity:EngineCharacterEntity) {
        super(s2d, engineEntity);
    }

    public function fxDeath() {
        SoundManager.instance.playVikingDeath();
        animation.setAnimationState(DEATH);
    }

    public function getRect() {
        return new Rectangle(x, y, 221, 285, 0);
    }

    public function getBottomRect() {
        return new Rectangle(x, y + 215 / 2, 221, 40, 0);
    }
}