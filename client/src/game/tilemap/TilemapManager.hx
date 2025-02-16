package game.tilemap;

import game.Res.SeidhResource;
import hxd.res.TiledMap.TiledMapData;

enum abstract TileType(String) {

    // ---------------------------
    // Consumables
    // ---------------------------

	var POTION_RED = 'POTION_RED';
	var POTION_GREEN = 'POTION_GREEN';
	var POTION_BLUE = 'POTION_BLUE';
    var POTION_YELLOW = 'POTION_YELLOW';

    var COIN = 'COIN';
    var SALMON = 'SALMON';
    var SWORD = 'SWORD';

    // ---------------------------
    // Runes
    // ---------------------------

    var RUNE_TYPE_ANY_LVL_1 = 'RUNE_TYPE_ANY_LVL_1';

    var RUNE_TYPE_1_LVL_2 = 'RUNE_TYPE_1_LVL_2';
    var RUNE_TYPE_1_LVL_3 = 'RUNE_TYPE_1_LVL_3';

    var RUNE_TYPE_2_LVL_2 = 'RUNE_TYPE_2_LVL_2';
    var RUNE_TYPE_2_LVL_3 = 'RUNE_TYPE_2_LVL_3';

    var RUNE_TYPE_3_LVL_2 = 'RUNE_TYPE_3_LVL_2';
    var RUNE_TYPE_3_LVL_3 = 'RUNE_TYPE_3_LVL_3';

    var RUNE_TYPE_4_LVL_2 = 'RUNE_TYPE_4_LVL_2';
    var RUNE_TYPE_4_LVL_3 = 'RUNE_TYPE_4_LVL_3';

    var RUNE_TYPE_5_LVL_2 = 'RUNE_TYPE_5_LVL_2';
    var RUNE_TYPE_5_LVL_3 = 'RUNE_TYPE_5_LVL_3';

    var RUNE_TYPE_6_LVL_2 = 'RUNE_TYPE_6_LVL_2';
    var RUNE_TYPE_6_LVL_3 = 'RUNE_TYPE_6_LVL_3';

    // ---------------------------
    // Scrolls
    // ---------------------------

    var SCROLL_TYPE_ANY_LVL_1 = 'SCROLL_TYPE_ANY_LVL_1';

    var SCROLL_TYPE_1_LVL_2 = 'SCROLL_TYPE_1_LVL_2';
    var SCROLL_TYPE_1_LVL_3 = 'SCROLL_TYPE_1_LVL_3';

    var SCROLL_TYPE_2_LVL_2 = 'SCROLL_TYPE_2_LVL_2';
    var SCROLL_TYPE_2_LVL_3 = 'SCROLL_TYPE_2_LVL_3';

    var SCROLL_TYPE_3_LVL_2 = 'SCROLL_TYPE_3_LVL_2';
    var SCROLL_TYPE_3_LVL_3 = 'SCROLL_TYPE_3_LVL_3';

    // ---------------------------
    // Artifacts
    // ---------------------------

    var ARTIFACT_1 = 'ARTIFACT_1';

    // ---------------------------
    // Icons
    // ---------------------------

    var ICON_BOOST_BLACK = 'ICON_BOOST_BLACK';
    var ICON_SKILL_BACKGROUND = 'ICON_SKILL_BACKGROUND';
    var ICON_CLOSE = 'ICON_CLOSE';
    var ICON_SCROLL = 'ICON_SCROLL';
    var ICON_BOOST_BROWN = 'ICON_BOOST_BROWN';

    // ---------------------------
    // Skills
    // ---------------------------

    var SKILL_ACTION_MAIN = 'SKILL_ACTION_MAIN';

    // ---------------------------
    // Wealth
    // ---------------------------

    var WEALTH_COINS = 'WEALTH_COINS';
    var WEALTH_TEETH = 'WEALTH_TEETH';
    var WEALTH_FRIENDS = 'WEALTH_FRIENDS';

    // ---------------------------
    // Projectiles
    // ---------------------------

    var PROJECTILE_AXE = 'PROJECTILE_AXE';
    var PROJECTILE_AXE_BLOODED = 'PROJECTILE_AXE_BLOODED';
    var PROJECTILE_SWORD = 'PROJECTILE_SWORD';
    var PROJECTILE_SWORD_BLOODED = 'PROJECTILE_SWORD_BLOODED';

    // ---------------------------
    // Projectiles
    // ---------------------------

    var BLOOD_1 = 'BLOOD_1';
    var BLOOD_2 = 'BLOOD_2';
    var BLOOD_3 = 'BLOOD_3';
    var BLOOD_4 = 'BLOOD_4';
    var BLOOD_5 = 'BLOOD_5';
}

class TilemapManager {

    public static final instance:TilemapManager = new TilemapManager();

    private final tilesMap = new Map<TileType, h2d.Tile>();
    private var initiated = false;

	private function new() {
	}

    public function init() {
        if (!initiated) {
            final mapData:TiledMapData = haxe.Json.parse(Res.instance.getConfigResource(SeidhResource.CONFIG_SEIDH_MAP));
            final tw = mapData.tilewidth;
            final th = mapData.tileheight;
    
            final stuffTilemapTile = Res.instance.getTileResource(SeidhResource.STUFF_TILEMAP);
    
            // Consumables
            tilesMap.set(TileType.POTION_RED, stuffTilemapTile.sub(1 * tw, 0, tw, th).center());
            tilesMap.set(TileType.POTION_GREEN, stuffTilemapTile.sub(2 * tw, 0, tw, th).center());
            tilesMap.set(TileType.POTION_BLUE, stuffTilemapTile.sub(3 * tw, 0, tw, th).center());
            tilesMap.set(TileType.POTION_YELLOW, stuffTilemapTile.sub(4 * tw, 0, tw, th).center());
            tilesMap.set(TileType.SWORD, stuffTilemapTile.sub(5 * tw, 0, tw, th).center());
            tilesMap.set(TileType.SALMON, stuffTilemapTile.sub(6 * tw, 0, tw, th).center());
            tilesMap.set(TileType.COIN, stuffTilemapTile.sub(7 * tw, 0, tw, th).center());

            // Runes
            tilesMap.set(TileType.RUNE_TYPE_ANY_LVL_1, stuffTilemapTile.sub(1 * tw, 1 * th, tw, th).center());
            tilesMap.set(TileType.RUNE_TYPE_1_LVL_2, stuffTilemapTile.sub(2 * tw, 1 * th, tw, th).center());
            tilesMap.set(TileType.RUNE_TYPE_2_LVL_2, stuffTilemapTile.sub(3 * tw, 1 * th, tw, th).center());
            tilesMap.set(TileType.RUNE_TYPE_3_LVL_2, stuffTilemapTile.sub(4 * tw, 1 * th, tw, th).center());
            tilesMap.set(TileType.RUNE_TYPE_4_LVL_2, stuffTilemapTile.sub(5 * tw, 1 * th, tw, th).center());
            tilesMap.set(TileType.RUNE_TYPE_5_LVL_2, stuffTilemapTile.sub(6 * tw, 1 * th, tw, th).center());
            tilesMap.set(TileType.RUNE_TYPE_6_LVL_2, stuffTilemapTile.sub(7 * tw, 1 * th, tw, th).center());
            tilesMap.set(TileType.RUNE_TYPE_1_LVL_3, stuffTilemapTile.sub(8 * tw, 1 * th, tw, th).center());
            tilesMap.set(TileType.RUNE_TYPE_2_LVL_3, stuffTilemapTile.sub(9 * tw, 1 * th, tw, th).center());
            tilesMap.set(TileType.RUNE_TYPE_3_LVL_3, stuffTilemapTile.sub(10 * tw, 1 * th, tw, th).center());
            tilesMap.set(TileType.RUNE_TYPE_4_LVL_3, stuffTilemapTile.sub(11 * tw, 1 * th, tw, th).center());
            tilesMap.set(TileType.RUNE_TYPE_5_LVL_3, stuffTilemapTile.sub(12 * tw, 1 * th, tw, th).center());
            tilesMap.set(TileType.RUNE_TYPE_6_LVL_3, stuffTilemapTile.sub(13 * tw, 1 * th, tw, th).center());

            // Scrolls
            tilesMap.set(TileType.SCROLL_TYPE_ANY_LVL_1, stuffTilemapTile.sub(1 * tw, 2 * th, tw, th).center());
            tilesMap.set(TileType.SCROLL_TYPE_1_LVL_2, stuffTilemapTile.sub(2 * tw, 2 * th, tw, th).center());
            tilesMap.set(TileType.SCROLL_TYPE_2_LVL_2, stuffTilemapTile.sub(3 * tw, 2 * th, tw, th).center());
            tilesMap.set(TileType.SCROLL_TYPE_3_LVL_2, stuffTilemapTile.sub(4 * tw, 2 * th, tw, th).center());
            tilesMap.set(TileType.SCROLL_TYPE_1_LVL_3, stuffTilemapTile.sub(5 * tw, 2 * th, tw, th).center());
            tilesMap.set(TileType.SCROLL_TYPE_2_LVL_3, stuffTilemapTile.sub(6 * tw, 2 * th, tw, th).center());
            tilesMap.set(TileType.SCROLL_TYPE_3_LVL_3, stuffTilemapTile.sub(7 * tw, 2 * th, tw, th).center());

            // Artifacts
            tilesMap.set(TileType.ARTIFACT_1, stuffTilemapTile.sub(1 * tw, 3 * th, tw, th).center());
            
            // Icons
            tilesMap.set(TileType.ICON_BOOST_BLACK, stuffTilemapTile.sub(1 * tw, 4 * th, tw, th).center());
            tilesMap.set(TileType.ICON_SKILL_BACKGROUND, stuffTilemapTile.sub(2 * tw, 4 * th, tw, th).center());
            tilesMap.set(TileType.ICON_CLOSE, stuffTilemapTile.sub(3 * tw, 4 * th, tw, th).center());
            tilesMap.set(TileType.ICON_SCROLL, stuffTilemapTile.sub(4 * tw, 4 * th, tw, th).center());
            tilesMap.set(TileType.ICON_BOOST_BROWN, stuffTilemapTile.sub(5 * tw, 4 * th, tw, th).center());

            // Skills
            tilesMap.set(TileType.SKILL_ACTION_MAIN, stuffTilemapTile.sub(1 * tw, 5 * th, tw, th).center());

            // Wealth
            tilesMap.set(TileType.WEALTH_COINS, stuffTilemapTile.sub(1 * tw, 6 * th, tw, th).center());
            tilesMap.set(TileType.WEALTH_TEETH, stuffTilemapTile.sub(2 * tw, 6 * th, tw, th).center());
            tilesMap.set(TileType.WEALTH_FRIENDS, stuffTilemapTile.sub(3 * tw, 6 * th, tw, th).center());

            // Projectile
            tilesMap.set(TileType.PROJECTILE_AXE, stuffTilemapTile.sub(1 * tw, 7 * th, tw, th).center());
            tilesMap.set(TileType.PROJECTILE_AXE_BLOODED, stuffTilemapTile.sub(2 * tw, 7 * th, tw, th).center());
            tilesMap.set(TileType.PROJECTILE_SWORD, stuffTilemapTile.sub(3 * tw, 7 * th, tw, th).center());
            tilesMap.set(TileType.PROJECTILE_SWORD_BLOODED, stuffTilemapTile.sub(4 * tw, 7 * th, tw, th).center());

            // Blood
            tilesMap.set(TileType.BLOOD_1, stuffTilemapTile.sub(1 * tw, 8 * th, tw, th).center());
            tilesMap.set(TileType.BLOOD_2, stuffTilemapTile.sub(2 * tw, 8 * th, tw, th).center());
            tilesMap.set(TileType.BLOOD_3, stuffTilemapTile.sub(3 * tw, 8 * th, tw, th).center());
            tilesMap.set(TileType.BLOOD_4, stuffTilemapTile.sub(4 * tw, 8 * th, tw, th).center());
            tilesMap.set(TileType.BLOOD_5, stuffTilemapTile.sub(5 * tw, 8 * th, tw, th).center());

            initiated = true;
        }
    }

    public function getTile(tileType: TileType) {
        return tilesMap.get(tileType);
    }
}