package game.ui.bar;

import game.tilemap.TilemapManager;
import game.ui.text.TextUtils;
import game.Res.SeidhResource;

import motion.Actuate;

class IconBar extends h2d.Object {

    private final barBmp:h2d.Bitmap;
    private final textObject:h2d.Text;

    public function new(defaultText:String) {
        super();

        barBmp = new h2d.Bitmap(Res.instance.getTileResource(SeidhResource.UI_GAME_BAR));
        addChild(barBmp);

        final iconBmp = new h2d.Bitmap(TilemapManager.instance.getTile(TileType.WEALTH_COINS));
        iconBmp.setScale(0.7);
        iconBmp.setPosition(barBmp.tile.width / 2 - 30, 0);
        addChild(iconBmp);

        textObject = TextUtils.GetDefaultTextObject(0, -13, 0.8, Center, GameClientConfig.DefaultFontColor);
        textObject.text = defaultText;
        addChild(textObject);
    }

    public function updateText(text:String) {
        textObject.text = text;
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