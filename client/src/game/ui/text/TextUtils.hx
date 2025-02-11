package game.ui.text;

class TextUtils {

    public static function GetDefaultTextObject(x:Float, y:Float, scale:Float, textAlign:h2d.Text.Align, textColor:Int) {
        final font = hxd.Res.font.tnr.toFont();
        final text = new h2d.Text(font);
        text.textColor = textColor;
        text.dropShadow = { dx : 0.5, dy : 0.5, color : 0x8A783C, alpha : 0.8 };
        text.textAlign = textAlign;
        text.setScale(scale);
        text.setPosition(x, y);
        return text;
    }

}