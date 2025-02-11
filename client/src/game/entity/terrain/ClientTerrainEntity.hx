package game.entity.terrain;

import engine.base.geometry.Rectangle;

class ClientTerrainEntity extends h2d.Bitmap {

    private final id:Int;
    private final terrainType:String;

    public function new(tile:h2d.Tile, id:Int, terrainType:String) {
        super(tile);

        this.id = id;
        this.terrainType = terrainType;
    }

    public function getId() {
        return id;
    }

    public function getRect() {
        if (terrainType != 'tree') {
            return new Rectangle(x + tile.width / 2, y + tile.height / 2, tile.width, tile.height, 0);
        } else {
            return new Rectangle(x, y, tile.width, tile.height, 0);
        }
    }

    public function getBottomRect() {
        if (terrainType != 'tree') {
            return new Rectangle(x + tile.width / 2, y + tile.height - 30, tile.width, 40, 0);
        } else {
            return new Rectangle(x, y + tile.height / 2 - 30, tile.width, 40, 0);
        }
    }

}