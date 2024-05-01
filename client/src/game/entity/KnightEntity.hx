package game.entity;

import game.utils.Utils;
import h2d.Graphics;

class KnightEntity extends BaseClientEntity {

    public function new(s2d:h2d.Scene) {
        super(s2d);
    }

    public function update(dt:Float) {
        moveToServerPosition(dt);
    }

    public function debugDraw(graphics:Graphics) {
        final debugActionShape = getDebugActionShape();
        if (debugActionShape != null) {
            Utils.DrawRect(graphics, debugActionShape.toRect(x, y, engineEntity.currentDirectionSide), GameConfig.GreenColor);
        }

        Utils.DrawRect(graphics, engineEntity.getBodyRectangle(), GameConfig.GreenColor);
    }
}