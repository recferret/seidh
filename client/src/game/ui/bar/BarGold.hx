package game.ui.bar;

import hxd.res.DefaultFont;

class BarGold extends h2d.Object {

    final barBmp:h2d.Bitmap;

    public function new(s2d:h2d.Scene) {
        super(s2d);

        barBmp = new h2d.Bitmap(hxd.Res.ui.bar_gold.toTile(), this);

        final font : h2d.Font = DefaultFont.get();
        final tf = new h2d.Text(font);
        tf.text = "1234";
        tf.textColor = GameConfig.FontColor;
        tf.dropShadow = { dx : 0.5, dy : 0.5, color : 0xFF0000, alpha : 0.8 };
        tf.textAlign = Center;
        tf.setScale(1.4);

        tf.setPosition(80, 10);

        addChild(tf);
    }

    public function getBitmapWidth() {
        return barBmp.tile.width;
    }

    public function getBitmapHeight() {
        return barBmp.tile.height;
    }

}