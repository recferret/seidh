package game.tilemap;

import game.Res.SeidhResource;
import hxd.res.TiledMap.TiledMapData;

enum abstract TileType(Int) {

    // ---------------------------
    // Consumables
    // ---------------------------

	var POTION_RED = 1;
	var POTION_GREEN = 2;
	var POTION_BLUE = 3;
    var POTION_YELLOW = 4;

    var COIN = 5;
    var SALMON = 6;
    var SWORD = 7;

    // ---------------------------
    // Runes
    // ---------------------------

    var RUNE_TYPE_ANY_LVL_1 = 8;

    var RUNE_TYPE_1_LVL_2 = 9;
    var RUNE_TYPE_1_LVL_3 = 10;

    var RUNE_TYPE_2_LVL_2 = 11;
    var RUNE_TYPE_2_LVL_3 = 12;

    var RUNE_TYPE_3_LVL_2 = 13;
    var RUNE_TYPE_3_LVL_3 = 14;

    var RUNE_TYPE_4_LVL_2 = 15;
    var RUNE_TYPE_4_LVL_3 = 16;

    var RUNE_TYPE_5_LVL_2 = 17;
    var RUNE_TYPE_5_LVL_3 = 18;

    var RUNE_TYPE_6_LVL_2 = 19;
    var RUNE_TYPE_6_LVL_3 = 20;

    // ---------------------------
    // Scrolls
    // ---------------------------

    var SCROLL_TYPE_ANY_LVL_1 = 21;

    var SCROLL_TYPE_1_LVL_2 = 22;
    var SCROLL_TYPE_1_LVL_3 = 23;

    var SCROLL_TYPE_2_LVL_2 = 24;
    var SCROLL_TYPE_2_LVL_3 = 25;

    var SCROLL_TYPE_3_LVL_2 = 26;
    var SCROLL_TYPE_3_LVL_3 = 27;

    // ---------------------------
    // Artifacts
    // ---------------------------

    var ARTIFACT_1 = 28;

    // ---------------------------
    // Icons
    // ---------------------------

    var ICON_BOOST_BLACK = 29;
    var ICON_SKILL_BACKGROUND = 30;
    var ICON_CLOSE = 31;
    var ICON_SCROLL = 32;
    var ICON_BOOST_BROWN = 33;

    // ---------------------------
    // Skills
    // ---------------------------

    var SKILL_ACTION_MAIN = 34;

    // ---------------------------
    // Wealth
    // ---------------------------

    var WEALTH_COINS = 35;
    var WEALTH_TEETH = 36;
    var WEALTH_FRIENDS = 37;
}

class TilemapManager {

    public static final instance:TilemapManager = new TilemapManager();

    private var initiated = false;

    private final tilesMap = new Map<TileType, h2d.Tile>();

	private function new() {
	}

    public function init() {
        if (!initiated) {
            final mapData:TiledMapData = haxe.Json.parse(hxd.Res.seidh_map.entry.getText());
            final tw = mapData.tilewidth;
            final th = mapData.tileheight;
    
            final stufftTilemapTile = Res.instance.getTileResource(SeidhResource.STUFF_TILEMAP);
    
            // Consumables
            tilesMap.set(TileType.POTION_RED, stufftTilemapTile.sub(1 * tw, 0, tw, th).center());
            tilesMap.set(TileType.POTION_GREEN, stufftTilemapTile.sub(2 * tw, 0, tw, th).center());
            tilesMap.set(TileType.POTION_BLUE, stufftTilemapTile.sub(3 * tw, 0, tw, th).center());
            tilesMap.set(TileType.POTION_YELLOW, stufftTilemapTile.sub(4 * tw, 0, tw, th).center());
            tilesMap.set(TileType.SWORD, stufftTilemapTile.sub(5 * tw, 0, tw, th).center());
            tilesMap.set(TileType.SALMON, stufftTilemapTile.sub(6 * tw, 0, tw, th).center());
            tilesMap.set(TileType.COIN, stufftTilemapTile.sub(7 * tw, 0, tw, th).center());

            // Runes
            tilesMap.set(TileType.RUNE_TYPE_ANY_LVL_1, stufftTilemapTile.sub(1 * tw, 1 * th, tw, th).center());
            tilesMap.set(TileType.RUNE_TYPE_1_LVL_2, stufftTilemapTile.sub(2 * tw, 1 * th, tw, th).center());
            tilesMap.set(TileType.RUNE_TYPE_2_LVL_2, stufftTilemapTile.sub(3 * tw, 1 * th, tw, th).center());
            tilesMap.set(TileType.RUNE_TYPE_3_LVL_2, stufftTilemapTile.sub(4 * tw, 1 * th, tw, th).center());
            tilesMap.set(TileType.RUNE_TYPE_4_LVL_2, stufftTilemapTile.sub(5 * tw, 1 * th, tw, th).center());
            tilesMap.set(TileType.RUNE_TYPE_5_LVL_2, stufftTilemapTile.sub(6 * tw, 1 * th, tw, th).center());
            tilesMap.set(TileType.RUNE_TYPE_6_LVL_2, stufftTilemapTile.sub(7 * tw, 1 * th, tw, th).center());
            tilesMap.set(TileType.RUNE_TYPE_1_LVL_3, stufftTilemapTile.sub(8 * tw, 1 * th, tw, th).center());
            tilesMap.set(TileType.RUNE_TYPE_2_LVL_3, stufftTilemapTile.sub(9 * tw, 1 * th, tw, th).center());
            tilesMap.set(TileType.RUNE_TYPE_3_LVL_3, stufftTilemapTile.sub(10 * tw, 1 * th, tw, th).center());
            tilesMap.set(TileType.RUNE_TYPE_4_LVL_3, stufftTilemapTile.sub(11 * tw, 1 * th, tw, th).center());
            tilesMap.set(TileType.RUNE_TYPE_5_LVL_3, stufftTilemapTile.sub(12 * tw, 1 * th, tw, th).center());
            tilesMap.set(TileType.RUNE_TYPE_6_LVL_3, stufftTilemapTile.sub(13 * tw, 1 * th, tw, th).center());

            // Scrolls
            tilesMap.set(TileType.SCROLL_TYPE_ANY_LVL_1, stufftTilemapTile.sub(1 * tw, 2 * th, tw, th).center());
            tilesMap.set(TileType.SCROLL_TYPE_1_LVL_2, stufftTilemapTile.sub(2 * tw, 2 * th, tw, th).center());
            tilesMap.set(TileType.SCROLL_TYPE_2_LVL_2, stufftTilemapTile.sub(3 * tw, 2 * th, tw, th).center());
            tilesMap.set(TileType.SCROLL_TYPE_3_LVL_2, stufftTilemapTile.sub(4 * tw, 2 * th, tw, th).center());
            tilesMap.set(TileType.SCROLL_TYPE_1_LVL_3, stufftTilemapTile.sub(5 * tw, 2 * th, tw, th).center());
            tilesMap.set(TileType.SCROLL_TYPE_2_LVL_3, stufftTilemapTile.sub(6 * tw, 2 * th, tw, th).center());
            tilesMap.set(TileType.SCROLL_TYPE_3_LVL_3, stufftTilemapTile.sub(7 * tw, 2 * th, tw, th).center());

            // Artifacts
            tilesMap.set(TileType.ARTIFACT_1, stufftTilemapTile.sub(1 * tw, 3 * th, tw, th).center());
            
            // Icons
            tilesMap.set(TileType.ICON_BOOST_BLACK, stufftTilemapTile.sub(1 * tw, 4 * th, tw, th).center());
            tilesMap.set(TileType.ICON_SKILL_BACKGROUND, stufftTilemapTile.sub(2 * tw, 4 * th, tw, th).center());
            tilesMap.set(TileType.ICON_CLOSE, stufftTilemapTile.sub(3 * tw, 4 * th, tw, th).center());
            tilesMap.set(TileType.ICON_SCROLL, stufftTilemapTile.sub(4 * tw, 4 * th, tw, th).center());
            tilesMap.set(TileType.ICON_BOOST_BROWN, stufftTilemapTile.sub(5 * tw, 4 * th, tw, th).center());

            // Skills
            tilesMap.set(TileType.SKILL_ACTION_MAIN, stufftTilemapTile.sub(1 * tw, 5 * th, tw, th).center());

            // Wealth
            tilesMap.set(TileType.WEALTH_COINS, stufftTilemapTile.sub(1 * tw, 6 * th, tw, th).center());
            tilesMap.set(TileType.WEALTH_TEETH, stufftTilemapTile.sub(2 * tw, 6 * th, tw, th).center());
            tilesMap.set(TileType.WEALTH_FRIENDS, stufftTilemapTile.sub(3 * tw, 6 * th, tw, th).center());

            initiated = true;
        }
    }

    public function getTile(tileType: TileType) {
        return tilesMap.get(tileType);
    }
}