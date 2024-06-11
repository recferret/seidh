package game.scene.home;

import game.scene.base.BasicScene;
import hxd.res.DefaultFont;

class BoostButton extends h2d.Object {

    private final w = 0.0;
    private final h = 0.0;
    private final bmp:h2d.Bitmap;

    public function new(parent:h2d.Object, boostLabel:String, owned:Bool, price:String) {
        super(parent);

        bmp = new h2d.Bitmap(hxd.Res.ui.dialog.dialog_small.toTile(), this);
        h = bmp.tile.height;
        w = bmp.tile.width;

        final font : h2d.Font = DefaultFont.get();
        final tf = new h2d.Text(font);
        tf.text = boostLabel;
        tf.textColor = GameConfig.FontColor;
        tf.dropShadow = { dx : 0.5, dy : 0.5, color : 0xFF0000, alpha : 0.8 };
        tf.textAlign = Center;
        tf.setScale(5);
        tf.setPosition(w / 2, (h - (tf.textHeight * 5)) / 2);

        addChild(tf);
    }

    public function getBitmap() {
        return bmp;
    }

    public function getHeight() {
        return h;
    }

    public function getWidth() {
        return w;
    }

}

class BoostContent extends BasicHomeContent {

    public function new(scene:h2d.Scene) {
	    super(scene);

        final expBoost = new BoostButton(this, 'Double EXP', false, "300 SDH");
        expBoost.setScale(0.6);
        expBoost.setPosition(
            BasicScene.ActualScreenWidth / 2 - (expBoost.getWidth() /2 * 0.6),
            200
        );

        final lootBoost = new BoostButton(this, '25% more LOOT', false, "300 SDH");
        lootBoost.setScale(0.6);
        lootBoost.setPosition(
            BasicScene.ActualScreenWidth / 2 - (expBoost.getWidth() /2 * 0.6),
            380
        );
    }

    public function update(dt:Float) {
    }

}