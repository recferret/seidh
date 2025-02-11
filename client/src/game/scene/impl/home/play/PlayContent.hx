package game.scene.impl.home.play;

import game.ui.button.Button;
import game.ui.bar.FilledBar;
import game.analytics.Analytics;
import h2d.filter.Displacement;

import game.scene.impl.home.play.dialog.CharacterStatsDialogContent.CharacterStatsDialog;
import game.ui.dialog.Dialog.DialogManager;

import game.js.NativeWindowJS;
import game.Res.SeidhResource;
import game.sound.SoundManager;
import game.event.EventManager;

class Bunny extends h2d.Object {

    private final bunnyBmp:h2d.Bitmap;
    private final fireBmp:h2d.Bitmap;
    private final displacementTile:h2d.Tile;

    public function new(parent:h2d.Object) {
		super(parent);

        bunnyBmp = new h2d.Bitmap(Res.instance.getTileResource(SeidhResource.UI_HOME_BUNNY), this);
        fireBmp = new h2d.Bitmap(Res.instance.getTileResource(SeidhResource.UI_HOME_BUNNY_FIRE), this);

        displacementTile = Res.instance.getTileResource(SeidhResource.FX_NORMALMAP);
        fireBmp.filter = new Displacement(displacementTile, 3, 3);
    }

    public function update(dt:Float) {
        displacementTile.scrollDiscrete(5 * dt, 5 * dt);
    }

    public function flipX() {
        bunnyBmp.tile.flipX();
        fireBmp.tile.flipX();
    }

    public function getWidth() {
        return bunnyBmp.tile.width;
    }
}

class PlayContent extends BasicHomeContent {

    private final leftBunny:Bunny;
    private final rightBunny:Bunny;

    // 1 - left, 2 - central, 3 - right
    private var leftRagnarPosX = 0.0;
    private var leftRagnarPosY = 0.0;
    private var centralRagnarPosX = 0.0;
    private var centralRagnarPosY = 0.0;
    private var rightRagnarPosX = 0.0;
    private var rightRagnarPosY = 0.0;

    private var currentRagnar = 2;

    // private final leftRagnar:h2d.Bitmap;
    // private final rightRagnar:h2d.Bitmap;
    private final centralRagnar:h2d.Anim;

    private final ragnarBaseTile:h2d.Tile;
    // private final ragnarNormTile:h2d.Tile;
    // private final ragnarDudeTile:h2d.Tile;

    public function new() {
		super(false);

        // ------------------------------------
        // Bunnies
        // ------------------------------------
        leftBunny = new Bunny(this);
        var leftBunnyX = leftBunny.getWidth();
        leftBunny.setPosition(leftBunnyX, DeviceInfo.TargetPortraitScreenHeight / 1.55);

        rightBunny = new Bunny(this);
        var rightBunnyX = DeviceInfo.TargetPortraitScreenWidth - rightBunny.getWidth();
        rightBunny.setPosition(rightBunnyX, DeviceInfo.TargetPortraitScreenHeight / 1.55);
        rightBunny.flipX();

        // ------------------------------------
        // Ragnars
        // ------------------------------------

        ragnarBaseTile = Res.instance.getTileResource(SeidhResource.RAGNAR_IDLE);

        var th = 332;
        var tw = 332;
        final idleTiles = [];

        for(x in 0 ... Std.int(ragnarBaseTile.width / tw)) {
            final tile = ragnarBaseTile.sub(x * tw, 0, tw, th).center();
            tile.dx += 30;
            idleTiles.push(tile);
        }

        // ragnarNormTile = Res.instance.getTileResource(SeidhResource.RAGNAR_NORM);
        // ragnarDudeTile = Res.instance.getTileResource(SeidhResource.RAGNAR_DUDE);

        leftRagnarPosX = 100;
        leftRagnarPosY = DeviceInfo.TargetPortraitScreenHeight / 2.5;
        centralRagnarPosX = DeviceInfo.TargetPortraitScreenWidth / 2;
        centralRagnarPosY = DeviceInfo.TargetPortraitScreenHeight / 2;
        rightRagnarPosX = DeviceInfo.TargetPortraitScreenWidth - ragnarBaseTile.width / 2 - 20;
        rightRagnarPosY = DeviceInfo.TargetPortraitScreenHeight / 2.5;

        // leftRagnar = new h2d.Bitmap(ragnarNormTile, this);
        // leftRagnar.setPosition(leftRagnarPosX, leftRagnarPosY);

        // rightRagnar = new h2d.Bitmap(ragnarDudeTile, this);
        // rightRagnar.setPosition(rightRagnarPosX, rightRagnarPosY);

        // TODO fix copy/paste

        centralRagnar = new h2d.Anim(this);
        centralRagnar.play(idleTiles);
        centralRagnar.speed = 10;

        centralRagnar.setPosition(centralRagnarPosX, centralRagnarPosY);

        // ------------------------------------
        // Play button
        // ------------------------------------

        final playButton = new Button(ButtonType.BIG, 'Play', function callback() {
            if (!DialogManager.IsDialogActive) {
                SoundManager.instance.playButton2();
                NativeWindowJS.trackPlayClick();
                NativeWindowJS.networkGameStart(function gameStartCallback(data:Dynamic) {
                    if (data.success) {
                        Player.instance.currentGameId = data.gameId;
                        EventManager.instance.notify(EventManager.EVENT_HOME_PLAY, {});
                    } else {
                        trace('START GAME ERROR');
                    }
                });
			}
        });
        playButton.updatePosition(
            DeviceInfo.TargetPortraitScreenWidth / 2, 
            340,
        );
        addChild(playButton);

        // ------------------------------------
        // Exp bar
        // ------------------------------------

        final expBar = new FilledBar(GameClientConfig.XpBarColor, true);
        expBar.setPosition(DeviceInfo.TargetPortraitScreenWidth / 2, DeviceInfo.TargetPortraitScreenHeight * 0.68);
        expBar.updateText('Level 0');
        expBar.updateBar(Player.instance.currentCharacter.expCurrent, Player.instance.currentCharacter.expTillNewLevel);
        addChild(expBar);

        // ------------------------------------
        // Char info and level button
        // ------------------------------------

        final charInfoButton = new Button(ButtonType.BIG, 'Info', function callback() {
            if (!DialogManager.IsDialogActive) {
                SoundManager.instance.playButton2();
                Analytics.instance.trackCharacterLvlUpClick();
                // TODO get pos, not hardcode it
                DialogManager.ShowCustomDialog(this, new CharacterStatsDialog(true), 'UP');
			}
        });
        charInfoButton.updatePosition(
            DeviceInfo.TargetPortraitScreenWidth / 2, 
            DeviceInfo.TargetPortraitScreenHeight * 0.75
        );
        addChild(charInfoButton);

        // Prev button
        // final prevRagnarButton = new h2d.Bitmap(Res.instance.getTileResource(SeidhResource.UI_HOME_ARROW_LEFT), this);
        // prevRagnarButton.setPosition(
        //     prevRagnarButton.tile.width * 1.2,
        //     Main.ActualScreenHeight / 2
        // );
        // prevRagnarButton.setScale(1.2);

        // final prevRagnarButtonInteractive = new h2d.Interactive(prevRagnarButton.tile.width, prevRagnarButton.tile.height);
        // prevRagnarButtonInteractive.setPosition(
        //     prevRagnarButton.tile.width / 2, 
        //     Main.ActualScreenHeight / 2 - prevRagnarButton.tile.height / 2
        // );
        // prevRagnarButtonInteractive.onPush = function(event : hxd.Event) {
        //     prevRagnarButton.setScale(1);
        // }
        // prevRagnarButtonInteractive.onRelease = function(event : hxd.Event) {
        //     prevRagnarButton.setScale(1.2);
        // }
        // prevRagnarButtonInteractive.onClick = function(event : hxd.Event) {
        //     switchRagner('left');
        // }
        // addChild(prevRagnarButtonInteractive);

        // Next button
        // final nextRagnarButton = new h2d.Bitmap(Res.instance.getTileResource(SeidhResource.UI_HOME_ARROW_RIGHT), this);
        // nextRagnarButton.setPosition(
        //     Main.ActualScreenWidth - nextRagnarButton.tile.width * 1.2, 
        //     Main.ActualScreenHeight / 2
        // );
        // nextRagnarButton.setScale(1.2);

        // final nextRagnarButtonInteractive = new h2d.Interactive(nextRagnarButton.tile.width, nextRagnarButton.tile.height);
        // nextRagnarButtonInteractive.setPosition(
        //     Main.ActualScreenWidth - nextRagnarButton.tile.width * 1.5, 
        //     Main.ActualScreenHeight / 2 - nextRagnarButton.tile.height / 2
        // );
        // nextRagnarButtonInteractive.onPush = function(event : hxd.Event) {
        //     nextRagnarButton.setScale(1);
        // }
        // nextRagnarButtonInteractive.onRelease = function(event : hxd.Event) {
        //     nextRagnarButton.setScale(1.2);
        // }
        // nextRagnarButtonInteractive.onClick = function(event : hxd.Event) {
        //     switchRagner('right');
        // }
        // addChild(nextRagnarButtonInteractive);
    }

    public function update(dt:Float) {
        leftBunny.update(dt);
        rightBunny.update(dt);
    }

    // private function switchRagner(dir:String) {
    //     SoundManager.instance.playButton2();

    //     NativeWindowJS.trackChangeCharacterClick();

    //     if (dir == 'right') {
    //         // Current is left, after one spin
    //         if (currentRagnar == 1) {
    //             Actuate.tween(leftRagnar, 1, { x: rightRagnarPosX, y: rightRagnarPosY });
    //             Actuate.tween(centralRagnar, 1, { x: leftRagnarPosX, y: leftRagnarPosY });
    //             Actuate.tween(rightRagnar, 1, { x: centralRagnarPosX, y: centralRagnarPosY });
    //             currentRagnar = 3;
    //             return;
    //         }

    //         // Current is central, this is also default
    //         if (currentRagnar == 2) {
    //             Actuate.tween(leftRagnar, 1, { x: centralRagnarPosX, y: centralRagnarPosY });
    //             Actuate.tween(centralRagnar, 1, { x: rightRagnarPosX, y: rightRagnarPosY });
    //             Actuate.tween(rightRagnar, 1, { x: leftRagnarPosX, y: leftRagnarPosY });
    //             currentRagnar = 1;
    //             return;
    //         }

    //         // Current is right, third spin
    //         if (currentRagnar == 3) {
    //             Actuate.tween(leftRagnar, 1, { x: leftRagnarPosX, y: leftRagnarPosY });
    //             Actuate.tween(centralRagnar, 1, { x: centralRagnarPosX, y: centralRagnarPosY });
    //             Actuate.tween(rightRagnar, 1, { x: rightRagnarPosX, y: rightRagnarPosY });
    //             currentRagnar = 2;
    //             return;
    //         }
    //     } else if (dir == 'left') {
    //         // Current is left, after one spin
    //         if (currentRagnar == 1) {
    //             Actuate.tween(leftRagnar, 1, { x: centralRagnarPosX, y: centralRagnarPosY });
    //             Actuate.tween(centralRagnar, 1, { x: rightRagnarPosX, y: rightRagnarPosY });
    //             Actuate.tween(rightRagnar, 1, { x: leftRagnarPosX, y: leftRagnarPosY });
    //             currentRagnar = 3;
    //             return;
    //         }

    //         // Current is central, this is also default
    //         if (currentRagnar == 2) {
    //             Actuate.tween(leftRagnar, 1, { x: rightRagnarPosX, y: rightRagnarPosY });
    //             Actuate.tween(centralRagnar, 1, { x: leftRagnarPosX, y: leftRagnarPosY });
    //             Actuate.tween(rightRagnar, 1, { x: centralRagnarPosX, y: centralRagnarPosY });
    //             currentRagnar = 1;
    //             return;
    //         }

    //         // Current is right, third spin
    //         if (currentRagnar == 3) {
    //             Actuate.tween(leftRagnar, 1, { x: leftRagnarPosX, y: leftRagnarPosY });
    //             Actuate.tween(centralRagnar, 1, { x: centralRagnarPosX, y: centralRagnarPosY });
    //             Actuate.tween(rightRagnar, 1, { x: rightRagnarPosX, y: rightRagnarPosY });
    //             currentRagnar = 2;
    //             return;
    //         }
    //     }
    // }
}