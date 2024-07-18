package game.entity.terrain;

import engine.base.geometry.Rectangle;

import game.scene.impl.GameScene;

enum TerrainType {
    ROCK;
    TREE;
    FENCE;
    WEED;
}

class ClientTerrainEntity extends h2d.Bitmap {

    private final terrainType:TerrainType;

    public function new(s2d:h2d.Scene, terrainType:TerrainType, tile:h2d.Tile) {
        super(tile);

        this.terrainType = terrainType;

        s2d.add(this, 0, GameScene.TERRAIN_LAYER);
    }

    public function getRect() {
        return new Rectangle(x, y, tile.width, tile.height, 0);
    }

    public function getBottomRect() {
        // switch (terrainType) {
        //     case ROCK:
        //         return new Rectangle(x, y + tile.height / 2 - 30, tile.width, 40, 0);
        //     case TREE:
        //         return new Rectangle(x, y + tile.height / 2 - 30, tile.width, 40, 0);
        //     case FENCE:
        //         return new Rectangle(x, y + tile.height / 2 - 30, tile.width, 40, 0);
            // case WEED:
                return new Rectangle(x, y + tile.height / 2 - 30, tile.width, 40, 0);
        // }
    }

}