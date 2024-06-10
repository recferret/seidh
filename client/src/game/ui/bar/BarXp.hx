package game.ui.bar;

import game.utils.Utils;

class BarXp extends h2d.Object {

    final barBmp:h2d.Bitmap;
    private final customGraphics:h2d.Graphics;

    public function new(s2d:h2d.Scene) {
        super(s2d);

        barBmp = new h2d.Bitmap(hxd.Res.ui.bar_xp_1.toTile(), this);
        customGraphics = new h2d.Graphics(s2d);
    }

    public function update() {
        customGraphics.clear();
        Utils.DrawRectFilled(customGraphics, new engine.base.geometry.Rectangle(43, 64, 118, 15, 0), GameConfig.XpBarColor);
    }

    public function getBitmapWidth() {
        return barBmp.tile.width;
    }

    public function getBitmapHeight() {
        return barBmp.tile.height;
    }

}