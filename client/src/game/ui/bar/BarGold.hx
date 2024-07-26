package game.ui.bar;

import hxd.res.DefaultFont;

import game.Res.SeidhResource;

import motion.Actuate;

class BarGold extends h2d.Object {

    private final barBmp:h2d.Bitmap;
    private final goldText:h2d.Text;
    private final goldIcon:h2d.Bitmap;

    private var goldAmount = 0;

    public function new(parent:h2d.Object) {
        super(parent);

        barBmp = new h2d.Bitmap(Res.instance.getTileResource(SeidhResource.UI_GAME_MONEY), this);

        goldText = new h2d.Text(DefaultFont.get());
        goldText.text = Std.string(goldAmount);
        goldText.textColor = GameConfig.FontColor;
        goldText.dropShadow = { dx : 0.5, dy : 0.5, color : 0xFF0000, alpha : 0.8 };
        goldText.textAlign = Right;
        goldText.setScale(1.4);
        goldText.setPosition(50, -11);
        addChild(goldText);

        goldIcon = new h2d.Bitmap(Res.instance.getTileResource(SeidhResource.ICON_COINS), this);
        goldIcon.setScale(0.25);
        goldIcon.setPosition(75, 0);
    }

    public function getBitmapWidth() {
        return barBmp.tile.width;
    }

    public function getBitmapHeight() {
        return barBmp.tile.height;
    }

    public function addGold() {
        goldAmount += 1;
        goldText.text = Std.string(goldAmount);

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