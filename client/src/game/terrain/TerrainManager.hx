package game.terrain;

import h2d.Tile;
import hxd.res.TiledMap.TiledMapData;

import game.entity.terrain.ClientTerrainEntity;
import game.scene.impl.game.GameScene;
import game.Res;

class  TerrainManager {

    public final terrainArray:Array<ClientTerrainEntity> = new Array();

    public function new(s2d:h2d.Scene) {
        final mapData:TiledMapData = haxe.Json.parse(Res.instance.getConfigResource(SeidhResource.CONFIG_SEIDH_MAP));
        final tw = mapData.tilewidth;
        final th = mapData.tileheight;
        final mw = mapData.width;
        final mh = mapData.height;

        final terrainEnvTile = Res.instance.getTileResource(SeidhResource.TERRAIN_ENV_TILEMAP);
        final terrainEnvGroup = new h2d.TileGroup(terrainEnvTile);
        s2d.add(terrainEnvGroup, GameScene.LAYER_GRASS);

        final tiles = [
            for(y in 0 ... Std.int(terrainEnvTile.height / th))
            for(x in 0 ... Std.int(terrainEnvTile.width / tw))
                terrainEnvTile.sub(x * tw, y * th, tw, th)
        ];

        // Draw backgorund as a group
        var index = 0;

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
                        generateTree(s2d, tid, x * tw, y * th, index);
                    } else if (layer.name == 'ground') {
                        generateGround(s2d, tiles[tid - 1], x * tw, y * th, index);
                    }
                    
                    index++;
                }
            }
        }
    }

    private function generateTree(s2d:h2d.Scene, tileId:Int, x:Float, y:Float, id:Int) {
        var tile = Res.instance.getTileResource(SeidhResource.TERRAIN_TREE_1);

        if (tileId == 486)
            tile = Res.instance.getTileResource(SeidhResource.TERRAIN_TREE_2);
        if (tileId == 487)
            tile = Res.instance.getTileResource(SeidhResource.TERRAIN_TREE_3);
        if (tileId == 488) {
            tile = Res.instance.getTileResource(SeidhResource.TERRAIN_TREE_4);
        }

        final terrainEntity = new ClientTerrainEntity(tile, id, 'tree');
        terrainEntity.setPosition(x + terrainEntity.tile.width / 2, y - terrainEntity.tile.height / 2);
        terrainArray.push(terrainEntity);

        s2d.add(terrainEntity, GameScene.LAYER_TREE);
    }

    private function generateGround(s2d:h2d.Scene, tile:Tile, x:Float, y:Float, id:Int) {
        final terrainEntity = new ClientTerrainEntity(tile, id, 'ground');
        terrainEntity.setPosition(x + terrainEntity.tile.width / 2, y - terrainEntity.tile.height / 2);
        terrainArray.push(terrainEntity);

        s2d.add(terrainEntity, GameScene.LAYER_GROUND);
    }

}