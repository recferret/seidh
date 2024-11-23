package game.ui.dialog;

import h2d.Object;

import game.ui.text.TextUtils;
import game.Res.SeidhResource;

enum abstract DialogType(Int) {
	var SMALL = 1;
	var MEDIUM = 2;
}

enum abstract Buttons(Int) {
	var ONE = 1;
	var TWO = 2;
}

typedef TextStyle = {
	label:String,
    scale:Float,
    color:Int,
}

typedef ButtonParams = {
    buttons:Buttons,
    positiveLabel:String,
    negativeLabel:String,
    positiveCallback:Void->Void,
    negativeCallback:Void->Void,
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

        final tf = TextUtils.GetDefaultTextObject(0, -25, 3, Center, GameConfig.WhiteFontColor);
        tf.text = text;

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

// TODO dispose the dialog object
class DialogManager {

    public static var IsDialogActive = false;

    public static function ShowDialog(
        parent:h2d.Object, 
        dialogType:DialogType,
        textHeader:TextStyle,
        textLine1:TextStyle,
        textLine2:TextStyle,
        textLine3:TextStyle,
        buttonParams:ButtonParams,
    ) {
        if (!DialogManager.IsDialogActive) {
            DialogManager.IsDialogActive = true;

            new CommonDialog(
                parent,
                dialogType,
                textHeader,
                textLine1,
                textLine2,
                textLine3,
                buttonParams,
            );
        }
    }

    public static function ShowCustomDialog(
        parent:h2d.Object,
        cotnent:h2d.Object,
        buttonText:String,
    ) {
        if (!DialogManager.IsDialogActive) {
            DialogManager.IsDialogActive = true;
            new CustomDialog(
                parent,
                cotnent,
                buttonText
            );
        }
    }
}

private class CommonDialog extends h2d.Object {

    public function new(
        parent:h2d.Object, 
        dialogType:DialogType,
        ?textHeader:TextStyle,
        textLine1:TextStyle,
        ?textLine2:TextStyle,
        ?textLine3:TextStyle,
        buttonParams:ButtonParams,
    ) {
        super(parent);

        // Shadow background
        final backgroundTile = h2d.Tile.fromColor(0x000000, Main.ActualScreenWidth, Main.ActualScreenHeight, 0.7);
        addChild(new h2d.Bitmap(backgroundTile));

        // Dialog type
        var dialogBmp:h2d.Bitmap;
        switch (dialogType) {
            case SMALL:
                dialogBmp = new h2d.Bitmap(Res.instance.getTileResource(SeidhResource.UI_DIALOG_WINDOW_SMALL));
            case MEDIUM:
                dialogBmp = new h2d.Bitmap(Res.instance.getTileResource(SeidhResource.UI_DIALOG_WINDOW_MEDIUM));
        }
        dialogBmp.setPosition(Main.ActualScreenWidth / 2, Main.ActualScreenHeight / 2);
        addChild(dialogBmp);

        if (textHeader != null) {
            final tfLine = TextUtils.GetDefaultTextObject(0, 0, textHeader.scale, Center, textHeader.color);
            tfLine.text = textHeader.label;
            tfLine.setPosition(
                Main.ActualScreenWidth / 2,
                Main.ActualScreenHeight / 2 - 200,
            );
            addChild(tfLine);
        }

        // Line by line text
        final fui = new h2d.Flow(this);
		fui.layout = Vertical;
		fui.verticalSpacing = 25;
        fui.setPosition(
            Main.ActualScreenWidth / 2,
            Main.ActualScreenHeight / 2 - 120
        );

        final tfLine1 = TextUtils.GetDefaultTextObject(0, 0, textLine1.scale, Center, textLine1.color);
        tfLine1.text = textLine1.label;
        fui.addChild(tfLine1);

        if (textLine2 != null) {
            final tfLine2 = TextUtils.GetDefaultTextObject(0, 0, textLine2.scale, Center, textLine2.color);
            tfLine2.text = textLine2.label;
            fui.addChild(tfLine2);
        }

        if (textLine3 != null) {
            final tfLine3 = TextUtils.GetDefaultTextObject(0, 0, textLine3.scale, Center, textLine3.color);
            tfLine3.text = textLine3.label;
            fui.addChild(tfLine3);
        }

        var buttonPositive:DialogButton = null;
        var interactionPositive:h2d.Interactive = null;
        var buttonNegative:DialogButton = null;
        var interactionNegative:h2d.Interactive = null;

        buttonPositive = new DialogButton(this, buttonParams.positiveLabel);
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
            if (buttonParams.positiveCallback != null) {
                buttonParams.positiveCallback();
            }
            DialogManager.IsDialogActive = false;
        }
        addChild(interactionPositive);

        if (buttonParams.buttons == ONE) {
            if (dialogType == SMALL) {
                interactionPositive.setPosition(
                    Main.ActualScreenWidth / 2 - buttonPositive.getWidth() / 2,
                    Main.ActualScreenHeight / 2 + 50 - buttonPositive.getHeight() / 2
                );
                buttonPositive.setPosition(
                    Main.ActualScreenWidth / 2, 
                    Main.ActualScreenHeight / 2 + 50
                );
            } else {
                interactionPositive.setPosition(
                    Main.ActualScreenWidth / 2 - buttonPositive.getWidth() / 2,
                    (Main.ActualScreenHeight / 2 + 140) - buttonPositive.getHeight() / 2
                );
                buttonPositive.setPosition(
                    Main.ActualScreenWidth / 2, 
                    Main.ActualScreenHeight / 2 + 140
                );
            }
        } else {
            buttonNegative = new DialogButton(this, buttonParams.negativeLabel);
            interactionNegative = new h2d.Interactive(buttonNegative.getWidth(), buttonNegative.getHeight());

            interactionNegative.onPush = function(event : hxd.Event) {
                buttonNegative.setScale(0.9);
            }
            interactionNegative.onRelease = function(event : hxd.Event) {
                buttonNegative.setScale(1);
            }
            interactionNegative.onClick = function(event : hxd.Event) {
                interactionNegative.remove();
                parent.removeChild(this);
                if (buttonParams.negativeCallback != null) {
                    buttonParams.negativeCallback();
                }
                DialogManager.IsDialogActive = false;
            }
            addChild(interactionNegative);

            buttonNegative.setPosition(
                Main.ActualScreenWidth / 2 + 100, 
                Main.ActualScreenHeight / 2 + 140
            );
            interactionNegative.setPosition(
                (Main.ActualScreenWidth / 2 + 100) - buttonNegative.getWidth() / 2,
                (Main.ActualScreenHeight / 2 + 140) - buttonNegative.getHeight() / 2
            );

            interactionPositive.setPosition(
                (Main.ActualScreenWidth / 2 - 100) - buttonPositive.getWidth() / 2,
                (Main.ActualScreenHeight / 2 + 140) - buttonPositive.getHeight() / 2
            );
            buttonPositive.setPosition(
                Main.ActualScreenWidth / 2 - 100, 
                Main.ActualScreenHeight / 2 + 140
            );
        }
    }

}

private class CustomDialog extends h2d.Object { 

    public function new(
        parent:h2d.Object,
        content:h2d.Object,
        buttonText:String,
    ) {
        super(parent);

        final backgroundTile = h2d.Tile.fromColor(0x000000, Main.ActualScreenWidth, Main.ActualScreenHeight, 0.7);
        addChild(new h2d.Bitmap(backgroundTile));

        final dialogBmp = new h2d.Bitmap(Res.instance.getTileResource(SeidhResource.UI_DIALOG_WINDOW_MEDIUM));
        dialogBmp.setPosition(Main.ActualScreenWidth / 2, Main.ActualScreenHeight / 2);
        addChild(dialogBmp);

        addChild(content);

        var buttonPositive:DialogButton = null;
        var interactionPositive:h2d.Interactive = null;

        buttonPositive = new DialogButton(this, buttonText);
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
            DialogManager.IsDialogActive = false;
        }

        interactionPositive.setPosition(
            Main.ActualScreenWidth / 2 - buttonPositive.getWidth() / 2,
            Main.ActualScreenHeight / 2 + 160 - buttonPositive.getHeight() / 2
        );
        buttonPositive.setPosition(
            Main.ActualScreenWidth / 2, 
            Main.ActualScreenHeight / 2 + 160
        );

        addChild(interactionPositive);
    }

}