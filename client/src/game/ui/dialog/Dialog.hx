package game.ui.dialog;

import h2d.Object;

import game.ui.button.Button;
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
        final backgroundTile = h2d.Tile.fromColor(0x000000, DeviceInfo.ActualScreenWidth, DeviceInfo.ActualScreenHeight, 0.7);
        addChild(new h2d.Bitmap(backgroundTile));

        // Dialog type
        var dialogBmp:h2d.Bitmap;
        switch (dialogType) {
            case SMALL:
                dialogBmp = new h2d.Bitmap(Res.instance.getTileResource(SeidhResource.UI_DIALOG_WINDOW_SMALL));
            case MEDIUM:
                dialogBmp = new h2d.Bitmap(Res.instance.getTileResource(SeidhResource.UI_DIALOG_WINDOW_MEDIUM));
        }
        dialogBmp.setPosition(
            DeviceInfo.ActualScreenWidth / 2,
            DeviceInfo.ActualScreenHeight / 2,
        );
        addChild(dialogBmp);

        if (textHeader != null) {
            final tfLine = TextUtils.GetDefaultTextObject(0, 0, textHeader.scale, Center, textHeader.color);
            tfLine.text = textHeader.label;
            tfLine.setPosition(
                DeviceInfo.ActualScreenWidth / 2,
                DeviceInfo.ActualScreenHeight / 2 - 200,
            );
            addChild(tfLine);
        }

        // Line by line text
        final fui = new h2d.Flow(this);
		fui.layout = Vertical;
		fui.verticalSpacing = 25;
        fui.setPosition(
            DeviceInfo.ActualScreenWidth / 2,
            DeviceInfo.ActualScreenHeight / 2 - 120
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

        var buttonPositive:Button = null;
        var buttonNegative:Button = null;

        buttonPositive = new Button(ButtonType.SMALL, buttonParams.positiveLabel, function callback() {
            DialogManager.IsDialogActive = false;
            parent.removeChild(this);
            buttonParams.positiveCallback();
        });
        addChild(buttonPositive);

        if (buttonParams.buttons == ONE) {
            if (dialogType == SMALL) {
                buttonPositive.updatePosition(
                    DeviceInfo.ActualScreenWidth / 2, 
                    DeviceInfo.ActualScreenHeight / 2 + 50
                );
            } else {
                buttonPositive.updatePosition(
                    DeviceInfo.ActualScreenWidth / 2, 
                    DeviceInfo.ActualScreenHeight / 2 + 140
                );
            }
        } else {
            buttonNegative = new Button(ButtonType.SMALL, buttonParams.negativeLabel, function callback() {
                DialogManager.IsDialogActive = false;
                parent.removeChild(this);
                buttonParams.negativeCallback();
            });
            addChild(buttonNegative);

            buttonNegative.updatePosition(
                DeviceInfo.ActualScreenWidth / 2 + 100, 
                DeviceInfo.ActualScreenHeight / 2 + 140
            );

            buttonPositive.updatePosition(
                DeviceInfo.ActualScreenWidth / 2 - 100, 
                DeviceInfo.ActualScreenHeight / 2 + 140
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

        final backgroundTile = h2d.Tile.fromColor(0x000000, DeviceInfo.TargetPortraitScreenWidth, DeviceInfo.TargetPortraitScreenHeight, 0.7);
        addChild(new h2d.Bitmap(backgroundTile));

        final dialogBmp = new h2d.Bitmap(Res.instance.getTileResource(SeidhResource.UI_DIALOG_WINDOW_MEDIUM));
        dialogBmp.setPosition(DeviceInfo.TargetPortraitScreenWidth / 2, DeviceInfo.TargetPortraitScreenHeight / 2);
        addChild(dialogBmp);

        addChild(content);

        final buttonPositive = new Button(ButtonType.SMALL, buttonText, function callback() {
            DialogManager.IsDialogActive = false;
            parent.removeChild(this);
        });
        buttonPositive.updatePosition(
            DeviceInfo.TargetPortraitScreenWidth / 2, 
            DeviceInfo.TargetPortraitScreenHeight / 2 + 160
        );
        addChild(buttonPositive);
    }

}