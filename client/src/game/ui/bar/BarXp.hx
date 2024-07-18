package game.ui.bar;

import game.Res.SeidhResource;
import game.utils.Utils;

class BarXp extends h2d.Object {

    final barBmp:h2d.Bitmap;
    private final customGraphics:h2d.Graphics;

    public function new(s2d:h2d.Scene) {
        super(s2d);

        barBmp = new h2d.Bitmap(Res.instance.getTileResource(SeidhResource.UI_GAME_XP), this);
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