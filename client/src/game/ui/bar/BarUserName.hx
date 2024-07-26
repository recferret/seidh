package game.ui.bar;

import hxd.res.DefaultFont;

import game.Res.SeidhResource;

class BarUserName extends h2d.Object {

    private final barBmp:h2d.Bitmap;
    private final text:h2d.Text;

    public function new(parent:h2d.Object) {
        super(parent);

        barBmp = new h2d.Bitmap(Res.instance.getTileResource(SeidhResource.UI_GAME_MONEY), this);

        text = new h2d.Text(DefaultFont.get());
        text.text = Player.instance.userName;
        text.textColor = GameConfig.FontColor;
        text.dropShadow = { dx : 0.5, dy : 0.5, color : 0xFF0000, alpha : 0.8 };
        text.textAlign = Center;
        text.setScale(1.8);
        text.setPosition(0, -15);
        addChild(text);
    }

    public function getBitmapWidth() {
        return barBmp.tile.width;
    }

    public function getBitmapHeight() {
        return barBmp.tile.height;
    }

}