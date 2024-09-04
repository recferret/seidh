package game.ui.dialog;

import h2d.Object;
import hxd.res.DefaultFont;

import game.Res.SeidhResource;

enum abstract DialogType(Int) {
	var SMALL = 1;
	var MEDIUM = 2;
}

class DialogButton extends h2d.Object {

    private final w = 0.0;
    private final h = 0.0;
    private final bmp:h2d.Bitmap;

    public function new(parent:Object, text:String) {
        super(parent);

        bmp = new h2d.Bitmap(Res.instance.getTileResource(SeidhResource.UI_DIALOG_BUTTON_YAY), this);
        h = bmp.tile.height;
        w = bmp.tile.width;

        final font : h2d.Font = DefaultFont.get();
        final tf = new h2d.Text(font);
        tf.text = text;
        tf.textColor = GameConfig.FontColor;
        tf.dropShadow = { dx : 0.5, dy : 0.5, color : 0xFF0000, alpha : 0.8 };
        tf.textAlign = Center;
        tf.setScale(3);
        tf.setPosition(0, -25);

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
        parent:h2d.Object, 
        dialogType:DialogType,
        textTitle:String, 
        textLine1:String,
        textLine2:String, 
        textPositive:String,
        textNegative:String,
        positiveCallback:Void->Void,
        negativeCallback:Void->Void,
    ) {
        super(parent);

        // Shadow background
        final backgroundTile = h2d.Tile.fromColor(0x000000, Main.ActualScreenWidth, Main.ActualScreenHeight, 0.7);
        addChild(new h2d.Bitmap(backgroundTile));

        // Dialog 
        var dialogBmp:h2d.Bitmap;
        switch (dialogType) {
            case SMALL:
                dialogBmp = new h2d.Bitmap(Res.instance.getTileResource(SeidhResource.UI_DIALOG_WINDOW_SMALL));
            case MEDIUM:
                dialogBmp = new h2d.Bitmap(Res.instance.getTileResource(SeidhResource.UI_DIALOG_WINDOW_MEDIUM));
        }
        dialogBmp.setPosition(Main.ActualScreenWidth / 2, Main.ActualScreenHeight / 2);
        addChild(dialogBmp);

        // Line by line text
        final fui = new h2d.Flow(this);
		fui.layout = Vertical;
		fui.verticalSpacing = 25;
        fui.setPosition(
            Main.ActualScreenWidth / 2,
            Main.ActualScreenHeight / 2 - 100
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
            fui.addChild(tfLine2);
        }

        // Positive button
        var buttonPositive:DialogButton = null;
        var interactionPositive:h2d.Interactive = null;

        if (textPositive != null) {
            buttonPositive = new DialogButton(this, textPositive);
            interactionPositive = new h2d.Interactive(buttonPositive.getWidth(), buttonPositive.getHeight());

            interactionPositive.onPush = function(event : hxd.Event) {
                buttonPositive.setScale(0.9);
            }
            interactionPositive.onRelease = function(event : hxd.Event) {
                buttonPositive.setScale(1);
            }
            interactionPositive.onClick = function(event : hxd.Event) {
                interactionPositive.remove();
                parent.removeChild(this);
                if (positiveCallback != null) {
                    positiveCallback();
                }
            }
            addChild(interactionPositive);
        }

        // Negitive button
        if (dialogType != SMALL && textNegative != null) {
            final buttonNegative = new DialogButton(this, textNegative);
            final interactionNegative = new h2d.Interactive(buttonNegative.getWidth(), buttonNegative.getHeight());

            interactionNegative.onPush = function(event : hxd.Event) {
                buttonNegative.setScale(0.9);
            }
            interactionNegative.onRelease = function(event : hxd.Event) {
                buttonNegative.setScale(1);
            }
            interactionNegative.onClick = function(event : hxd.Event) {
                interactionNegative.remove();
                parent.removeChild(this);
                if (negativeCallback != null) {
                    negativeCallback();
                }
            }
            addChild(interactionNegative);

            // Positions
            if (textPositive != null) {
                interactionPositive.setPosition(
                    (Main.ActualScreenWidth / 2 - 100) - buttonPositive.getWidth() / 2,
                    (Main.ActualScreenHeight / 2 + 140) - buttonPositive.getHeight() / 2
                );
                buttonPositive.setPosition(
                    Main.ActualScreenWidth / 2 - 100, 
                    Main.ActualScreenHeight / 2 + 140
                );

                buttonNegative.setPosition(
                    Main.ActualScreenWidth / 2 + 100, 
                    Main.ActualScreenHeight / 2 + 140
                );
                interactionNegative.setPosition(
                    (Main.ActualScreenWidth / 2 + 100) - buttonNegative.getWidth() / 2,
                    (Main.ActualScreenHeight / 2 + 140) - buttonNegative.getHeight() / 2
                );
            } else {
                buttonNegative.setPosition(
                    Main.ActualScreenWidth / 2, 
                    Main.ActualScreenHeight / 2 + 140
                );
                interactionNegative.setPosition(
                    (Main.ActualScreenWidth / 2) - buttonNegative.getWidth() / 2,
                    (Main.ActualScreenHeight / 2 + 140) - buttonNegative.getHeight() / 2
                );
            }
            
            // Title
            final tfTitle = new h2d.Text(font);
            tfTitle.text = textTitle;
            tfTitle.textColor = GameConfig.FontColor;
            tfTitle.dropShadow = { dx : 0.5, dy : 0.5, color : 0xFF0000, alpha : 0.8 };
            tfTitle.textAlign = Center;
            tfTitle.setScale(4);
            tfTitle.setPosition(
                Main.ActualScreenWidth / 2,
                Main.ActualScreenHeight / 2 - 200
            );
            addChild(tfTitle);

        } else if (textPositive != null) {
            interactionPositive.setPosition(
                Main.ActualScreenWidth / 2 - buttonPositive.getWidth() / 2,
                Main.ActualScreenHeight / 2 + 50 - buttonPositive.getHeight() / 2
            );
            buttonPositive.setPosition(
                Main.ActualScreenWidth / 2, 
                Main.ActualScreenHeight / 2 + 50
            );
        }
    }

}