package game.ui.button;

import h2d.Object;

import game.ui.text.TextUtils;
import game.Res.SeidhResource;

enum abstract ButtonType(Int) {
	var SMALL = 1;
	var BIG = 2;
}

class Button extends h2d.Object {

    private final buttonBitmap:h2d.Bitmap;
    private final inactiveTile:h2d.Tile;
    private final activeTile:h2d.Tile;

    private var inactiveTileHorizontalPadding = 0;
    private var inactiveTileVerticalPadding = 0;

    private final buttonInteractive:h2d.Interactive;

    public function new(buttonType:ButtonType, text:String, callback:Void->Void) {
        super();

        if (buttonType == ButtonType.SMALL) {
            inactiveTileHorizontalPadding =  13;
            inactiveTileVerticalPadding =  11;

            inactiveTile = Res.instance.getTileResource(SeidhResource.UI_BUTTON_SMALL_NAY);
            activeTile = Res.instance.getTileResource(SeidhResource.UI_BUTTON_SMALL_YAY);
        } else {
            inactiveTileHorizontalPadding = 60;
            inactiveTileVerticalPadding = 50;

            inactiveTile = Res.instance.getTileResource(SeidhResource.UI_BUTTON_BIG_NAY);
            activeTile = Res.instance.getTileResource(SeidhResource.UI_BUTTON_BIG_YAY);
        }

        buttonBitmap = new h2d.Bitmap(inactiveTile);
        addChild(buttonBitmap);

        final tf = TextUtils.GetDefaultTextObject(
            0,
            buttonType == ButtonType.SMALL ? -20 : -30,
            buttonType == ButtonType.SMALL ? 1 : 1.5,
            Center,
            GameClientConfig.WhiteFontColor
        );
        tf.text = text;
        addChild(tf);

        buttonInteractive = new h2d.Interactive(
            buttonBitmap.tile.width - (inactiveTileHorizontalPadding * 2),
            buttonBitmap.tile.height - (inactiveTileVerticalPadding * 2),
        );

        buttonInteractive.onClick = function(event : hxd.Event) {
            haxe.Timer.delay(function delay() {
                setScale(1.05);
                buttonBitmap.tile = activeTile;
            }, 100);

            haxe.Timer.delay(function delay() {
                setScale(1);
                buttonBitmap.tile = inactiveTile;
            }, 200);

            haxe.Timer.delay(function delay() {
                if (callback != null) {
                    callback();
                }
            }, 250);
        }
        addChild(buttonInteractive);
    }

    public function updatePosition(x:Float, y:Float) {
        setPosition(x, y);

        buttonInteractive.setPosition(
            buttonBitmap.absX - buttonBitmap.tile.width / 2 + inactiveTileHorizontalPadding, 
            buttonBitmap.absY - buttonBitmap.tile.height / 2 + inactiveTileVerticalPadding,
        );
    }

    public function getHeight() {
        return buttonBitmap.tile.height;
    }

    public function getWidth() {
        return buttonBitmap.tile.width;
    }

}