package game;

import game.GameConfig.ResourceProvider;
import hxd.net.BinaryLoader;

enum SeidhResource {
    
    // ------------------------------------
    // FX
    // ------------------------------------

    FX_BLOOD_1;
    FX_BLOOD_2;
    FX_BLOOD_3;
    FX_RAGNAR_ATTACK_1;
    FX_RAGNAR_ATTACK_2;
    FX_RAGNAR_ATTACK_3;
    FX_ZOMBIE_ATTACK_1;
    FX_ZOMBIE_ATTACK_2;
    FX_ZOMBIE_ATTACK_3;
    FX_NORMALMAP;

    // ------------------------------------
    // ICON
    // ------------------------------------

    ICON_COINS;
    ICON_FRIENDS;
    ICON_SKILL;

    // ------------------------------------
    // CONSUMABLES
    // ------------------------------------

    CONSUMABLE_COIN;
    CONSUMABLE_HEALTH_POTION;
    CONSUMABLE_LOSOS;

    // ------------------------------------
    // RAGNAR
    // ------------------------------------
    
    RAGNAR_NORM;
    RAGNAR_DUDE;
    
    RAGNAR_BASE;
    RAGNAR_RUN_1;
    RAGNAR_RUN_2;
    RAGNAR_RUN_3;
    RAGNAR_RUN_4;
    RAGNAR_RUN_5;
    RAGNAR_RUN_6;

    RAGNAR_BORODA_1;
    RAGNAR_BORODA_2;
    RAGNAR_USI_1;
    RAGNAR_USI_2;

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
    TERRAIN_WEED_1;
    TERRAIN_WEED_2;

    // ------------------------------------
    // UI
    // ------------------------------------

    UI_DIALOG_BUTTON_NAY;
    UI_DIALOG_BUTTON_YAY;
    UI_DIALOG_WINDOW_SMALL;

    UI_GAME_JOYSTICK_1;
    UI_GAME_JOYSTICK_2;
    UI_GAME_SKILL_SLOT;

    UI_GAME_HEADER;
    UI_GAME_FOOTER;
    UI_GAME_FRAME;
    UI_GAME_FRAME_RIGHT;
    UI_GAME_HP;
    UI_GAME_XP;
    UI_GAME_MONEY;

    UI_HOME_ARROW_LEFT;
    UI_HOME_ARROW_RIGHT;
    UI_HOME_LVL_NAY;
    UI_HOME_LVL_YAY;
    UI_HOME_PLAY_NAY;
    UI_HOME_PLAY_YAY;
    UI_HOME_DARKNESS;
    UI_HOME_HEADER;
    UI_HOME_FRAME;
    UI_HOME_FOOTER;

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
    
    // ------------------------------------
    // ZOMBIE BOY
    // ------------------------------------

    ZOMBIE_BOY;

    // ------------------------------------
    // ZOMBIE GIRL
    // ------------------------------------

    ZOMBIE_GIRL;
}

class ResRemoteLoader {

    public function new(seidhResource:SeidhResource) {
        final filePath = Res.instance.remoteResourceMap.get(seidhResource);
        final loader = new BinaryLoader(filePath);

		loader.onProgress = function onProgress(cur:Int, max:Int) {
		};
		loader.onLoaded = function onLoaded(bytes:haxe.io.Bytes) {
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
                Res.instance.soundResMap.set(seidhResource, hxd.res.Any.fromBytes(filePath, bytes).toSound());
            } else {
                if (seidhResource == SeidhResource.FX_NORMALMAP) {
                    Res.instance.tileResMap.set(seidhResource, hxd.res.Any.fromBytes(filePath, bytes).toTile());
                } {
                    Res.instance.tileResMap.set(seidhResource, hxd.res.Any.fromBytes(filePath, bytes).toTile().center());
                }
            }

            Res.instance.resourcesLoaded += 1;
		}
		loader.load();
    }

}

typedef ResLoadingProgressCallback = {
	var done:Bool;
    var progress:Int;
}

class Res {

    public static final instance:Res = new Res();

    public final tileResMap = new Map<SeidhResource, h2d.Tile>();
    public final soundResMap = new Map<SeidhResource, hxd.res.Sound>();

    public final remoteResourceMap = new Map<SeidhResource, String>();

    public final resourcesTotal = 10;
    public var resourcesLoaded = 0;

    private var initialized = false;

    private var resCallback:ResLoadingProgressCallback->Void = null;

	private function new() {
    }

    public function init(callback:ResLoadingProgressCallback->Void) {
        if (!initialized) {
            resCallback = callback;

            initialized = true;
            if (GameConfig.ResProvider == ResourceProvider.YANDEX_S3) { 
                // ------------------------------------
                // FX
                // ------------------------------------

                remoteResourceMap.set(FX_BLOOD_1, 'https://storage.yandexcloud.net/seidh-static-and-assets/resources/fx/blood/FX_BLOOD_1.png');
                remoteResourceMap.set(FX_BLOOD_2, 'https://storage.yandexcloud.net/seidh-static-and-assets/resources/fx/blood/FX_BLOOD_2.png');
                remoteResourceMap.set(FX_BLOOD_3, 'https://storage.yandexcloud.net/seidh-static-and-assets/resources/fx/blood/FX_BLOOD_3.png');

                remoteResourceMap.set(FX_RAGNAR_ATTACK_1, 'https://storage.yandexcloud.net/seidh-static-and-assets/resources/fx/ragnar/FX_RAGNAR_ATTACK_1.png');
                remoteResourceMap.set(FX_RAGNAR_ATTACK_2, 'https://storage.yandexcloud.net/seidh-static-and-assets/resources/fx/ragnar/FX_RAGNAR_ATTACK_2.png');
                remoteResourceMap.set(FX_RAGNAR_ATTACK_3, 'https://storage.yandexcloud.net/seidh-static-and-assets/resources/fx/ragnar/FX_RAGNAR_ATTACK_3.png');

                remoteResourceMap.set(FX_ZOMBIE_ATTACK_1, 'https://storage.yandexcloud.net/seidh-static-and-assets/resources/fx/zombie/FX_ZOMBIE_ATTACK_1.png');
                remoteResourceMap.set(FX_ZOMBIE_ATTACK_2, 'https://storage.yandexcloud.net/seidh-static-and-assets/resources/fx/zombie/FX_ZOMBIE_ATTACK_2.png');
                remoteResourceMap.set(FX_ZOMBIE_ATTACK_3, 'https://storage.yandexcloud.net/seidh-static-and-assets/resources/fx/zombie/FX_ZOMBIE_ATTACK_3.png');

                remoteResourceMap.set(FX_NORMALMAP, 'https://storage.yandexcloud.net/seidh-static-and-assets/resources/fx/FX_NORMALMAP.png');

                // ------------------------------------
                // ICON
                // ------------------------------------
            
                remoteResourceMap.set(ICON_COINS, 'https://storage.yandexcloud.net/seidh-static-and-assets/resources/icons/ICON_COINS.png');
                remoteResourceMap.set(ICON_FRIENDS, 'https://storage.yandexcloud.net/seidh-static-and-assets/resources/icons/ICON_FRIENDS.png');
                remoteResourceMap.set(ICON_SKILL, 'https://storage.yandexcloud.net/seidh-static-and-assets/resources/icons/ICON_SKILL.png');

                // ------------------------------------
                // CONSUMABLE
                // ------------------------------------

                remoteResourceMap.set(CONSUMABLE_COIN, 'https://storage.yandexcloud.net/seidh-static-and-assets/resources/consumables/CONSUMABLE_COIN.png');
                remoteResourceMap.set(CONSUMABLE_HEALTH_POTION, 'https://storage.yandexcloud.net/seidh-static-and-assets/resources/consumables/CONSUMABLE_HEALTH_POTION.png');
                remoteResourceMap.set(CONSUMABLE_LOSOS, 'https://storage.yandexcloud.net/seidh-static-and-assets/resources/consumables/CONSUMABLE_LOSOS.png');

                // ------------------------------------
                // RAGNAR
                // ------------------------------------
            
                remoteResourceMap.set(RAGNAR_DUDE, 'https://storage.yandexcloud.net/seidh-static-and-assets/resources/ragnar/RAGNAR_DUDE.png');
                remoteResourceMap.set(RAGNAR_NORM, 'https://storage.yandexcloud.net/seidh-static-and-assets/resources/ragnar/RAGNAR_NORM.png');
                remoteResourceMap.set(RAGNAR_BASE, 'https://storage.yandexcloud.net/seidh-static-and-assets/resources/ragnar/RAGNAR_BASE.png');
                remoteResourceMap.set(RAGNAR_BORODA_1, 'https://storage.yandexcloud.net/seidh-static-and-assets/resources/ragnar/RAGNAR_BORODA_1.png');
                remoteResourceMap.set(RAGNAR_BORODA_2, 'https://storage.yandexcloud.net/seidh-static-and-assets/resources/ragnar/RAGNAR_BORODA_2.png');
                remoteResourceMap.set(RAGNAR_USI_1, 'https://storage.yandexcloud.net/seidh-static-and-assets/resources/ragnar/RAGNAR_USI_1.png');
                remoteResourceMap.set(RAGNAR_USI_2, 'https://storage.yandexcloud.net/seidh-static-and-assets/resources/ragnar/RAGNAR_USI_2.png');
            
                // ------------------------------------
                // SOUND
                // ------------------------------------
            
                remoteResourceMap.set(SOUND_BUTTON_1, 'https://storage.yandexcloud.net/seidh-static-and-assets/resources/sound/SOUND_BUTTON_1.mp3');
                remoteResourceMap.set(SOUND_BUTTON_2, 'https://storage.yandexcloud.net/seidh-static-and-assets/resources/sound/SOUND_BUTTON_2.mp3');
                remoteResourceMap.set(SOUND_GAMEPLAY_THEME, 'https://storage.yandexcloud.net/seidh-static-and-assets/resources/sound/SOUND_GAMEPLAY_THEME.mp3');
                remoteResourceMap.set(SOUND_MENU_THEME, 'https://storage.yandexcloud.net/seidh-static-and-assets/resources/sound/SOUND_MENU_THEME.mp3');
                remoteResourceMap.set(SOUND_VIKING_DEATH, 'https://storage.yandexcloud.net/seidh-static-and-assets/resources/sound/SOUND_VIKING_DEATH.mp3');
                remoteResourceMap.set(SOUND_VIKING_DMG, 'https://storage.yandexcloud.net/seidh-static-and-assets/resources/sound/SOUND_VIKING_DMG.mp3');
                remoteResourceMap.set(SOUND_VIKING_HIT, 'https://storage.yandexcloud.net/seidh-static-and-assets/resources/sound/SOUND_VIKING_HIT.mp3');
                remoteResourceMap.set(SOUND_ZOMBIE_DEATH, 'https://storage.yandexcloud.net/seidh-static-and-assets/resources/sound/SOUND_ZOMBIE_DEATH.mp3');
                remoteResourceMap.set(SOUND_ZOMBIE_DMG, 'https://storage.yandexcloud.net/seidh-static-and-assets/resources/sound/SOUND_ZOMBIE_DMG.mp3');
                remoteResourceMap.set(SOUND_ZOMBIE_HIT, 'https://storage.yandexcloud.net/seidh-static-and-assets/resources/sound/SOUND_ZOMBIE_HIT.mp3');
            
                // ------------------------------------
                // TERRAIN
                // ------------------------------------
            
                remoteResourceMap.set(TERRAIN_GROUND_1, 'https://storage.yandexcloud.net/seidh-static-and-assets/resources/terrain/TERRAIN_GROUND_1.png');
                remoteResourceMap.set(TERRAIN_GROUND_2, 'https://storage.yandexcloud.net/seidh-static-and-assets/resources/terrain/TERRAIN_GROUND_2.png');
                remoteResourceMap.set(TERRAIN_GROUND_3, 'https://storage.yandexcloud.net/seidh-static-and-assets/resources/terrain/TERRAIN_GROUND_3.png');
                remoteResourceMap.set(TERRAIN_GROUND_4, 'https://storage.yandexcloud.net/seidh-static-and-assets/resources/terrain/TERRAIN_GROUND_4.png');
                remoteResourceMap.set(TERRAIN_FENCE, 'https://storage.yandexcloud.net/seidh-static-and-assets/resources/terrain/TERRAIN_FENCE.png');
                remoteResourceMap.set(TERRAIN_PUDDLE, 'https://storage.yandexcloud.net/seidh-static-and-assets/resources/terrain/TERRAIN_PUDDLE.png');
                remoteResourceMap.set(TERRAIN_ROCK, 'https://storage.yandexcloud.net/seidh-static-and-assets/resources/terrain/TERRAIN_ROCK.png');
                remoteResourceMap.set(TERRAIN_TREE_1, 'https://storage.yandexcloud.net/seidh-static-and-assets/resources/terrain/TERRAIN_TREE_1.png');
                remoteResourceMap.set(TERRAIN_TREE_2, 'https://storage.yandexcloud.net/seidh-static-and-assets/resources/terrain/TERRAIN_TREE_2.png');
                remoteResourceMap.set(TERRAIN_WEED_1, 'https://storage.yandexcloud.net/seidh-static-and-assets/resources/terrain/TERRAIN_WEED_1.png');
                remoteResourceMap.set(TERRAIN_WEED_2, 'https://storage.yandexcloud.net/seidh-static-and-assets/resources/terrain/TERRAIN_WEED_2.png');

                // ------------------------------------
                // UI
                // ------------------------------------

                remoteResourceMap.set(UI_DIALOG_BUTTON_NAY, 'https://storage.yandexcloud.net/seidh-static-and-assets/resources/ui/dialog/UI_DIALOG_BUTTON_NAY.png');
                remoteResourceMap.set(UI_DIALOG_BUTTON_YAY, 'https://storage.yandexcloud.net/seidh-static-and-assets/resources/ui/dialog/UI_DIALOG_BUTTON_YAY.png');
                remoteResourceMap.set(UI_DIALOG_WINDOW_SMALL, 'https://storage.yandexcloud.net/seidh-static-and-assets/resources/ui/dialog/UI_DIALOG_WINDOW_SMALL.png');
            
                remoteResourceMap.set(UI_GAME_JOYSTICK_1, 'https://storage.yandexcloud.net/seidh-static-and-assets/resources/ui/game/UI_GAME_JOYSTICK_1.png');
                remoteResourceMap.set(UI_GAME_JOYSTICK_2, 'https://storage.yandexcloud.net/seidh-static-and-assets/resources/ui/game/UI_GAME_JOYSTICK_2.png');
                remoteResourceMap.set(UI_GAME_SKILL_SLOT, 'https://storage.yandexcloud.net/seidh-static-and-assets/resources/ui/game/UI_GAME_SKILL_SLOT.png');
                remoteResourceMap.set(UI_GAME_HEADER, 'https://storage.yandexcloud.net/seidh-static-and-assets/resources/ui/game/UI_GAME_HEADER.png');
                remoteResourceMap.set(UI_GAME_FOOTER, 'https://storage.yandexcloud.net/seidh-static-and-assets/resources/ui/game/UI_GAME_FOOTER.png');
                remoteResourceMap.set(UI_GAME_FRAME, 'https://storage.yandexcloud.net/seidh-static-and-assets/resources/ui/game/UI_GAME_FRAME.png');
                remoteResourceMap.set(UI_GAME_FRAME_RIGHT, 'https://storage.yandexcloud.net/seidh-static-and-assets/resources/ui/game/UI_GAME_FRAME_RIGHT.png');
                remoteResourceMap.set(UI_GAME_HP, 'https://storage.yandexcloud.net/seidh-static-and-assets/resources/ui/game/UI_GAME_HP.png');
                remoteResourceMap.set(UI_GAME_XP, 'https://storage.yandexcloud.net/seidh-static-and-assets/resources/ui/game/UI_GAME_XP.png');
                remoteResourceMap.set(UI_GAME_MONEY, 'https://storage.yandexcloud.net/seidh-static-and-assets/resources/ui/game/UI_GAME_MONEY.png');
            
                remoteResourceMap.set(UI_HOME_ARROW_LEFT, 'https://storage.yandexcloud.net/seidh-static-and-assets/resources/ui/home/UI_HOME_ARROW_LEFT.png');
                remoteResourceMap.set(UI_HOME_ARROW_RIGHT, 'https://storage.yandexcloud.net/seidh-static-and-assets/resources/ui/home/UI_HOME_ARROW_RIGHT.png');
                remoteResourceMap.set(UI_HOME_LVL_NAY, 'https://storage.yandexcloud.net/seidh-static-and-assets/resources/ui/home/UI_HOME_LVL_NAY.png');
                remoteResourceMap.set(UI_HOME_LVL_YAY, 'https://storage.yandexcloud.net/seidh-static-and-assets/resources/ui/home/UI_HOME_LVL_YAY.png');
                remoteResourceMap.set(UI_HOME_PLAY_NAY, 'https://storage.yandexcloud.net/seidh-static-and-assets/resources/ui/home/UI_HOME_PLAY_NAY.png');
                remoteResourceMap.set(UI_HOME_PLAY_YAY, 'https://storage.yandexcloud.net/seidh-static-and-assets/resources/ui/home/UI_HOME_PLAY_YAY.png');
                remoteResourceMap.set(UI_HOME_DARKNESS, 'https://storage.yandexcloud.net/seidh-static-and-assets/resources/ui/home/UI_HOME_DARKNESS.png');
                remoteResourceMap.set(UI_HOME_HEADER, 'https://storage.yandexcloud.net/seidh-static-and-assets/resources/ui/home/UI_HOME_HEADER.png');
                remoteResourceMap.set(UI_HOME_FRAME, 'https://storage.yandexcloud.net/seidh-static-and-assets/resources/ui/home/UI_HOME_FRAME.png');
                remoteResourceMap.set(UI_HOME_FOOTER, 'https://storage.yandexcloud.net/seidh-static-and-assets/resources/ui/home/UI_HOME_FOOTER.png');
                remoteResourceMap.set(UI_HOME_HOME_NAY, 'https://storage.yandexcloud.net/seidh-static-and-assets/resources/ui/home/UI_HOME_HOME_NAY.png');
                remoteResourceMap.set(UI_HOME_HOME_YAY, 'https://storage.yandexcloud.net/seidh-static-and-assets/resources/ui/home/UI_HOME_HOME_YAY.png');
                remoteResourceMap.set(UI_HOME_BOOST_NAY, 'https://storage.yandexcloud.net/seidh-static-and-assets/resources/ui/home/UI_HOME_BOOST_NAY.png');
                remoteResourceMap.set(UI_HOME_BOOST_YAY, 'https://storage.yandexcloud.net/seidh-static-and-assets/resources/ui/home/UI_HOME_BOOST_YAY.png');
                remoteResourceMap.set(UI_HOME_COLLECT_NAY, 'https://storage.yandexcloud.net/seidh-static-and-assets/resources/ui/home/UI_HOME_COLLECT_NAY.png');
                remoteResourceMap.set(UI_HOME_COLLECT_YAY, 'https://storage.yandexcloud.net/seidh-static-and-assets/resources/ui/home/UI_HOME_COLLECT_YAY.png');
                remoteResourceMap.set(UI_HOME_FRIEND_NAY, 'https://storage.yandexcloud.net/seidh-static-and-assets/resources/ui/home/UI_HOME_FRIEND_NAY.png');
                remoteResourceMap.set(UI_HOME_FRIEND_YAY, 'https://storage.yandexcloud.net/seidh-static-and-assets/resources/ui/home/UI_HOME_FRIEND_YAY.png');
                remoteResourceMap.set(UI_HOME_BUNNY, 'https://storage.yandexcloud.net/seidh-static-and-assets/resources/ui/home/UI_HOME_BUNNY.png');
                remoteResourceMap.set(UI_HOME_BUNNY_FIRE, 'https://storage.yandexcloud.net/seidh-static-and-assets/resources/ui/home/UI_HOME_BUNNY_FIRE.png');

                // ------------------------------------
                // ZOMBIE BOY
                // ------------------------------------
            
                remoteResourceMap.set(ZOMBIE_BOY, 'https://storage.yandexcloud.net/seidh-static-and-assets/resources/zombie-boy/ZOMBIE_BOY.png');
            
                // ------------------------------------
                // ZOMBIE GIRL
                // ------------------------------------
            
                remoteResourceMap.set(ZOMBIE_GIRL, 'https://storage.yandexcloud.net/seidh-static-and-assets/resources/zombie-girl/ZOMBIE_GIRL.png');

                loadRemoteResources();
            } else if (GameConfig.ResProvider == ResourceProvider.LOCAL) {
                // ------------------------------------
                // FX
                // ------------------------------------

                tileResMap.set(FX_BLOOD_1, hxd.Res.fx.blood.FX_BLOOD_1.toTile().center());
                tileResMap.set(FX_BLOOD_2, hxd.Res.fx.blood.FX_BLOOD_2.toTile().center());
                tileResMap.set(FX_BLOOD_3, hxd.Res.fx.blood.FX_BLOOD_3.toTile().center());
                tileResMap.set(FX_RAGNAR_ATTACK_1, hxd.Res.fx.ragnar.FX_RAGNAR_ATTACK_1.toTile().center());
                tileResMap.set(FX_RAGNAR_ATTACK_2, hxd.Res.fx.ragnar.FX_RAGNAR_ATTACK_2.toTile().center());
                tileResMap.set(FX_RAGNAR_ATTACK_3, hxd.Res.fx.ragnar.FX_RAGNAR_ATTACK_3.toTile().center());
                tileResMap.set(FX_ZOMBIE_ATTACK_1, hxd.Res.fx.zombie.FX_ZOMBIE_ATTACK_1.toTile().center());
                tileResMap.set(FX_ZOMBIE_ATTACK_2, hxd.Res.fx.zombie.FX_ZOMBIE_ATTACK_2.toTile().center());
                tileResMap.set(FX_ZOMBIE_ATTACK_3, hxd.Res.fx.zombie.FX_ZOMBIE_ATTACK_3.toTile().center());
                tileResMap.set(FX_NORMALMAP, hxd.Res.fx.FX_NORMALMAP.toTile());
            
                // ------------------------------------
                // ICON
                // ------------------------------------
            
                tileResMap.set(ICON_COINS, hxd.Res.icons.ICON_COINS.toTile().center());
                tileResMap.set(ICON_FRIENDS, hxd.Res.icons.ICON_FRIENDS.toTile().center());
                tileResMap.set(ICON_SKILL, hxd.Res.icons.ICON_SKILL.toTile().center());

                // ------------------------------------
                // CONSUMABLES
                // ------------------------------------

                tileResMap.set(CONSUMABLE_COIN, hxd.Res.consumables.CONSUMABLE_COIN.toTile().center());
                tileResMap.set(CONSUMABLE_HEALTH_POTION, hxd.Res.consumables.CONSUMABLE_HEALTH_POTION.toTile().center());
                tileResMap.set(CONSUMABLE_LOSOS, hxd.Res.consumables.CONSUMABLE_LOSOS.toTile().center());

                // ------------------------------------
                // RAGNAR
                // ------------------------------------
            
                tileResMap.set(RAGNAR_DUDE, hxd.Res.ragnar.RAGNAR_DUDE.toTile().center());
                tileResMap.set(RAGNAR_NORM, hxd.Res.ragnar.RAGNAR_NORM.toTile().center());

                tileResMap.set(RAGNAR_BASE, hxd.Res.ragnar.RAGNAR_BASE.toTile().center());
                tileResMap.set(RAGNAR_RUN_1, hxd.Res.ragnar.RAGNAR_RUN_1.toTile().center());
                tileResMap.set(RAGNAR_RUN_2, hxd.Res.ragnar.RAGNAR_RUN_2.toTile().center());
                tileResMap.set(RAGNAR_RUN_3, hxd.Res.ragnar.RAGNAR_RUN_3.toTile().center());
                tileResMap.set(RAGNAR_RUN_4, hxd.Res.ragnar.RAGNAR_RUN_4.toTile().center());
                tileResMap.set(RAGNAR_RUN_5, hxd.Res.ragnar.RAGNAR_RUN_5.toTile().center());
                tileResMap.set(RAGNAR_RUN_6, hxd.Res.ragnar.RAGNAR_RUN_6.toTile().center());

                
                tileResMap.set(RAGNAR_BORODA_1, hxd.Res.ragnar.RAGNAR_BORODA_1.toTile().center());
                tileResMap.set(RAGNAR_BORODA_2, hxd.Res.ragnar.RAGNAR_BORODA_2.toTile().center());
                tileResMap.set(RAGNAR_USI_1, hxd.Res.ragnar.RAGNAR_USI_1.toTile().center());
                tileResMap.set(RAGNAR_USI_2, hxd.Res.ragnar.RAGNAR_USI_2.toTile().center());
            
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
                tileResMap.set(TERRAIN_WEED_1, hxd.Res.terrain.TERRAIN_WEED_1.toTile().center());
                tileResMap.set(TERRAIN_WEED_2, hxd.Res.terrain.TERRAIN_WEED_2.toTile().center());

                // ------------------------------------
                // UI
                // ------------------------------------
            
                tileResMap.set(UI_DIALOG_BUTTON_NAY, hxd.Res.ui.dialog.UI_DIALOG_BUTTON_NAY.toTile().center());
                tileResMap.set(UI_DIALOG_BUTTON_YAY, hxd.Res.ui.dialog.UI_DIALOG_BUTTON_NAY.toTile().center());
                tileResMap.set(UI_DIALOG_WINDOW_SMALL, hxd.Res.ui.dialog.UI_DIALOG_WINDOW_SMALL.toTile().center());
            
                tileResMap.set(UI_GAME_JOYSTICK_1, hxd.Res.ui.game.UI_GAME_JOYSTICK_1.toTile().center());
                tileResMap.set(UI_GAME_JOYSTICK_2, hxd.Res.ui.game.UI_GAME_JOYSTICK_2.toTile().center());
                tileResMap.set(UI_GAME_SKILL_SLOT, hxd.Res.ui.game.UI_GAME_SKILL_SLOT.toTile().center());
            
                tileResMap.set(UI_GAME_HEADER, hxd.Res.ui.game.UI_GAME_HEADER.toTile().center());
                tileResMap.set(UI_GAME_FOOTER, hxd.Res.ui.game.UI_GAME_FOOTER.toTile().center());
                tileResMap.set(UI_GAME_FRAME, hxd.Res.ui.game.UI_GAME_FRAME.toTile().center());
                tileResMap.set(UI_GAME_FRAME_RIGHT, hxd.Res.ui.game.UI_GAME_FRAME_RIGHT.toTile().center());
                tileResMap.set(UI_GAME_HP, hxd.Res.ui.game.UI_GAME_HP.toTile().center());
                tileResMap.set(UI_GAME_XP, hxd.Res.ui.game.UI_GAME_XP.toTile().center());
                tileResMap.set(UI_GAME_MONEY, hxd.Res.ui.game.UI_GAME_MONEY.toTile().center());
            
                tileResMap.set(UI_HOME_ARROW_LEFT, hxd.Res.ui.home.UI_HOME_ARROW_LEFT.toTile().center());
                tileResMap.set(UI_HOME_ARROW_RIGHT, hxd.Res.ui.home.UI_HOME_ARROW_RIGHT.toTile().center());
                tileResMap.set(UI_HOME_LVL_NAY, hxd.Res.ui.home.UI_HOME_LVL_NAY.toTile().center());
                tileResMap.set(UI_HOME_LVL_YAY, hxd.Res.ui.home.UI_HOME_LVL_YAY.toTile().center());
                tileResMap.set(UI_HOME_PLAY_NAY, hxd.Res.ui.home.UI_HOME_PLAY_NAY.toTile().center());
                tileResMap.set(UI_HOME_PLAY_YAY, hxd.Res.ui.home.UI_HOME_PLAY_YAY.toTile().center());
                tileResMap.set(UI_HOME_DARKNESS, hxd.Res.ui.home.UI_HOME_DARKNESS.toTile().center());
                tileResMap.set(UI_HOME_HEADER, hxd.Res.ui.home.UI_HOME_HEADER.toTile().center());
                tileResMap.set(UI_HOME_FRAME, hxd.Res.ui.home.UI_HOME_FRAME.toTile().center());
                tileResMap.set(UI_HOME_FOOTER, hxd.Res.ui.home.UI_HOME_FOOTER.toTile().center());

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

                // ------------------------------------
                // ZOMBIE BOY
                // ------------------------------------
            
                tileResMap.set(ZOMBIE_BOY, hxd.Res.zombie_boy.ZOMBIE_BOY.toTile().center());
            
                // ------------------------------------
                // ZOMBIE GIRL
                // ------------------------------------
            
                tileResMap.set(ZOMBIE_GIRL, hxd.Res.zombie_girl.ZOMBIE_GIRL.toTile().center());

                if (resCallback != null) {
                    resCallback({
                        done: true,
                        progress: 100
                    });
                }
            }
        }
	}

    public function loadRemoteResources() {
        if (GameConfig.ResProvider == ResourceProvider.YANDEX_S3) {
            var remoteResCount = 0;
            for (key in remoteResourceMap.keys()) {
                remoteResCount++;
            }

            for (key in remoteResourceMap.keys()) {
                new ResRemoteLoader(key);
            }

            function wait() {
                if (remoteResCount == resourcesLoaded) {
                    if (resCallback != null) {
                        resCallback({
                            done: true,
                            progress: 100,
                        });
                    }
                } else {
                    if (resCallback != null) {
                        resCallback({
                            done: false,
                            progress: Std.int(resourcesLoaded / remoteResCount * 100),
                        });
                        haxe.Timer.delay(wait, 50);
                    }
                }
            }
            wait();
        }
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