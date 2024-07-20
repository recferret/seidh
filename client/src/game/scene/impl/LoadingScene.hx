package game.scene.impl;

import game.js.NativeWindowJS;
import game.event.EventManager;
import game.scene.base.BasicScene;

class LoadingScene extends BasicScene {

    public function new() {
        super(null);
    }

	// --------------------------------------
	// Impl
	// --------------------------------------

	public function start() {
        if (GameConfig.instance.Production && GameConfig.instance.TelegramAuth) {
            final tgInitData = NativeWindowJS.tgGetInitData(); 
            if (tgInitData == null || tgInitData.length == 0) {
                if (GameConfig.instance.Analytics) 
                    NativeWindowJS.telemetreeInit(false);
            } else {
                if (GameConfig.instance.Analytics) 
                    NativeWindowJS.telemetreeInit(true);

                final tgUnsafeData = NativeWindowJS.tgGetInitDataUnsafe();
                final startParam = tgUnsafeData.start_param;

                NativeWindowJS.restAuthenticate(tgInitData, null, startParam, function callback(data:Dynamic) {
                    Player.instance.setUserData(data);
                    EventManager.instance.notify(EventManager.EVENT_HOME_SCENE, {});
                });
            }
        } else {
            if (GameConfig.instance.Serverless) {
                EventManager.instance.notify(EventManager.EVENT_HOME_SCENE, {});
            } else {
                NativeWindowJS.restAuthenticate(null, GameConfig.instance.TestEmail, GameConfig.instance.TestReferrerId, function callback(data:Dynamic) {
                    Player.instance.setUserData(data);
                    EventManager.instance.notify(EventManager.EVENT_HOME_SCENE, {});
                });
            }
        };
    }

	public function customUpdate(dt:Float, fps:Float) {
	}

}
