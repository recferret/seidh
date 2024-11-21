package game.ui.text;

import hxd.res.DefaultFont;

class TextUtils {

    public static function GetDefaultTextObject(x:Float, y:Float, scale:Float, textAlign:h2d.Text.Align, textColor:Int) {
        final font : h2d.Font = DefaultFont.get();

        final text = new h2d.Text(font);
        text.textColor = textColor;
        text.dropShadow = { dx : 0.5, dy : 0.5, color : 0x8A783C, alpha : 0.8 };
        text.textAlign = textAlign;
        text.setScale(scale);
        text.setPosition(x, y);

        return text;
    }

}