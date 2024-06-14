package game.scene.home;

import game.js.NativeWindowJS;
import game.scene.base.BasicScene;
import hxd.res.DefaultFont;

class CollectionButton extends h2d.Object {

    private final w = 0.0;
    private final h = 0.0;
    private final bmp:h2d.Bitmap;

    public function new(parent:h2d.Object, boostLabel:String) {
        super(parent);

        bmp = new h2d.Bitmap(hxd.Res.ui.dialog.dialog_small.toTile(), this);
        h = bmp.tile.height;
        w = bmp.tile.width;

        final font : h2d.Font = DefaultFont.get();
        final tf = new h2d.Text(font);
        tf.text = boostLabel;
        tf.textColor = GameConfig.FontColor;
        tf.dropShadow = { dx : 0.5, dy : 0.5, color : 0xFF0000, alpha : 0.8 };
        tf.textAlign = Center;
        tf.setScale(5);
        tf.setPosition(w / 2, (h - (tf.textHeight * 5)) / 2);

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

class CollectionContent extends BasicHomeContent {

    public function new(scene:h2d.Scene) {
		    super(scene);

            final walletConnect = new CollectionButton(this, 'Connect wallet');
            walletConnect.setScale(0.6);
            walletConnect.setPosition(
                BasicScene.ActualScreenWidth / 2 - (walletConnect.getWidth() /2 * 0.6),
                200
            );
    
            final interactionWalletConnect = new h2d.Interactive(walletConnect.getWidth() * 0.6, walletConnect.getHeight() * 0.6);
            interactionWalletConnect.setPosition(
                BasicScene.ActualScreenWidth / 2 - (walletConnect.getWidth() /2 * 0.6),
                200
            );
            interactionWalletConnect.onPush = function(event : hxd.Event) {
                walletConnect.setScale(0.54);
            }
            interactionWalletConnect.onRelease = function(event : hxd.Event) {
                walletConnect.setScale(0.6);
            }
            interactionWalletConnect.onClick = function(event : hxd.Event) {
                NativeWindowJS.tonConnect();
                SceneManager.Sound.playButton2();
            }
            addChild(interactionWalletConnect);

            final buyRagnar = new CollectionButton(this, 'Buy Ragnar',);
            buyRagnar.setScale(0.6);
            buyRagnar.setPosition(
                BasicScene.ActualScreenWidth / 2 - (buyRagnar.getWidth() /2 * 0.6),
                380
            );

            final interactionBuyRagnar = new h2d.Interactive(buyRagnar.getWidth() * 0.6, buyRagnar.getHeight() * 0.6);
            interactionBuyRagnar.setPosition(
                BasicScene.ActualScreenWidth / 2 - (buyRagnar.getWidth() /2 * 0.6),
                380
            );
            interactionBuyRagnar.onPush = function(event : hxd.Event) {
                buyRagnar.setScale(0.54);
            }
            interactionBuyRagnar.onRelease = function(event : hxd.Event) {
                buyRagnar.setScale(0.6);
            }
            interactionBuyRagnar.onClick = function(event : hxd.Event) {
                NativeWindowJS.tonMintRagnar();
                SceneManager.Sound.playButton2();
            }
            addChild(interactionBuyRagnar);


            final ragnarDudeTile = hxd.Res.ragnar.ragnar_dude.toTile().center();
            final ragnarDudeBitmap = new h2d.Bitmap(ragnarDudeTile, this);

            ragnarDudeBitmap.setPosition(BasicScene.ActualScreenWidth / 2, 700);

            final tf = new h2d.Text(DefaultFont.get());
            tf.text = "2000 / 2000 Ragnars!";
            tf.textColor = GameConfig.FontColor;
            tf.dropShadow = { dx : 0.5, dy : 0.5, color : 0xFF0000, alpha : 0.8 };
            tf.textAlign = Center;
            tf.setScale(5);
            tf.setPosition(BasicScene.ActualScreenWidth / 2, 850);
            addChild(tf);


    }

    public function update(dt:Float) {
    }

}