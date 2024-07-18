package game.scene.home;

import hxd.res.DefaultFont;

import game.scene.base.BasicScene;
import game.Res.SeidhResource;

class BoostButton extends h2d.Object {

    private final w = 0.0;
    private final h = 0.0;
    private final bmp:h2d.Bitmap;

    public function new(parent:h2d.Object, boostLabel:String, owned:Bool, price:String) {
        super(parent);

        final scaleX = 1.6;
        final scaleY = 0.5;
        bmp = new h2d.Bitmap(Res.instance.getTileResource(SeidhResource.UI_DIALOG_WINDOW_SMALL), this);
        bmp.scaleX = scaleX;
        bmp.scaleY = scaleY;
        w = bmp.tile.width * scaleX;
        h = bmp.tile.height * scaleY;

        final font : h2d.Font = DefaultFont.get();
        final tf = new h2d.Text(font);
        tf.text = boostLabel;
        tf.textColor = GameConfig.FontColor;
        tf.dropShadow = { dx : 0.5, dy : 0.5, color : 0xFF0000, alpha : 0.8 };
        tf.textAlign = Center;
        tf.setScale(4);
        tf.setPosition(0, -35);

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

    public function new() {
	    super();

        final expBoost = new BoostButton(this, 'Double EXP', false, "300 SDH");
        expBoost.setPosition(
            Main.ActualScreenWidth / 2 ,
            300
        );

        final lootBoost = new BoostButton(this, '25% more LOOT', false, "300 SDH");
        lootBoost.setPosition(
            Main.ActualScreenWidth / 2,
            470
        );
    }

    public function update(dt:Float) {
    }

}