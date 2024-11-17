package game.scene.impl.home.play;

import game.scene.impl.home.play.dialog.CharacterStatsDialog;
import h2d.filter.Displacement;

import game.js.NativeWindowJS;
import game.Res.SeidhResource;
import game.sound.SoundManager;
import game.event.EventManager;

import motion.Actuate;

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

    private final leftRagnar:h2d.Bitmap;
    private final rightRagnar:h2d.Bitmap;
    private final centralRagnar:h2d.Bitmap;

    private final ragnarBaseTile:h2d.Tile;
    private final ragnarNormTile:h2d.Tile;
    private final ragnarDudeTile:h2d.Tile;

    private final characterStatsDialog:CharacterStatsDialog;

    public function new() {
		super(false);

        characterStatsDialog = new CharacterStatsDialog(this);

        // ------------------------------------
        // Bunnies
        // ------------------------------------

        leftBunny = new Bunny(this);
        leftBunny.setPosition(leftBunny.getWidth(), Main.ActualScreenHeight / 1.55);

        rightBunny = new Bunny(this);
        rightBunny.setPosition(Main.ActualScreenWidth - rightBunny.getWidth(), Main.ActualScreenHeight / 1.55);
        rightBunny.flipX();

        // ------------------------------------
        // Ragnars
        // ------------------------------------

        ragnarBaseTile = Res.instance.getTileResource(SeidhResource.RAGNAR_BASE);
        ragnarNormTile = Res.instance.getTileResource(SeidhResource.RAGNAR_NORM);
        ragnarDudeTile = Res.instance.getTileResource(SeidhResource.RAGNAR_DUDE);

        leftRagnarPosX = 100;
        leftRagnarPosY = Main.ActualScreenHeight / 2.5;
        centralRagnarPosX = Main.ActualScreenWidth / 2;
        centralRagnarPosY = Main.ActualScreenHeight / 2;
        rightRagnarPosX = Main.ActualScreenWidth - ragnarBaseTile.width / 2 - 20;
        rightRagnarPosY = Main.ActualScreenHeight / 2.5;

        leftRagnar = new h2d.Bitmap(ragnarNormTile, this);
        leftRagnar.setPosition(leftRagnarPosX, leftRagnarPosY);

        rightRagnar = new h2d.Bitmap(ragnarDudeTile, this);
        rightRagnar.setPosition(rightRagnarPosX, rightRagnarPosY);

        centralRagnar = new h2d.Bitmap(ragnarBaseTile, this);
        centralRagnar.setPosition(centralRagnarPosX, centralRagnarPosY);

        // ------------------------------------
        // Buttons
        // ------------------------------------

        // Play button
        final playButtonInactiveTile = Res.instance.getTileResource(SeidhResource.UI_HOME_PLAY_NAY);
        final playButtonActiveTile = Res.instance.getTileResource(SeidhResource.UI_HOME_PLAY_YAY);

        final playButton = new h2d.Bitmap(playButtonActiveTile, this);
        playButton.setPosition(
            Main.ActualScreenWidth / 2, 
            340
        );

        final playButtonInteractive = new h2d.Interactive(playButtonActiveTile.width, playButtonActiveTile.height);
        playButtonInteractive.setPosition(
            Main.ActualScreenWidth / 2 - playButtonActiveTile.width / 2, 
            Main.ActualScreenHeight / 5 - playButtonActiveTile.height / 2
        );
        playButtonInteractive.onPush = function(event : hxd.Event) {
            playButton.tile = playButtonInactiveTile;
        }
        playButtonInteractive.onRelease = function(event : hxd.Event) {
            playButton.tile = playButtonActiveTile;
        }
        playButtonInteractive.onClick = function(event : hxd.Event) {
			SoundManager.instance.playButton2();
            NativeWindowJS.trackPlayClick();
            EventManager.instance.notify(EventManager.EVENT_HOME_PLAY, {});
        }
        addChild(playButtonInteractive);

        // Lvl button
        final lvlButtonInactiveTile = Res.instance.getTileResource(SeidhResource.UI_HOME_LVL_NAY);
        final lvlButtonActiveTile = Res.instance.getTileResource(SeidhResource.UI_HOME_LVL_YAY);
        
        final lvlButton = new h2d.Bitmap(lvlButtonActiveTile, this);
        lvlButton.setPosition(
            Main.ActualScreenWidth / 2, 
            Main.ActualScreenHeight * 0.8
        );
        
        final lvlButtonInteractive = new h2d.Interactive(lvlButtonActiveTile.width, lvlButtonActiveTile.height);
        lvlButtonInteractive.setPosition(
            Main.ActualScreenWidth / 2 - lvlButtonActiveTile.width / 2, 
            Main.ActualScreenHeight * 0.8 - lvlButtonActiveTile.height / 2
        );
        lvlButtonInteractive.onPush = function(event : hxd.Event) {
            lvlButton.tile = lvlButtonInactiveTile;
        }
        lvlButtonInteractive.onRelease = function(event : hxd.Event) {
            lvlButton.tile = lvlButtonActiveTile;
        }
        lvlButtonInteractive.onClick = function(event : hxd.Event) {
            characterStatsDialog.show();
            // SoundManager.instance.playButton2();
            // NativeWindowJS.trackLvlUpClick();
        }
        addChild(lvlButtonInteractive);

        // Prev button
        final prevRagnarButton = new h2d.Bitmap(Res.instance.getTileResource(SeidhResource.UI_HOME_ARROW_LEFT), this);
        prevRagnarButton.setPosition(
            prevRagnarButton.tile.width * 1.2,
            Main.ActualScreenHeight / 2
        );
        prevRagnarButton.setScale(1.2);

        final prevRagnarButtonInteractive = new h2d.Interactive(prevRagnarButton.tile.width, prevRagnarButton.tile.height);
        prevRagnarButtonInteractive.setPosition(
            prevRagnarButton.tile.width / 2, 
            Main.ActualScreenHeight / 2 - prevRagnarButton.tile.height / 2
        );
        prevRagnarButtonInteractive.onPush = function(event : hxd.Event) {
            prevRagnarButton.setScale(1);
        }
        prevRagnarButtonInteractive.onRelease = function(event : hxd.Event) {
            prevRagnarButton.setScale(1.2);
        }
        prevRagnarButtonInteractive.onClick = function(event : hxd.Event) {
            switchRagner('left');
        }
        addChild(prevRagnarButtonInteractive);

        // Next button
        final nextRagnarButton = new h2d.Bitmap(Res.instance.getTileResource(SeidhResource.UI_HOME_ARROW_RIGHT), this);
        nextRagnarButton.setPosition(
            Main.ActualScreenWidth - nextRagnarButton.tile.width * 1.2, 
            Main.ActualScreenHeight / 2
        );
        nextRagnarButton.setScale(1.2);

        final nextRagnarButtonInteractive = new h2d.Interactive(nextRagnarButton.tile.width, nextRagnarButton.tile.height);
        nextRagnarButtonInteractive.setPosition(
            Main.ActualScreenWidth - nextRagnarButton.tile.width * 1.5, 
            Main.ActualScreenHeight / 2 - nextRagnarButton.tile.height / 2
        );
        nextRagnarButtonInteractive.onPush = function(event : hxd.Event) {
            nextRagnarButton.setScale(1);
        }
        nextRagnarButtonInteractive.onRelease = function(event : hxd.Event) {
            nextRagnarButton.setScale(1.2);
        }
        nextRagnarButtonInteractive.onClick = function(event : hxd.Event) {
            switchRagner('right');
        }
        addChild(nextRagnarButtonInteractive);
    }

    public function update(dt:Float) {
        leftBunny.update(dt);
        rightBunny.update(dt);
    }

    private function switchRagner(dir:String) {
        SoundManager.instance.playButton2();

        NativeWindowJS.trackChangeCharacterClick();

        if (dir == 'right') {
            // Current is left, after one spin
            if (currentRagnar == 1) {
                Actuate.tween(leftRagnar, 1, { x: rightRagnarPosX, y: rightRagnarPosY });
                Actuate.tween(centralRagnar, 1, { x: leftRagnarPosX, y: leftRagnarPosY });
                Actuate.tween(rightRagnar, 1, { x: centralRagnarPosX, y: centralRagnarPosY });
                currentRagnar = 3;
                return;
            }

            // Current is central, this is also default
            if (currentRagnar == 2) {
                Actuate.tween(leftRagnar, 1, { x: centralRagnarPosX, y: centralRagnarPosY });
                Actuate.tween(centralRagnar, 1, { x: rightRagnarPosX, y: rightRagnarPosY });
                Actuate.tween(rightRagnar, 1, { x: leftRagnarPosX, y: leftRagnarPosY });
                currentRagnar = 1;
                return;
            }

            // Current is right, third spin
            if (currentRagnar == 3) {
                Actuate.tween(leftRagnar, 1, { x: leftRagnarPosX, y: leftRagnarPosY });
                Actuate.tween(centralRagnar, 1, { x: centralRagnarPosX, y: centralRagnarPosY });
                Actuate.tween(rightRagnar, 1, { x: rightRagnarPosX, y: rightRagnarPosY });
                currentRagnar = 2;
                return;
            }
        } else if (dir == 'left') {
            // Current is left, after one spin
            if (currentRagnar == 1) {
                Actuate.tween(leftRagnar, 1, { x: centralRagnarPosX, y: centralRagnarPosY });
                Actuate.tween(centralRagnar, 1, { x: rightRagnarPosX, y: rightRagnarPosY });
                Actuate.tween(rightRagnar, 1, { x: leftRagnarPosX, y: leftRagnarPosY });
                currentRagnar = 3;
                return;
            }

            // Current is central, this is also default
            if (currentRagnar == 2) {
                Actuate.tween(leftRagnar, 1, { x: rightRagnarPosX, y: rightRagnarPosY });
                Actuate.tween(centralRagnar, 1, { x: leftRagnarPosX, y: leftRagnarPosY });
                Actuate.tween(rightRagnar, 1, { x: centralRagnarPosX, y: centralRagnarPosY });
                currentRagnar = 1;
                return;
            }

            // Current is right, third spin
            if (currentRagnar == 3) {
                Actuate.tween(leftRagnar, 1, { x: leftRagnarPosX, y: leftRagnarPosY });
                Actuate.tween(centralRagnar, 1, { x: centralRagnarPosX, y: centralRagnarPosY });
                Actuate.tween(rightRagnar, 1, { x: rightRagnarPosX, y: rightRagnarPosY });
                currentRagnar = 2;
                return;
            }
        }
    }
}