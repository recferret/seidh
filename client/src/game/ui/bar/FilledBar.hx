package game.ui.bar;

import game.ui.text.TextUtils;
import game.utils.Utils;
import game.Res.SeidhResource;

import motion.Actuate;

class FilledBar extends h2d.Object {

    private final barBmp:h2d.Bitmap;
    private final textObject:h2d.Text;
    private final customGraphics:h2d.Graphics;
    private final color:Int;

    public function new(barColor:Int, addText:Bool) {
        super();

        barBmp = new h2d.Bitmap(Res.instance.getTileResource(SeidhResource.UI_GAME_BAR), this);
        customGraphics = new h2d.Graphics(this);
        color = barColor;

        if (addText) {
            textObject = TextUtils.GetDefaultTextObject(0, -13, 0.8, Center, GameClientConfig.DefaultFontColor);
            addChild(textObject);
        }
    }

    public function updateText(text:String) {
        if (textObject != null) {
            textObject.text = text;
        }
    }

    public function updateBar(currentValue:Int, maxValue:Int) {
        customGraphics.clear();

        final maxBarWidthPx = 198;
        final currentBarWidthPx = maxBarWidthPx / 100 * (currentValue / maxValue * 100);

        Utils.DrawRectFilled(customGraphics, new engine.base.geometry.Rectangle(-99, -11, currentBarWidthPx, 24, 0), color);
    }

    public function getBitmapWidth() {
        return barBmp.tile.width;
    }

    public function getBitmapHeight() {
        return barBmp.tile.height;
    }

    public function pulseAnim() {
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