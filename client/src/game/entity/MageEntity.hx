package game.entity;

import game.utils.Utils;
import h2d.Graphics;

class MageEntity extends BaseClientEntity {

    public function new(s2d:h2d.Scene) {
        super(s2d);
    }

    public function update(dt:Float) {}

    public function debugDraw(graphics:Graphics) {
        Utils.DrawRect(graphics, engineEntity.getBodyRectangle(), GameConfig.GreenColor);
    }

}