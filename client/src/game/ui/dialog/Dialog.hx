package game.ui.dialog;

import h2d.Object;
import hxd.res.DefaultFont;
import game.scene.base.BasicScene;

enum abstract DialogType(Int) {
	var SMALL = 1;
	var MEDIUM = 2;
    var BIG = 2;
}

class DialogButton extends h2d.Object {

    private final w = 0.0;
    private final h = 0.0;
    private final bmp:h2d.Bitmap;

    public function new(parent:Object, s2d:h2d.Scene, text:String) {
        super(parent);

        // TODO replace toTile by center later
        bmp = new h2d.Bitmap(hxd.Res.ui.dialog.dialog_button.toTile(), this);
        h = bmp.tile.height;
        w = bmp.tile.width;

        final font : h2d.Font = DefaultFont.get();
        final tf = new h2d.Text(font);
        tf.text = text;
        tf.textColor = GameConfig.FontColor;
        tf.dropShadow = { dx : 0.5, dy : 0.5, color : 0xFF0000, alpha : 0.8 };
        tf.textAlign = Center;
        tf.setScale(3);
        tf.setPosition(w / 2, (h - (tf.textHeight * 3)) / 2);

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

class Dialog extends h2d.Object {

    public function new(
        s2d:h2d.Scene, 
        dialogType:DialogType, 
        textLine1:String,
        textLine2:String, 
        okClickCallback:Void->Void
    ) {
        super(s2d);

        // Backround
        final background = new h2d.Bitmap(hxd.Res.ui.home.mm_shadow_2.toTile(), this);
        final scaleFactor = BasicScene.ActualScreenHeight / 1280;
        background.scaleX = scaleFactor;
		background.scaleY = scaleFactor;
        background.setPosition(-((background.tile.width * (scaleFactor - 1)) / 2), 0);

        // Dialog 
        var dialogBmp:h2d.Bitmap;
        switch (dialogType) {
            case SMALL:
                dialogBmp = new h2d.Bitmap(hxd.Res.ui.dialog.dialog_small.toTile().center(), this);
            case MEDIUM:
                dialogBmp = new h2d.Bitmap(hxd.Res.ui.dialog.dialog_medium.toTile().center(), this);
            case BIG:
                dialogBmp = new h2d.Bitmap(hxd.Res.ui.dialog.dialog_big.toTile().center(), this);
        }
        dialogBmp.setPosition(BasicScene.ActualScreenWidth / 2, BasicScene.ActualScreenHeight / 2);

        // Line by line text
        final fui = new h2d.Flow(this);
		fui.layout = Vertical;
		fui.verticalSpacing = 5;

        fui.setPosition(
            BasicScene.ActualScreenWidth / 2,
            BasicScene.ActualScreenHeight / 2.6
        );

        final font : h2d.Font = DefaultFont.get();
        final tfLine1 = new h2d.Text(font);
        tfLine1.text = textLine1;
        tfLine1.textColor = GameConfig.FontColor;
        tfLine1.dropShadow = { dx : 0.5, dy : 0.5, color : 0xFF0000, alpha : 0.8 };
        tfLine1.textAlign = Center;
        tfLine1.setScale(3);

        fui.addChild(tfLine1);

        if (textLine2 != null) {
            final tfLine2 = new h2d.Text(font);
            tfLine2.text = textLine2;
            tfLine2.textColor = GameConfig.FontColor;
            tfLine2.dropShadow = { dx : 0.5, dy : 0.5, color : 0xFF0000, alpha : 0.8 };
            tfLine2.textAlign = Center;
            tfLine2.setScale(3);
            // tfLine2.setPosition(
            //     BasicScene.ActualScreenWidth / 2,
            //     BasicScene.ActualScreenHeight / 2.6
            // );
            fui.addChild(tfLine2);
        }

        // Ok button
        final buttonOk = new DialogButton(this, s2d, "OK");
        buttonOk.setPosition(
            BasicScene.ActualScreenWidth / 2 - (buttonOk.getWidth() / 2), 
            BasicScene.ActualScreenHeight / 2 + (buttonOk.getHeight() / 2.2)
        );

        final interactionOk = new h2d.Interactive(buttonOk.getWidth(), buttonOk.getHeight(), buttonOk.getBitmap());
        interactionOk.onPush = function(event : hxd.Event) {
            buttonOk.setScale(0.9);
        }
        interactionOk.onRelease = function(event : hxd.Event) {
            buttonOk.setScale(1);
        }
        interactionOk.onClick = function(event : hxd.Event) {
            interactionOk.remove();
            s2d.removeChild(this);
            if (okClickCallback != null) {
                okClickCallback();
            }
        }
    }

}