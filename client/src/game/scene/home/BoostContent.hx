package game.scene.home;

import game.js.NativeWindowJS;
import game.ui.dialog.Dialog;
import game.Player.BoostBody;
import game.sound.SoundManager;
import game.Res.SeidhResource;

import hxd.res.DefaultFont;

class BoostButton extends h2d.Object {

    private final w = 0.0;
    private final h = 0.0;
    private final bmp:h2d.Bitmap;

    public function new(parent:h2d.Object, px:Int, py:Int, boost:BoostBody) {
        super(parent);

        final scaleX = 0.7;
        final scaleY = 0.7;
        bmp = new h2d.Bitmap(Res.instance.getTileResource(SeidhResource.UI_DIALOG_WINDOW_SMALL), this);
        bmp.scaleX = scaleX;
        bmp.scaleY = scaleY;
        w = bmp.tile.width * scaleX;
        h = bmp.tile.height * scaleY;

        final font : h2d.Font = DefaultFont.get();
        final tf = new h2d.Text(font);
        tf.text = boost.name;
        tf.textColor = GameConfig.FontColor;
        tf.dropShadow = { dx : 0.5, dy : 0.5, color : 0xFF0000, alpha : 0.8 };
        tf.textAlign = Center;
        tf.setScale(4);
        tf.setPosition(0, -35);

        setPosition(px, py);

        addChild(tf);

        final interaction = new h2d.Interactive(w, h);
        interaction.setPosition(px - w / 2, py - h / 2);

        interaction.onPush = function(event:hxd.Event) {
            if (!DialogManager.IsDialogActive) {
                setScale(0.9);
            }
        }
        interaction.onRelease = function(event:hxd.Event) {
            setScale(1);
        }
        interaction.onClick = function(event:hxd.Event) {
            if (!DialogManager.IsDialogActive) {
                SoundManager.instance.playButton2();

                DialogManager.ShowDialog(
                    parent, 
                    DialogType.MEDIUM, 
                    boost.name,
                    boost.description, 
                    boost.accquired ? "Already accquired" : boost.price + " SDH",
                    boost.accquired ? null : "BUY",
                    boost.accquired ? "OK" : "Cancel",
                    function positiveCallback() {
                        if (Player.instance.tokens - boost.price >= 0) {
                            NativeWindowJS.networkBuyBoost(boost.id, function callback(data:Dynamic) {
                                // TODO show the dialog ok or not ok
                                trace(data);
                            });
                        } else {
                            NativeWindowJS.tgShowAlert('Not enough balance');
                        }
                    },
                    function negativeCallback() {
                    }
                );
            }
        }
        parent.addChild(interaction);

        if (boost.accquired) {
            alpha = 0.9;
        }
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

class BoostContent extends BasicHomeContent {

    public function new() {
	    super();

        for (index => boost in Player.instance.boosts) {
            switch (index) {
                case 0:
                    new BoostButton(this, 215, 400, boost);
                case 1:
                    new BoostButton(this, Main.ActualScreenWidth - 215, 400, boost);
                case 2:
                    new BoostButton(this, 215, 600, boost);
                case 3:
                    new BoostButton(this, Main.ActualScreenWidth - 215, 600, boost);
                case 4:
                    new BoostButton(this,215, 800, boost);
                case 5:
                    new BoostButton(this, Main.ActualScreenWidth - 215, 800, boost);
            }
        }
    }

    public function update(dt:Float) {
    }

    public static function BoostClick(boost:BoostBody) {
        if (boost.accquired) {
            trace('Already accquired');
        } else {
            trace('Check for balance locally');
        }

        // TODO show the dialog

    }

}