package game.ui;

import game.utils.Utils;

class BarHp extends h2d.Object {

    private final barBmp:h2d.Bitmap;
    private final customGraphics:h2d.Graphics;

    public function new(s2d:h2d.Scene) {
        super(s2d);

        barBmp = new h2d.Bitmap(hxd.Res.ui.bar_hp_1.toTile(), this);
        customGraphics = new h2d.Graphics(s2d);
    }

    public function update() {
        customGraphics.clear();
        Utils.DrawRectFilled(customGraphics, new engine.base.geometry.Rectangle(40, 16, 153, 19, 0), GameConfig.HpBarColor);
    }

    public function getBitmapWidth() {
        return barBmp.tile.width;
    }

    public function getBitmapHeight() {
        return barBmp.tile.height;
    }

}