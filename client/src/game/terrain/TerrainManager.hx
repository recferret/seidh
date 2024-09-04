package game.terrain;

import h2d.Tile;
import hxd.res.TiledMap.TiledMapData;

import game.entity.terrain.ClientTerrainEntity;

class  TerrainManager {

    public final terrainArray:Array<ClientTerrainEntity> = new Array();

    public function new(s2d:h2d.Scene) {
        final mapData:TiledMapData = haxe.Json.parse(hxd.Res.seidh_map.entry.getText());
        final tw = mapData.tilewidth;
        final th = mapData.tileheight;
        final mw = mapData.width;
        final mh = mapData.height;

        final terrainEnvTile  = hxd.Res.terrain.TERRAIN_ENV_TILEMAP.toTile();
        final terrainEnvGroup = new h2d.TileGroup(terrainEnvTile, s2d);

        final tiles = [
            for(y in 0 ... Std.int(terrainEnvTile.height / th))
            for(x in 0 ... Std.int(terrainEnvTile.width / tw))
                terrainEnvTile.sub(x * tw, y * th, tw, th)
        ];

        // Draw backgorund as a group
        for(layer in mapData.layers) {
            // iterate on x and y
            for(y in 0 ... mh) for (x in 0 ... mw) {
                // get the tile id at the current position 
                final tid = layer.data[x + y * mw];
                // skip transparent tiles
                if (tid != 0) {
                    // add a tile to the TileGroup
                    if (layer.name == 'env' || layer.name == 'grass') {
                        terrainEnvGroup.add(x * tw, y * th, tiles[tid - 1]);
                    } else if (layer.name == 'trees') {
                        generateTree(s2d, tid, x * tw, y * th);
                    } else if (layer.name == 'ground') {
                        generateGround(s2d, tiles[tid - 1], x * tw, y * th);
                    }
                }
            }
        }
    }

    private function generateTree(s2d:h2d.Scene, tileId:Int, x:Float, y:Float) {
        var tile = hxd.Res.terrain.TERRAIN_TREE_1.toTile();

        if (tileId == 486)
            tile = hxd.Res.terrain.TERRAIN_TREE_2.toTile();
        if (tileId == 487)
            tile = hxd.Res.terrain.TERRAIN_TREE_3.toTile();
        if (tileId == 488) {
            tile = hxd.Res.terrain.TERRAIN_TREE_4.toTile();
        }

        final terrainEntity = new ClientTerrainEntity(s2d, tile);
        terrainEntity.setPosition(x + terrainEntity.tile.width / 2, y - terrainEntity.tile.height / 2);
        terrainArray.push(terrainEntity);
    }

    private function generateGround(s2d:h2d.Scene, tile:Tile, x:Float, y:Float) {
        final terrainEntity = new ClientTerrainEntity(s2d, tile);
        terrainEntity.setPosition(x + terrainEntity.tile.width / 2, y - terrainEntity.tile.height / 2);
        terrainArray.push(terrainEntity);
    }

}