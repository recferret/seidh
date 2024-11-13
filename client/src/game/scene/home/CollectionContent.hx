package game.scene.home;

import hxd.res.DefaultFont;

import game.js.NativeWindowJS;
import game.sound.SoundManager;
import game.Res.SeidhResource;

class WalletButton extends h2d.Object {

    private final w = 0.0;
    private final h = 0.0;
    private final interaction:h2d.Interactive;

    public function new(parent:h2d.Object, boostLabel:String, type:String) {
        super(parent);

        final scaleX = 1.6;
        final scaleY = 0.5;
        final bmp = new h2d.Bitmap(Res.instance.getTileResource(SeidhResource.UI_DIALOG_WINDOW_SMALL), this);
        bmp.scaleX = scaleX;
        bmp.scaleY = scaleY;
        w = bmp.tile.width * scaleX;
        h = bmp.tile.height * scaleY;

        final font : h2d.Font = DefaultFont.get();
        final tf = new h2d.Text(font);
        tf.text = boostLabel;
        tf.textColor = GameConfig.FontColor;
        tf.dropShadow = { dx : 0.5, dy : 0.5, color : 0xFF0000, alpha : 0.8 };
        tf.textAlign = Center;
        tf.setScale(4);
        tf.setPosition(0, -35);

        addChild(tf);
        
        interaction = new h2d.Interactive(w, h);
        interaction.onPush = function(event : hxd.Event) {
            setScale(0.9);
        }
        interaction.onRelease = function(event : hxd.Event) {
            setScale(1);
        }
        interaction.onClick = function(event : hxd.Event) {
            if (type == 'connect_wallet') {
                NativeWindowJS.trackWalletConnectClick();

                NativeWindowJS.tonConnect(function callback(address:String) {
                    NativeWindowJS.trackWalletConnected(address);
                    Player.instance.saveWalletAddress(address);
                    parent.removeChild(interaction);
                    parent.removeChild(this);
                });
            } else if (type == 'mint_ragnar') {
                NativeWindowJS.trackMintRagnarClick();
                NativeWindowJS.tonMintRagnar();
            } else if (type == 'disconnect_wallet') {
                // TODO analytics
                NativeWindowJS.tonDisconnect(function callback() {
                    trace('Wallet disconnected');
                });
            }

            SoundManager.instance.playButton2();
        }
        parent.addChild(interaction);
    }

    public function setPosTop() {
        setPosition(
            Main.ActualScreenWidth / 2 ,
            400
        );
        interaction.setPosition(
            Main.ActualScreenWidth / 2 - w / 2,
            370 - h / 2
        );
    }

    public function setPosBelowTop() {
        setPosition(
            Main.ActualScreenWidth / 2 ,
            570
        );
        interaction.setPosition(
            Main.ActualScreenWidth / 2 - w / 2,
            570 - h / 2
        );
    }

}

class CollectionContent extends BasicHomeContent {

    public function new() {
		super();

        final buyRagnar = new WalletButton(this, 'Buy Ragnar', 'mint_ragnar');

        if (Player.instance.getWalletAddress() == null) {
            buyRagnar.setPosBelowTop();

            final walletConnect = new WalletButton(this, 'Connect wallet', 'connect_wallet');
            walletConnect.setPosTop();
        } else {
            final walletDisconnect = new WalletButton(this, 'Disconnect wallet', 'disconnect_wallet');
            walletDisconnect.setPosTop();

            buyRagnar.setPosBelowTop();
        }

        final ragnarDudeBitmap = new h2d.Bitmap(Res.instance.getTileResource(SeidhResource.RAGNAR_DUDE), this);
        ragnarDudeBitmap.setPosition(Main.ActualScreenWidth / 2, 770);

        final tf = new h2d.Text(DefaultFont.get());
        tf.text = "2000 / 2000 Ragnars!";
        tf.textColor = GameConfig.FontColor;
        tf.dropShadow = { dx : 0.5, dy : 0.5, color : 0xFF0000, alpha : 0.8 };
        tf.textAlign = Center;
        tf.setScale(4);
        tf.setPosition(Main.ActualScreenWidth / 2, 950);
        addChild(tf);
    }

    public function update(dt:Float) {
    }

}