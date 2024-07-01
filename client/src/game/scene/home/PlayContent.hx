package game.scene.home;

import game.sound.SoundManager;
import h2d.filter.Displacement;
import game.event.EventManager;
import game.scene.base.BasicScene;
import motion.Actuate;

class Bunny extends h2d.Object {

    private final tileWidth:Float;
    private final displacementTile:h2d.Tile;

    public function new(parent:h2d.Object, flipX:Bool) {
		super(parent);

        final bunny = new h2d.Bitmap(hxd.Res.ui.home.bnuuy_cold.toTile(), this);
        final bunnyFire = new h2d.Bitmap(hxd.Res.ui.home.fire.toTile(), this);

        displacementTile = hxd.Res.normalmap.toTile();
        bunnyFire.filter = new Displacement(displacementTile, 3, 3);

        if (flipX) {
            bunny.tile.flipX();
            bunnyFire.tile.flipX();
        }

        tileWidth = bunny.tile.width;
    }

    public function update(dt:Float) {
        displacementTile.scrollDiscrete(5 * dt, 5 * dt);
    }

    public function getWidth() {
        return tileWidth;
    }
}

class PlayContent extends BasicHomeContent {

    private final leftBunny:Bunny;
    private final rightBunny:Bunny;
    private final screenShadowDisplacementTile:h2d.Tile;

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

    private final ragnarLohTile:h2d.Tile;
    private final ragnarNormTile:h2d.Tile;
    private final ragnarDudeTile:h2d.Tile;

    public function new(scene:h2d.Scene) {
		super(scene);

        // ------------------------------------
        // Grass
        // ------------------------------------

        final grass1Tile =  hxd.Res.terrain.tile_1.toTile().center();
        final grass2Tile =  hxd.Res.terrain.tile_2.toTile().center();
        final grass3Tile =  hxd.Res.terrain.tile_3.toTile().center();
        final grass4Tile =  hxd.Res.terrain.tile_4.toTile().center();

        final grass1 = new h2d.Bitmap(grass1Tile, this);
        grass1.setPosition(100, 300);

        final grass2 = new h2d.Bitmap(grass2Tile, this);
        grass2.setPosition(330, 220);

        final grass3 = new h2d.Bitmap(grass3Tile, this);
        grass3.setPosition(600, 300);

        final grass4 = new h2d.Bitmap(grass4Tile, this);
        grass4.setPosition(600, 900);

        final grass5 = new h2d.Bitmap(grass1Tile, this);
        grass5.setPosition(100, 800);

        final grass6 = new h2d.Bitmap(grass1Tile, this);
        grass6.setPosition(500, 400);

        final grass7 = new h2d.Bitmap(grass1Tile, this);
        grass7.setPosition(200, 400);

        final grass8 = new h2d.Bitmap(grass2Tile, this);
        grass8.setPosition(100, BasicScene.ActualScreenHeight - grass2Tile.height);

        final grass9 = new h2d.Bitmap(grass3Tile, this);
        grass9.setPosition(500, BasicScene.ActualScreenHeight - grass2Tile.height);

        final grass10 = new h2d.Bitmap(grass4Tile, this);
        grass10.setPosition(300, BasicScene.ActualScreenHeight - grass2Tile.height * 2);

        // ------------------------------------
        // Puddle
        // ------------------------------------

        final puddleTile =  hxd.Res.terrain.puddle.toTile();

        final puddle1 = new h2d.Bitmap(puddleTile, this);
        puddle1.setPosition(BasicScene.ActualScreenWidth - puddleTile.width * 0.7, 480);

        // ------------------------------------
        // Bunnies
        // ------------------------------------

        leftBunny = new Bunny(this, false);
        leftBunny.setPosition(leftBunny.getWidth() / 2, BasicScene.ActualScreenHeight / 1.55);

        rightBunny = new Bunny(this, true);
        rightBunny.setPosition(BasicScene.ActualScreenWidth - rightBunny.getWidth() / 2, BasicScene.ActualScreenHeight / 1.55);

        // ------------------------------------
        // Trees
        // ------------------------------------

        final tree1Tile =  hxd.Res.terrain.tree_1.toTile().center();
        final tree2Tile =  hxd.Res.terrain.tree_2.toTile().center();

        final tree1 = new h2d.Bitmap(tree1Tile, this);
        tree1.setPosition(100, 150);

        final tree2 = new h2d.Bitmap(tree2Tile, this);
        tree2.setPosition(BasicScene.ActualScreenWidth - tree2Tile.width / 3, 200);

        final tree3 = new h2d.Bitmap(tree2Tile, this);
        tree3.setPosition(70, BasicScene.ActualScreenHeight - tree2Tile.height * 0.7);

        // ------------------------------------
        // Fence
        // ------------------------------------

        final fence1Tile =  hxd.Res.terrain.fence_1.toTile();
        final fence2Tile =  hxd.Res.terrain.fence_2.toTile();

        final fence1 = new h2d.Bitmap(fence1Tile, this);
        fence1.setPosition(BasicScene.ActualScreenWidth - fence1Tile.width, BasicScene.ActualScreenHeight / 1.44);
        final fence2 = new h2d.Bitmap(fence2Tile, this);
        fence2.setPosition(BasicScene.ActualScreenWidth - fence1Tile.width * 2 + 5, BasicScene.ActualScreenHeight / 1.44 + 16);

        // ------------------------------------
        // Ragnars
        // ------------------------------------

        ragnarLohTile = hxd.Res.ragnar.ragnar_loh.toTile().center();
        ragnarNormTile = hxd.Res.ragnar.ragnar_norm.toTile().center();
        ragnarDudeTile = hxd.Res.ragnar.ragnar_dude.toTile().center();

        leftRagnarPosX = 100;
        leftRagnarPosY = BasicScene.ActualScreenHeight / 2.5;
        centralRagnarPosX = BasicScene.ActualScreenWidth / 2;
        centralRagnarPosY = BasicScene.ActualScreenHeight / 2;
        rightRagnarPosX = BasicScene.ActualScreenWidth - ragnarLohTile.width / 2 - 20;
        rightRagnarPosY = BasicScene.ActualScreenHeight / 2.5;

        leftRagnar = new h2d.Bitmap(ragnarNormTile, this);
        leftRagnar.setPosition(leftRagnarPosX, leftRagnarPosY);

        rightRagnar = new h2d.Bitmap(ragnarDudeTile, this);
        rightRagnar.setPosition(rightRagnarPosX, rightRagnarPosY);

        centralRagnar = new h2d.Bitmap(ragnarLohTile, this);
        centralRagnar.setPosition(centralRagnarPosX, centralRagnarPosY);

        // ------------------------------------
        // Shadow
        // ------------------------------------

        final screenShadow = new h2d.Bitmap(hxd.Res.ui.home.mm_shadow.toTile().center(), this);
        final scaleFactor = BasicScene.ActualScreenHeight / 1280;
        final fixedScale = scaleFactor < 1 ? 1.1 : scaleFactor; 
        screenShadowDisplacementTile = hxd.Res.normalmap.toTile();
        screenShadow.filter = new Displacement(screenShadowDisplacementTile, 1, 3);
        screenShadow.scaleX = fixedScale;
		screenShadow.scaleY = fixedScale;
        screenShadow.setPosition(BasicScene.ActualScreenWidth / 2, BasicScene.ActualScreenHeight / 2);

        // NativeWindowJS.debugAlert('Scale: ' + scaleFactor);

        // ------------------------------------
        // Buttons
        // ------------------------------------

        // Play button
        final playButtonInactiveTile = hxd.Res.ui.home.PLAY_nay.toTile();
        final playButtonActiveTile = hxd.Res.ui.home.PLAY_yay.toTile();

        final playButton = new h2d.Bitmap(playButtonActiveTile, this);
        playButton.setPosition(
            BasicScene.ActualScreenWidth / 2 - playButtonActiveTile.width / 2, 
            BasicScene.ActualScreenHeight / 5 - playButtonActiveTile.height / 2
        );

        final playButtonInteractive = new h2d.Interactive(playButtonActiveTile.width, playButtonActiveTile.height, playButton);
        playButtonInteractive.onPush = function(event : hxd.Event) {
            playButton.tile = playButtonInactiveTile;
        }
        playButtonInteractive.onRelease = function(event : hxd.Event) {
            playButton.tile = playButtonActiveTile;
        }
        playButtonInteractive.onClick = function(event : hxd.Event) {
            EventManager.instance.notify(EventManager.EVENT_HOME_PLAY, {});
			SoundManager.instance.playButton2();
        }

        // Play button
        final lvlButtonInactiveTile = hxd.Res.ui.home.LVL_nay.toTile();
        final lvlButtonActiveTile = hxd.Res.ui.home.LVL_yay.toTile();
        
        final lvlButton = new h2d.Bitmap(lvlButtonActiveTile, this);
        lvlButton.setPosition(
            BasicScene.ActualScreenWidth / 2 - lvlButtonActiveTile.width / 2, 
            BasicScene.ActualScreenHeight * 0.8 - lvlButtonActiveTile.height / 2
        );
        
        final lvlButtonInteractive = new h2d.Interactive(lvlButtonActiveTile.width, lvlButtonActiveTile.height, lvlButton);
        lvlButtonInteractive.onPush = function(event : hxd.Event) {
            lvlButton.tile = lvlButtonInactiveTile;
        }
        lvlButtonInteractive.onRelease = function(event : hxd.Event) {
            lvlButton.tile = lvlButtonActiveTile;
        }
        lvlButtonInteractive.onClick = function(event : hxd.Event) {
            
        }

        // Prev button
        final prevRagnarButton = new h2d.Bitmap(hxd.Res.ui.home.arrow_left.toTile(), this);
        prevRagnarButton.setPosition(
            prevRagnarButton.tile.width / 2, 
            BasicScene.ActualScreenHeight / 2 - prevRagnarButton.tile.height / 2
        );

        final prevRagnarButtonInteractive = new h2d.Interactive(prevRagnarButton.tile.width, prevRagnarButton.tile.height, prevRagnarButton);
        prevRagnarButtonInteractive.onPush = function(event : hxd.Event) {
            prevRagnarButton.setScale(1.2);
        }
        prevRagnarButtonInteractive.onRelease = function(event : hxd.Event) {
            prevRagnarButton.setScale(1);
        }
        prevRagnarButtonInteractive.onClick = function(event : hxd.Event) {
            switchRagner('left');
        }

        // Next button
        final nextRagnarButton = new h2d.Bitmap(hxd.Res.ui.home.arrow_right.toTile(), this);
        nextRagnarButton.setPosition(
            BasicScene.ActualScreenWidth - nextRagnarButton.tile.width * 1.5, 
            BasicScene.ActualScreenHeight / 2 - nextRagnarButton.tile.height / 2
        );

        final nextRagnarButtonInteractive = new h2d.Interactive(nextRagnarButton.tile.width, nextRagnarButton.tile.height, nextRagnarButton);
        nextRagnarButtonInteractive.onPush = function(event : hxd.Event) {
            nextRagnarButton.setScale(1.2);
        }
        nextRagnarButtonInteractive.onRelease = function(event : hxd.Event) {
            nextRagnarButton.setScale(1);
        }
        nextRagnarButtonInteractive.onClick = function(event : hxd.Event) {
            switchRagner('right');
        }
    }

    public function update(dt:Float) {
        screenShadowDisplacementTile.scrollDiscrete(1 * dt, 7 * dt);
        leftBunny.update(dt);
        rightBunny.update(dt);
    }

    private function switchRagner(dir:String) {
        SoundManager.instance.playButton2();

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