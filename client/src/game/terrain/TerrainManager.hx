package game.terrain;

import engine.base.MathUtils;

class TerrainManager {
    
    final worldSize = 10000;

    final trees = 150;
    final rocks = 100;
    final puddles = 100;
    final fences = 70;
    final weeds = 310;
    final grass = 1600;

    final fence1Tile =  hxd.Res.terrain.fence_1.toTile(); // 121 width
    final fence2Tile =  hxd.Res.terrain.fence_2.toTile(); // 136 width
    final fence3Tile =  hxd.Res.terrain.fence_3.toTile(); // 85 width

    final puddleTile =  hxd.Res.terrain.puddle.toTile();

    final rockTile =  hxd.Res.terrain.rock.toTile();

    final grass1Tile =  hxd.Res.terrain.tile_1.toTile();
    final grass2Tile =  hxd.Res.terrain.tile_2.toTile();
    final grass3Tile =  hxd.Res.terrain.tile_3.toTile();
    final grass4Tile =  hxd.Res.terrain.tile_4.toTile();

    final tree1Tile =  hxd.Res.terrain.tree_1.toTile();
    final tree2Tile =  hxd.Res.terrain.tree_2.toTile();

    final weed1Tile =  hxd.Res.terrain.weed_1.toTile();
    final weed2Tile =  hxd.Res.terrain.weed_2.toTile();

    public function new(s2d:h2d.Scene) {
        for (i in 0...grass) {
            s2d.addChild(generateGrass());
        }

        for (i in 0...fences) {
            s2d.addChild(generateFence());
        }

        for (i in 0...rocks) {
            s2d.addChild(generateRock());
        }

        for (i in 0...puddles) {
            s2d.addChild(generatePuddle());
        }

        for (i in 0...trees) {
            s2d.addChild(generateTree());
        }

        for (i in 0...weeds) {
            s2d.addChild(generateWeed());
        }
    }

    private function generateRock() {
        final rockBitmap = new h2d.Bitmap(rockTile);

        final x = MathUtils.randomIntInRange(1, worldSize);
        final y = MathUtils.randomIntInRange(1, worldSize);

        rockBitmap.setPosition(x, y);

        return rockBitmap;
    }

    private function generatePuddle() {
        final puddleBitmap = new h2d.Bitmap(puddleTile);

        final x = MathUtils.randomIntInRange(1, worldSize);
        final y = MathUtils.randomIntInRange(1, worldSize);

        puddleBitmap.setPosition(x, y);

        return puddleBitmap;
    }

    private function generateTree() {
        final treeBitmap = MathUtils.randomIntInRange(1, 2) == 1 ? new h2d.Bitmap(tree1Tile) : new h2d.Bitmap(tree2Tile);
        
        final x = MathUtils.randomIntInRange(1, worldSize);
        final y = MathUtils.randomIntInRange(1, worldSize);

        treeBitmap.setPosition(x, y);

        return treeBitmap;
    }

    private function generateWeed() {
        final weedBitmap = MathUtils.randomIntInRange(1, 2) == 1 ? new h2d.Bitmap(weed1Tile) : new h2d.Bitmap(weed2Tile);
        
        final x = MathUtils.randomIntInRange(1, worldSize);
        final y = MathUtils.randomIntInRange(1, worldSize);

        weedBitmap.setPosition(x, y);

        return weedBitmap;
    }

    private function generateGrass() {
        final rnd = MathUtils.randomIntInRange(1, 4);

        var grassBitmap:h2d.Bitmap = null;

        if (rnd == 1) {
            grassBitmap = new h2d.Bitmap(grass1Tile);
        }
        if (rnd == 2) {
            grassBitmap = new h2d.Bitmap(grass2Tile);
        }
        if (rnd == 3) {
            grassBitmap = new h2d.Bitmap(grass3Tile);
        }
        if (rnd == 4) {
            grassBitmap = new h2d.Bitmap(grass4Tile);
        }

        final x = MathUtils.randomIntInRange(1, worldSize);
        final y = MathUtils.randomIntInRange(1, worldSize);

        grassBitmap.setPosition(x, y);

        return grassBitmap;
    }

    private function generateFence() {
        final fence = MathUtils.randomIntInRange(1, 2) == 1 ? generateFence1() : generateFence2();

        final x = MathUtils.randomIntInRange(1, worldSize);
        final y = MathUtils.randomIntInRange(1, worldSize);

        fence.setPosition(x, y);

        return fence;
    }

    private function generateFence1() {
        final fenceObject = new h2d.Object();

        final bmp1 = new h2d.Bitmap(fence3Tile);
        final bmp2 = new h2d.Bitmap(fence2Tile);
        final bmp3 = new h2d.Bitmap(fence3Tile);

        bmp2.x = 80;
        bmp2.y = -15;
        bmp3.x = 195;

        fenceObject.addChild(bmp1);
        fenceObject.addChild(bmp2);
        fenceObject.addChild(bmp3);

        return fenceObject;
    }

    private function generateFence2() {
        final fenceObject = new h2d.Object();

        final bmp1 = new h2d.Bitmap(fence3Tile);
        final bmp2 = new h2d.Bitmap(fence2Tile);
        final bmp3 = new h2d.Bitmap(fence1Tile);

        bmp2.x = 80;
        bmp2.y = -15;
        bmp3.x = 195;
        bmp3.y = -32;

        fenceObject.addChild(bmp1);
        fenceObject.addChild(bmp2);
        fenceObject.addChild(bmp3);

        return fenceObject;
    }

}