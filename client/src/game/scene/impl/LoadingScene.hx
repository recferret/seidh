package game.scene.impl;

import engine.seidh.SeidhGameEngine;
import game.js.NativeWindowJS;
import game.event.EventManager;
import game.scene.base.BasicScene;

import uuid.Uuid;


class LoadingScene extends BasicScene {

    public function new() {
        super(null);
    }

	// --------------------------------------
	// Impl
	// --------------------------------------

	public function start() {
        if (GameClientConfig.instance.Production && (GameClientConfig.instance.TelegramAuth || GameClientConfig.instance.TelegramTestAuth)) {
            final tgInitData = GameClientConfig.instance.TelegramAuth ? 
                NativeWindowJS.tgGetInitData() :
                GameClientConfig.instance.TelegramInitData;
            if (tgInitData == null || tgInitData.length == 0) {
                if (GameClientConfig.instance.Analytics) 
                    NativeWindowJS.telemetreeInit(false);
            } else {
                if (GameClientConfig.instance.Analytics) {
                    NativeWindowJS.tgInitAnalytics();
                    NativeWindowJS.telemetreeInit(true);
                }

                final tgUnsafeData = NativeWindowJS.tgGetInitDataUnsafe();
                final startParam = tgUnsafeData.start_param;

                NativeWindowJS.networkInit(tgInitData, null, startParam, 
                    function userCallback(data:Dynamic) {
                        processUserCallback(data);
                    },
                    function boostCallback(data:Dynamic) {
                        processBoostCallback(data);
                    },
                    function getGameConfigCallback(data:Dynamic) {
                        processGetGameConfigCallback(data);
                    },
                );
            }
        } else {
            if (GameClientConfig.instance.Serverless) {
                final uuid = Uuid.short().toLowerCase();
                Player.instance.setUserData({
                    userId: uuid,
                    characters: [{
                        id: 'entity_' + uuid
                    }],
                    authToken: Uuid.short().toLowerCase(),
                    coins: 1000,
                    teeth: 1000,
                });
                EventManager.instance.notify(EventManager.EVENT_HOME_SCENE, {});
            } else {
                NativeWindowJS.networkInit(null, GameClientConfig.instance.TestLogin, GameClientConfig.instance.TestReferrerId, 
                    function userCallback(data:Dynamic) {
                        processUserCallback(data);
                    },
                    function boostCallback(data:Dynamic) {
                        processBoostCallback(data);
                    },
                    function getGameConfigCallback(data:Dynamic) {
                        processGetGameConfigCallback(data);
                    },
                );
            }
        };
    }

	public function customUpdate(dt:Float, fps:Float) {
	}

    private function processUserCallback(data:Dynamic) {
        Player.instance.setUserData(data);
        initNetwork();
        EventManager.instance.notify(EventManager.EVENT_HOME_SCENE, {});
    }

    private function processBoostCallback(data:Dynamic) {
        Player.instance.setBoostData(data);
    }

    private function processGetGameConfigCallback(data:Dynamic) {
        // Mobs spawn
        SeidhGameEngine.GAME_CONFIG.mobsMaxAtTheSameTime = data.mobsMaxAtTheSameTime;
        SeidhGameEngine.GAME_CONFIG.mobsMaxPerGame = data.mobsMaxPerGame;
        SeidhGameEngine.GAME_CONFIG.mobSpawnDelayMs = data.mobSpawnDelayMs;

        // Exp boost
        SeidhGameEngine.GAME_CONFIG.expLevel1Multiplier = data.expLevel1Multiplier;
        SeidhGameEngine.GAME_CONFIG.expLevel2Multiplier = data.expLevel2Multiplier;
        SeidhGameEngine.GAME_CONFIG.expLevel3Multiplier = data.expLevel3Multiplier;

        // Stats boost
        SeidhGameEngine.GAME_CONFIG.statsLevel1Multiplier = data.statsLevel1Multiplier;
        SeidhGameEngine.GAME_CONFIG.statsLevel2Multiplier = data.statsLevel2Multiplier;
        SeidhGameEngine.GAME_CONFIG.statsLevel3Multiplier = data.statsLevel3Multiplier;

        // Wealth boost
        SeidhGameEngine.GAME_CONFIG.wealthLevel1PickUpRangeMultiplier = data.wealthLevel1PickUpRangeMultiplier;
        SeidhGameEngine.GAME_CONFIG.wealthLevel2PickUpRangeMultiplier = data.wealthLevel2PickUpRangeMultiplier;
        SeidhGameEngine.GAME_CONFIG.wealthLevel3PickUpRangeMultiplier = data.wealthLevel3PickUpRangeMultiplier;

        SeidhGameEngine.GAME_CONFIG.wealthLevel1CoinsMultiplier = data.wealthLevel1CoinsMultiplier;
        SeidhGameEngine.GAME_CONFIG.wealthLevel2CoinsMultiplier = data.wealthLevel2CoinsMultiplier;
        SeidhGameEngine.GAME_CONFIG.wealthLevel3CoinsMultiplier = data.wealthLevel3CoinsMultiplier;
    }

}
