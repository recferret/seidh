package game.scene.impl;

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
        if (GameConfig.instance.Production && (GameConfig.instance.TelegramAuth || GameConfig.instance.TelegramTestAuth)) {
            final tgInitData = GameConfig.instance.TelegramAuth ? 
                NativeWindowJS.tgGetInitData() :
                GameConfig.instance.TelegramInitData;
            if (tgInitData == null || tgInitData.length == 0) {
                if (GameConfig.instance.Analytics) 
                    NativeWindowJS.telemetreeInit(false);
            } else {
                if (GameConfig.instance.Analytics) {
                    NativeWindowJS.tgInitAnalytics();
                    NativeWindowJS.telemetreeInit(true);
                }

                final tgUnsafeData = NativeWindowJS.tgGetInitDataUnsafe();
                final startParam = tgUnsafeData.start_param;

                NativeWindowJS.networkAuthAndGetUser(tgInitData, null, startParam, 
                    function userCallback(data:Dynamic) {
                        processUserCallback(data);
                    },
                    function boostCallback(data:Dynamic) {
                        processBoostCallback(data);
                    }
                );
            }
        } else {
            if (GameConfig.instance.Serverless) {
                final uuid = Uuid.short().toLowerCase();
                Player.instance.setUserData({
                    userId: uuid,
                    characters: [{
                        id: 'entity_' + uuid
                    }],
                    authToken: Uuid.short().toLowerCase(),
                    virtualTokenBalance: 1000,
                    kills: 0
                });
                EventManager.instance.notify(EventManager.EVENT_HOME_SCENE, {});
            } else {
                NativeWindowJS.networkAuthAndGetUser(null, GameConfig.instance.TestLogin, GameConfig.instance.TestReferrerId, 
                    function userCallback(data:Dynamic) {
                        processUserCallback(data);
                    },
                    function boostCallback(data:Dynamic) {
                        processBoostCallback(data);
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

}
