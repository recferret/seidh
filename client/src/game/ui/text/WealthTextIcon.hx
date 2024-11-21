package game.ui.text;

import h2d.Text.Align;
import hxd.res.DefaultFont;

class WealthTextIcon extends h2d.Object {

    private final text:h2d.Text;
    private final icon:h2d.Bitmap;

    public function new(parent:h2d.Object, tile:h2d.Tile, textAlign:Align) {
        super(parent);

        text = TextUtils.GetDefaultTextObject(0, 0, 1.8, textAlign, GameConfig.DefaultFontColor);
        addChild(text);

        icon = new h2d.Bitmap(tile);
        icon.setScale(0.7);
        addChild(icon);

        if (textAlign == Right) {
            text.setPosition(-30, -6);
        } else {
            text.setPosition(34, -6);
        }
    }

    public function setText(s:String) { 
        text.text = s;
    }

}