package game;

import hxd.net.BinaryLoader;

enum SeidhResource {
    
    // ------------------------------------
    // CONFIG
    // ------------------------------------

    CONFIG_SEIDH_MAP;

    // ------------------------------------
    // FX
    // ------------------------------------

    FX_IMPACT;
    FX_ZOMBIE_BLOOD_1;
    FX_ZOMBIE_BLOOD_2;
    FX_GLAMR_EYE_EXP;

    FX_NORMALMAP;

    // ------------------------------------
    // RAGNAR
    // ------------------------------------
    
    RAGNAR_IDLE;
    RAGNAR_RUN;
    RAGNAR_ATTACK;
    RAGNAR_DEATH;

    // ------------------------------------
    // SOUND
    // ------------------------------------

    SOUND_BUTTON_1;
    SOUND_BUTTON_2;
    SOUND_GAMEPLAY_THEME;
    SOUND_MENU_THEME;
    SOUND_VIKING_DEATH;
    SOUND_VIKING_DMG;
    SOUND_VIKING_HIT;
    SOUND_ZOMBIE_DEATH;
    SOUND_ZOMBIE_DMG;
    SOUND_ZOMBIE_HIT;

    // ------------------------------------
    // STUFF
    // ------------------------------------

    STUFF_TILEMAP;

    // ------------------------------------
    // TERRAIN
    // ------------------------------------

    TERRAIN_GROUND_1;
    TERRAIN_GROUND_2;
    TERRAIN_GROUND_3;
    TERRAIN_GROUND_4;
    TERRAIN_FENCE;
    TERRAIN_PUDDLE;
    TERRAIN_ROCK;
    TERRAIN_TREE_1;
    TERRAIN_TREE_2;
    TERRAIN_TREE_3;
    TERRAIN_TREE_4;
    TERRAIN_WEED_1;
    TERRAIN_WEED_2;
    TERRAIN_ENV_TILEMAP;

    // ------------------------------------
    // UI
    // ------------------------------------

    UI_BUTTON_BIG_NAY;
    UI_BUTTON_BIG_YAY;
    UI_BUTTON_SMALL_NAY;
    UI_BUTTON_SMALL_YAY;

    UI_DIALOG_WINDOW_SMALL;
    UI_DIALOG_WINDOW_MEDIUM;
    UI_DIALOG_XL_HEADER;
    UI_DIALOG_XL_FOOTER;

    UI_GAME_JOYSTICK_1;
    UI_GAME_JOYSTICK_2;

    UI_GAME_BAR;
    UI_GAME_BOSS_BAR;

    UI_GAME_HEADER_FRAME_LEFT;
    UI_GAME_HEADER_FRAME_RIGHT;
    UI_GAME_FOOTER_FRAME_LEFT;
    UI_GAME_FOOTER_FRAME_RIGHT;
    UI_GAME_FRAME_HORIZONTAL;
    UI_GAME_FRAME_VERTICAL;

    UI_GAME_FOOTER;
    UI_GAME_FRAME;
    UI_GAME_FRAME_RIGHT;

    UI_HOME_ARROW_LEFT;
    UI_HOME_ARROW_RIGHT;
    UI_HOME_DARKNESS;
    UI_HOME_HEADER_LEFT;
    UI_HOME_HEADER_RIGHT;
    UI_HOME_HEADER_HORIZONTAL;
    UI_HOME_FRAME_VERTICAL;
    UI_HOME_FOOTER_LEFT;
    UI_HOME_FOOTER_RIGHT;
    UI_HOME_FOOTER_HORIZONTAL;

    UI_HOME_HOME_NAY;
    UI_HOME_HOME_YAY;
    UI_HOME_BOOST_NAY;
    UI_HOME_BOOST_YAY;
    UI_HOME_COLLECT_NAY;
    UI_HOME_COLLECT_YAY;
    UI_HOME_FRIEND_NAY;
    UI_HOME_FRIEND_YAY;

    UI_HOME_BUNNY;
    UI_HOME_BUNNY_FIRE;

    UI_BOOST_SCROLL_BODY;
    UI_BOOST_SCROLL_HEADER;

    UI_CHAR_BUTTON_BAR;
    UI_CHAR_EXP_RING;
    UI_CHAR_FRAME_HORIZONTAL;
    UI_CHAR_FRAME_CORNER;
    UI_CHAR_FRAME_VERTICAL;
    UI_CHAR_RUNES_BG;
    UI_CHAR_RUNES;
    
    // ------------------------------------
    // ZOMBIE BOY
    // ------------------------------------

    ZOMBIE_BOY_IDLE;
    ZOMBIE_BOY_RUN;
    ZOMBIE_BOY_ATTACK;
    ZOMBIE_BOY_SPAWN;
    ZOMBIE_BOY_DEATH;

    // ------------------------------------
    // ZOMBIE GIRL
    // ------------------------------------

    ZOMBIE_GIRL_IDLE;
    ZOMBIE_GIRL_RUN;
    ZOMBIE_GIRL_ATTACK;
    ZOMBIE_GIRL_SPAWN;
    ZOMBIE_GIRL_DEATH;

    // ------------------------------------
    // GLAMR
    // ------------------------------------

    GLAMR_IDLE;
    GLAMR_FLY;
    GLAMR_EYE_ATTACK;
    GLAMR_DEATH;
    GLAMR_SPAWN;
    GLAMR_SPAWN_2;
    GLAMR_HAIL;
}

typedef ResLoadingProgressCallback = {
	var done:Bool;
    var progress:Int;
}

class Res {

    public static final instance:Res = new Res();

    private final configResMap = new Map<SeidhResource, Dynamic>();
    private final fontResMap = new Map<SeidhResource, Dynamic>();
    private final tileResMap = new Map<SeidhResource, h2d.Tile>();
    private final soundResMap = new Map<SeidhResource, hxd.res.Sound>();

    private var initialized = false;
    private var resCallback:ResLoadingProgressCallback->Void = null;

	private function new() {
    }

    public function init() {
        // ------------------------------------
        // CONFIG
        // ------------------------------------

        configResMap.set(CONFIG_SEIDH_MAP, hxd.Res.config.CONFIG_SEIDH_MAP.entry.getText());

        // ------------------------------------
        // FX
        // ------------------------------------

        tileResMap.set(FX_IMPACT, hxd.Res.fx.ragnar.FX_IMPACT.toTile().center());

        tileResMap.set(FX_ZOMBIE_BLOOD_1, hxd.Res.fx.zombie.FX_ZOMBIE_BLOOD_1.toTile().center());
        tileResMap.set(FX_ZOMBIE_BLOOD_2, hxd.Res.fx.zombie.FX_ZOMBIE_BLOOD_2.toTile().center());

        tileResMap.set(FX_GLAMR_EYE_EXP, hxd.Res.fx.glamr.FX_GLAMR_EYE_EXP.toTile().center());

        tileResMap.set(FX_NORMALMAP, hxd.Res.fx.FX_NORMALMAP.toTile());
            
        // ------------------------------------
        // RAGNAR
        // ------------------------------------
            
        tileResMap.set(RAGNAR_IDLE, hxd.Res.ragnar.RAGNAR_IDLE.toTile().center());
        tileResMap.set(RAGNAR_RUN, hxd.Res.ragnar.RAGNAR_RUN.toTile().center());
        tileResMap.set(RAGNAR_ATTACK, hxd.Res.ragnar.RAGNAR_ATTACK.toTile().center());
        tileResMap.set(RAGNAR_DEATH, hxd.Res.ragnar.RAGNAR_DEATH.toTile().center());

        // ------------------------------------
        // SOUND
        // ------------------------------------
            
        soundResMap.set(SOUND_BUTTON_1, hxd.Res.sound.SOUND_BUTTON_1);
        soundResMap.set(SOUND_BUTTON_2, hxd.Res.sound.SOUND_BUTTON_2);
        soundResMap.set(SOUND_GAMEPLAY_THEME, hxd.Res.sound.SOUND_GAMEPLAY_THEME);
        soundResMap.set(SOUND_MENU_THEME, hxd.Res.sound.SOUND_MENU_THEME);
        soundResMap.set(SOUND_VIKING_DEATH, hxd.Res.sound.SOUND_VIKING_DEATH);
        soundResMap.set(SOUND_VIKING_DMG, hxd.Res.sound.SOUND_VIKING_DMG);
        soundResMap.set(SOUND_VIKING_HIT, hxd.Res.sound.SOUND_VIKING_HIT);
        soundResMap.set(SOUND_ZOMBIE_DEATH, hxd.Res.sound.SOUND_ZOMBIE_DEATH);
        soundResMap.set(SOUND_ZOMBIE_DMG, hxd.Res.sound.SOUND_ZOMBIE_DMG);
        soundResMap.set(SOUND_ZOMBIE_HIT, hxd.Res.sound.SOUND_ZOMBIE_HIT);
            
        // ------------------------------------
        // STUFF
        // ------------------------------------
        tileResMap.set(STUFF_TILEMAP, hxd.Res.stuff.STUFF_TILEMAP.toTile().center());

        // ------------------------------------
        // TERRAIN
        // ------------------------------------
            
        tileResMap.set(TERRAIN_GROUND_1, hxd.Res.terrain.TERRAIN_GROUND_1.toTile().center());
        tileResMap.set(TERRAIN_GROUND_2, hxd.Res.terrain.TERRAIN_GROUND_2.toTile().center());
        tileResMap.set(TERRAIN_GROUND_3, hxd.Res.terrain.TERRAIN_GROUND_3.toTile().center());
        tileResMap.set(TERRAIN_GROUND_4, hxd.Res.terrain.TERRAIN_GROUND_4.toTile().center());
        tileResMap.set(TERRAIN_FENCE, hxd.Res.terrain.TERRAIN_FENCE.toTile().center());
        tileResMap.set(TERRAIN_PUDDLE, hxd.Res.terrain.TERRAIN_PUDDLE.toTile().center());
        tileResMap.set(TERRAIN_ROCK, hxd.Res.terrain.TERRAIN_ROCK.toTile().center());
        tileResMap.set(TERRAIN_TREE_1, hxd.Res.terrain.TERRAIN_TREE_1.toTile().center());
        tileResMap.set(TERRAIN_TREE_2, hxd.Res.terrain.TERRAIN_TREE_2.toTile().center());
        tileResMap.set(TERRAIN_TREE_3, hxd.Res.terrain.TERRAIN_TREE_3.toTile().center());
        tileResMap.set(TERRAIN_TREE_4, hxd.Res.terrain.TERRAIN_TREE_4.toTile().center());
        tileResMap.set(TERRAIN_WEED_1, hxd.Res.terrain.TERRAIN_WEED_1.toTile().center());
        tileResMap.set(TERRAIN_WEED_2, hxd.Res.terrain.TERRAIN_WEED_2.toTile().center());
        tileResMap.set(TERRAIN_ENV_TILEMAP, hxd.Res.terrain.TERRAIN_ENV_TILEMAP.toTile().center());

        // ------------------------------------
        // UI
        // ------------------------------------

        tileResMap.set(UI_BUTTON_BIG_NAY, hxd.Res.ui.UI_BUTTON_BIG_NAY.toTile().center());
        tileResMap.set(UI_BUTTON_BIG_YAY, hxd.Res.ui.UI_BUTTON_BIG_YAY.toTile().center());
        tileResMap.set(UI_BUTTON_SMALL_NAY, hxd.Res.ui.UI_BUTTON_SMALL_NAY.toTile().center());
        tileResMap.set(UI_BUTTON_SMALL_YAY, hxd.Res.ui.UI_BUTTON_SMALL_YAY.toTile().center());

        tileResMap.set(UI_DIALOG_WINDOW_SMALL, hxd.Res.ui.dialog.UI_DIALOG_WINDOW_SMALL.toTile().center());
        tileResMap.set(UI_DIALOG_WINDOW_MEDIUM, hxd.Res.ui.dialog.UI_DIALOG_WINDOW_MEDIUM.toTile().center());     
        tileResMap.set(UI_DIALOG_XL_HEADER, hxd.Res.ui.dialog.UI_DIALOG_XL_HEADER.toTile().center());
        tileResMap.set(UI_DIALOG_XL_FOOTER, hxd.Res.ui.dialog.UI_DIALOG_XL_FOOTER.toTile().center());

        tileResMap.set(UI_GAME_JOYSTICK_1, hxd.Res.ui.game.UI_GAME_JOYSTICK_1.toTile().center());
        tileResMap.set(UI_GAME_JOYSTICK_2, hxd.Res.ui.game.UI_GAME_JOYSTICK_2.toTile().center());
            
        tileResMap.set(UI_GAME_HEADER_FRAME_LEFT, hxd.Res.ui.game.UI_GAME_HEADER_FRAME_LEFT.toTile().center());
        tileResMap.set(UI_GAME_HEADER_FRAME_RIGHT, hxd.Res.ui.game.UI_GAME_HEADER_FRAME_RIGHT.toTile().center());
        tileResMap.set(UI_GAME_FOOTER_FRAME_LEFT, hxd.Res.ui.game.UI_GAME_FOOTER_FRAME_LEFT.toTile().center());
        tileResMap.set(UI_GAME_FOOTER_FRAME_RIGHT, hxd.Res.ui.game.UI_GAME_FOOTER_FRAME_RIGHT.toTile().center());
        tileResMap.set(UI_GAME_FRAME_HORIZONTAL, hxd.Res.ui.game.UI_GAME_FRAME_HORIZONTAL.toTile().center());
        tileResMap.set(UI_GAME_FRAME_VERTICAL, hxd.Res.ui.game.UI_GAME_FRAME_VERTICAL.toTile().center());

        tileResMap.set(UI_GAME_FRAME, hxd.Res.ui.game.UI_GAME_FRAME.toTile().center());
        tileResMap.set(UI_GAME_FRAME_RIGHT, hxd.Res.ui.game.UI_GAME_FRAME_RIGHT.toTile().center());
        tileResMap.set(UI_GAME_BAR, hxd.Res.ui.game.UI_GAME_BAR.toTile().center());
        tileResMap.set(UI_GAME_BOSS_BAR, hxd.Res.ui.game.UI_GAME_BOSS_BAR.toTile().center());
            
        tileResMap.set(UI_HOME_ARROW_LEFT, hxd.Res.ui.home.UI_HOME_ARROW_LEFT.toTile().center());
        tileResMap.set(UI_HOME_ARROW_RIGHT, hxd.Res.ui.home.UI_HOME_ARROW_RIGHT.toTile().center());
        tileResMap.set(UI_HOME_DARKNESS, hxd.Res.ui.home.UI_HOME_DARKNESS.toTile().center());
        tileResMap.set(UI_HOME_HEADER_LEFT, hxd.Res.ui.home.UI_HOME_HEADER_LEFT.toTile().center());
        tileResMap.set(UI_HOME_HEADER_RIGHT, hxd.Res.ui.home.UI_HOME_HEADER_RIGHT.toTile().center());
        tileResMap.set(UI_HOME_HEADER_HORIZONTAL, hxd.Res.ui.home.UI_HOME_HEADER_HORIZONTAL.toTile().center());
        tileResMap.set(UI_HOME_FRAME_VERTICAL, hxd.Res.ui.home.UI_HOME_FRAME_VERTICAL.toTile().center());
        tileResMap.set(UI_HOME_FOOTER_LEFT, hxd.Res.ui.home.UI_HOME_FOOTER_LEFT.toTile().center());
        tileResMap.set(UI_HOME_FOOTER_RIGHT, hxd.Res.ui.home.UI_HOME_FOOTER_RIGHT.toTile().center());
        tileResMap.set(UI_HOME_FOOTER_HORIZONTAL, hxd.Res.ui.home.UI_HOME_FOOTER_HORIZONTAL.toTile().center());

        tileResMap.set(UI_HOME_HOME_NAY, hxd.Res.ui.home.UI_HOME_HOME_NAY.toTile().center());
        tileResMap.set(UI_HOME_HOME_YAY, hxd.Res.ui.home.UI_HOME_HOME_YAY.toTile().center());
        tileResMap.set(UI_HOME_BOOST_NAY, hxd.Res.ui.home.UI_HOME_BOOST_NAY.toTile().center());
        tileResMap.set(UI_HOME_BOOST_YAY, hxd.Res.ui.home.UI_HOME_BOOST_YAY.toTile().center());
        tileResMap.set(UI_HOME_COLLECT_NAY, hxd.Res.ui.home.UI_HOME_COLLECT_NAY.toTile().center());
        tileResMap.set(UI_HOME_COLLECT_YAY, hxd.Res.ui.home.UI_HOME_COLLECT_YAY.toTile().center());
        tileResMap.set(UI_HOME_FRIEND_NAY, hxd.Res.ui.home.UI_HOME_FRIEND_NAY.toTile().center());
        tileResMap.set(UI_HOME_FRIEND_YAY, hxd.Res.ui.home.UI_HOME_FRIEND_YAY.toTile().center());

        tileResMap.set(UI_HOME_BUNNY, hxd.Res.ui.home.UI_HOME_BUNNY.toTile().center());
        tileResMap.set(UI_HOME_BUNNY_FIRE, hxd.Res.ui.home.UI_HOME_BUNNY_FIRE.toTile().center());

        tileResMap.set(UI_DIALOG_WINDOW_SMALL, hxd.Res.ui.dialog.UI_DIALOG_WINDOW_SMALL.toTile().center());
        tileResMap.set(UI_DIALOG_WINDOW_MEDIUM, hxd.Res.ui.dialog.UI_DIALOG_WINDOW_MEDIUM.toTile().center());     

        tileResMap.set(UI_BOOST_SCROLL_BODY, hxd.Res.ui.boost.UI_BOOST_SCROLL_BODY.toTile().center());
        tileResMap.set(UI_BOOST_SCROLL_HEADER, hxd.Res.ui.boost.UI_BOOST_SCROLL_HEADER.toTile().center());

        tileResMap.set(UI_CHAR_BUTTON_BAR, hxd.Res.ui.char.UI_CHAR_BUTTON_BAR.toTile().center());
        tileResMap.set(UI_CHAR_EXP_RING, hxd.Res.ui.char.UI_CHAR_EXP_RING.toTile().center());
        tileResMap.set(UI_CHAR_FRAME_HORIZONTAL, hxd.Res.ui.char.UI_CHAR_FRAME_HORIZONTAL.toTile().center());
        tileResMap.set(UI_CHAR_FRAME_CORNER, hxd.Res.ui.char.UI_CHAR_FRAME_CORNER.toTile().center());
        tileResMap.set(UI_CHAR_FRAME_VERTICAL, hxd.Res.ui.char.UI_CHAR_FRAME_VERTICAL.toTile().center());
        tileResMap.set(UI_CHAR_RUNES_BG, hxd.Res.ui.char.UI_CHAR_RUNES_BG.toTile().center());
        tileResMap.set(UI_CHAR_RUNES, hxd.Res.ui.char.UI_CHAR_RUNES.toTile().center());

        // ------------------------------------
        // ZOMBIE BOY
        // ------------------------------------
            
        tileResMap.set(ZOMBIE_BOY_IDLE, hxd.Res.zombie_boy.ZOMBIE_BOY_IDLE.toTile().center());
        tileResMap.set(ZOMBIE_BOY_RUN, hxd.Res.zombie_boy.ZOMBIE_BOY_RUN.toTile().center());
        tileResMap.set(ZOMBIE_BOY_DEATH, hxd.Res.zombie_boy.ZOMBIE_BOY_DEATH.toTile().center());
        tileResMap.set(ZOMBIE_BOY_SPAWN, hxd.Res.zombie_boy.ZOMBIE_BOY_SPAWN.toTile().center());
        tileResMap.set(ZOMBIE_BOY_ATTACK, hxd.Res.zombie_boy.ZOMBIE_BOY_ATTACK.toTile().center());

            
        // ------------------------------------
        // ZOMBIE GIRL
        // ------------------------------------
            
        tileResMap.set(ZOMBIE_GIRL_IDLE, hxd.Res.zombie_girl.ZOMBIE_GIRL_IDLE.toTile().center());
        tileResMap.set(ZOMBIE_GIRL_RUN, hxd.Res.zombie_girl.ZOMBIE_GIRL_RUN.toTile().center());
        tileResMap.set(ZOMBIE_GIRL_DEATH, hxd.Res.zombie_girl.ZOMBIE_GIRL_DEATH.toTile().center());
        tileResMap.set(ZOMBIE_GIRL_SPAWN, hxd.Res.zombie_girl.ZOMBIE_GIRL_SPAWN.toTile().center());
        tileResMap.set(ZOMBIE_GIRL_ATTACK, hxd.Res.zombie_girl.ZOMBIE_GIRL_ATTACK.toTile().center());


        // ------------------------------------
        // GLAMR
        // ------------------------------------
            
        tileResMap.set(GLAMR_IDLE, hxd.Res.glamr.GLAMR_IDLE.toTile().center());
        tileResMap.set(GLAMR_FLY, hxd.Res.glamr.GLAMR_FLY.toTile().center());
        tileResMap.set(GLAMR_DEATH, hxd.Res.glamr.GLAMR_DEATH.toTile().center());
        tileResMap.set(GLAMR_SPAWN, hxd.Res.glamr.GLAMR_SPAWN.toTile().center());
        tileResMap.set(GLAMR_SPAWN_2, hxd.Res.glamr.GLAMR_SPAWN_2.toTile().center());
        tileResMap.set(GLAMR_EYE_ATTACK, hxd.Res.glamr.GLAMR_EYE_ATTACK.toTile().center());
        tileResMap.set(GLAMR_HAIL, hxd.Res.glamr.GLAMR_HAIL.toTile().center());
	}

    public function loadRemotePakFile(callback:ResLoadingProgressCallback->Void) {
        final data = new BinaryLoader('https://storage.yandexcloud.net/seidh-static-and-assets/resources/res.pak');
		data.onProgress = function onProgress(cur:Int, max:Int ) {
			trace('PAK progress. cur: ' + cur + ', max: ' + max);

            if (callback != null) {
                callback({
                    done: false,
                    progress: Std.int(cur / max * 100),
                });
            }
		}
        data.onLoaded = function onLoaded(data:haxe.io.Bytes) {
            final pak = new hxd.fmt.pak.FileSystem();
            pak.addPak(new hxd.fmt.pak.FileSystem.FileInput(data));

			hxd.Res.loader = new hxd.res.Loader(pak);

            if (callback != null) {
                callback({
                    done: true,
                    progress: 100,
                });
            }
        }
        data.load();
    }

    public function getSoundResource(seidhResource:SeidhResource) {
        final isSound = 
            seidhResource == SeidhResource.SOUND_BUTTON_1 ||
            seidhResource == SeidhResource.SOUND_BUTTON_2 ||
            seidhResource == SeidhResource.SOUND_MENU_THEME ||
            seidhResource == SeidhResource.SOUND_GAMEPLAY_THEME ||
            seidhResource == SeidhResource.SOUND_VIKING_DEATH ||
            seidhResource == SeidhResource.SOUND_VIKING_DMG ||
            seidhResource == SeidhResource.SOUND_VIKING_HIT ||
            seidhResource == SeidhResource.SOUND_ZOMBIE_DEATH ||
            seidhResource == SeidhResource.SOUND_ZOMBIE_DMG ||
            seidhResource == SeidhResource.SOUND_ZOMBIE_HIT;

        if (isSound) {
            return soundResMap.get(seidhResource);
        } else {
            return null;
        }
    }

    public function getConfigResource(seidhResource:SeidhResource) {
        final isConfig = seidhResource == SeidhResource.CONFIG_SEIDH_MAP;

        if (isConfig) {
            return configResMap.get(seidhResource);
        } else {
            return null;
        }
    }

    public function getTileResource(seidhResource:SeidhResource) {
        final isSound = 
            seidhResource == SeidhResource.SOUND_BUTTON_1 ||
            seidhResource == SeidhResource.SOUND_BUTTON_2 ||
            seidhResource == SeidhResource.SOUND_MENU_THEME ||
            seidhResource == SeidhResource.SOUND_GAMEPLAY_THEME ||
            seidhResource == SeidhResource.SOUND_VIKING_DEATH ||
            seidhResource == SeidhResource.SOUND_VIKING_DMG ||
            seidhResource == SeidhResource.SOUND_VIKING_HIT ||
            seidhResource == SeidhResource.SOUND_ZOMBIE_DEATH ||
            seidhResource == SeidhResource.SOUND_ZOMBIE_DMG ||
            seidhResource == SeidhResource.SOUND_ZOMBIE_HIT;

        if (isSound) {
            return null;
        } else {
            return tileResMap.get(seidhResource).clone();
        }
    }
}