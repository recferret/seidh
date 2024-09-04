package game.entity.terrain;

import engine.base.geometry.Rectangle;

class ClientTerrainEntity extends h2d.Bitmap {

    public function new(s2d:h2d.Scene, tile:h2d.Tile) {
        super(tile);

        s2d.addChild(this);
    }

    public function getRect() {
        return new Rectangle(x + tile.width / 2, y + tile.height / 2, tile.width, tile.height, 0);
    }

    public function getBottomRect() {
        return new Rectangle(x + tile.width / 2, y + tile.height - 30, tile.width, 40, 0);
    }

}