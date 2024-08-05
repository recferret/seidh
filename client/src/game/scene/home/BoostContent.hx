package game.scene.home;

import hxd.res.DefaultFont;

import game.Res.SeidhResource;

class BoostButton extends h2d.Object {

    private final w = 0.0;
    private final h = 0.0;
    private final bmp:h2d.Bitmap;

    public function new(parent:h2d.Object, label:String, description:String, price:Int, owned:Bool) {
        super(parent);

        final scaleX = 0.7;
        final scaleY = 0.7;
        bmp = new h2d.Bitmap(Res.instance.getTileResource(SeidhResource.UI_DIALOG_WINDOW_SMALL), this);
        bmp.scaleX = scaleX;
        bmp.scaleY = scaleY;
        w = bmp.tile.width * scaleX;
        h = bmp.tile.height * scaleY;

        final font : h2d.Font = DefaultFont.get();
        final tf = new h2d.Text(font);
        tf.text = label;
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

        for (index => boost in Player.instance.boosts) {
            final boostButton = new BoostButton(this, boost.name, boost.description, boost.price, boost.accquired);

            switch (index) {
                case 0:
                    boostButton.setPosition(215, 400);
                case 1:
                    boostButton.setPosition(Main.ActualScreenWidth - 215, 400);
                case 2:
                    boostButton.setPosition(215, 600);
                case 3:
                    boostButton.setPosition(Main.ActualScreenWidth - 215, 600);
                case 4:
                    boostButton.setPosition(215, 800);
                case 5:
                    boostButton.setPosition(Main.ActualScreenWidth - 215, 800);
            }
        }
    }

    public function update(dt:Float) {
    }

}