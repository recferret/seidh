package game.scene.home;

import h2d.BlendMode;
import h2d.filter.Displacement;
import h2d.filter.Mask;
import game.scene.base.BasicScene;

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

    public function new(scene:h2d.Scene) {
		super(scene);

        final textPlayersOnline = new h2d.Text(hxd.res.DefaultFont.get(), this);
		textPlayersOnline.setPosition(15, 15);
		textPlayersOnline.text = 'Play';
		textPlayersOnline.setScale(2);

        // Grass
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

        // Puddle
        final puddleTile =  hxd.Res.terrain.puddle.toTile();

        final puddle1 = new h2d.Bitmap(puddleTile, this);
        puddle1.setPosition(BasicScene.ActualScreenWidth - puddleTile.width * 0.7, 480);

        // Bunnies
        leftBunny = new Bunny(this, false);
        leftBunny.setPosition(leftBunny.getWidth() / 2, BasicScene.ActualScreenHeight / 1.55);

        rightBunny = new Bunny(this, true);
        rightBunny.setPosition(BasicScene.ActualScreenWidth - rightBunny.getWidth() / 2, BasicScene.ActualScreenHeight / 1.55);

        // Trees
        final tree1Tile =  hxd.Res.terrain.tree_1.toTile().center();
        final tree2Tile =  hxd.Res.terrain.tree_2.toTile().center();

        final tree1 = new h2d.Bitmap(tree1Tile, this);
        tree1.setPosition(100, 150);

        final tree2 = new h2d.Bitmap(tree2Tile, this);
        tree2.setPosition(BasicScene.ActualScreenWidth - tree2Tile.width / 3, 200);

        final tree3 = new h2d.Bitmap(tree2Tile, this);
        tree3.setPosition(70, BasicScene.ActualScreenHeight - tree2Tile.height * 0.7);

        // Fence
        final fence1Tile =  hxd.Res.terrain.fence_1.toTile();
        final fence2Tile =  hxd.Res.terrain.fence_2.toTile();

        final fence1 = new h2d.Bitmap(fence1Tile, this);
        fence1.setPosition(BasicScene.ActualScreenWidth - fence1Tile.width, BasicScene.ActualScreenHeight / 1.44);
        final fence2 = new h2d.Bitmap(fence2Tile, this);
        fence2.setPosition(BasicScene.ActualScreenWidth - fence1Tile.width * 2 + 5, BasicScene.ActualScreenHeight / 1.44 + 16);


        // Ragnars
        final leftRagnar = new h2d.Bitmap(hxd.Res.ragnar.ragnar_loh.toTile().center(), this);
        leftRagnar.setPosition(100, BasicScene.ActualScreenHeight / 2.5);

        final rightRagnar = new h2d.Bitmap(hxd.Res.ragnar.ragnar_loh.toTile().center(), this);
        rightRagnar.setPosition(BasicScene.ActualScreenWidth - rightRagnar.tile.width / 1.8, BasicScene.ActualScreenHeight / 2.5);

        final centralRagnar = new h2d.Bitmap(hxd.Res.ragnar.ragnar_norm.toTile().center(), this);
        centralRagnar.setPosition(BasicScene.ActualScreenWidth / 2, BasicScene.ActualScreenHeight / 2);
        centralRagnar.setScale(1.1);

        // Shadow
        final screenShadow = new h2d.Bitmap(hxd.Res.ui.home.mm_shadow.toTile(), this);
        final scaleFactor = BasicScene.ActualScreenHeight / 1280;

        screenShadowDisplacementTile = hxd.Res.normalmap.toTile();
        screenShadow.filter = new Displacement(screenShadowDisplacementTile, 1, 3);

        screenShadow.scaleX = scaleFactor;
		screenShadow.scaleY = scaleFactor;
        screenShadow.setPosition(-((screenShadow.tile.width * (scaleFactor - 1)) / 2), 0);

        // Buttons
    }

    public function update(dt:Float) {
        // 
        // trace('update');

        screenShadowDisplacementTile.scrollDiscrete(1 * dt, 7 * dt);
        leftBunny.update(dt);
        rightBunny.update(dt);
    }
}