package game.ui.bar;

import game.utils.Utils;
import game.Res.SeidhResource;

import motion.Actuate;

class BarHp extends h2d.Object {

    private final barBmp:h2d.Bitmap;
    private final customGraphics:h2d.Graphics;

    public function new(s2d:h2d.Scene) {
        super(s2d);

        barBmp = new h2d.Bitmap(Res.instance.getTileResource(SeidhResource.UI_GAME_HP), this);
        customGraphics = new h2d.Graphics(s2d);
    }

    public function update(currentHealth:Int, maxHealth:Int) {
        customGraphics.clear();

        final maxHealthBarWidthPx = 205;
        final currentHealthBarWidthPx = maxHealthBarWidthPx / 100 * (currentHealth / maxHealth * 100);

        Utils.DrawRectFilled(customGraphics, new engine.base.geometry.Rectangle(83, 34, currentHealthBarWidthPx, 14, 0), GameClientConfig.HpBarColor);
    }

    public function getBitmapWidth() {
        return barBmp.tile.width;
    }

    public function getBitmapHeight() {
        return barBmp.tile.height;
    }

    public function addHp() {
        Actuate.tween(this, 0.1, { 
            scaleX: 1.1,
            scaleY: 1.1
        })
        .delay(0.3)
        .onComplete(function callback() {
            Actuate.tween(this, 0.1, { 
                scaleX: 1,
                scaleY: 1
            });
        });
    }

}