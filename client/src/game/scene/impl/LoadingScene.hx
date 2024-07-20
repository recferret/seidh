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
        if (GameConfig.instance.TelegramAuth) {
            final tgInitData = NativeWindowJS.tgGetInitData(); 
            if (tgInitData == null || tgInitData.length == 0) {
                if (GameConfig.instance.Analytics) 
                    NativeWindowJS.telemetreeInit(false);
            } else {
                if (GameConfig.instance.Analytics) 
                    NativeWindowJS.telemetreeInit(true);

                final tgUnsafeData = NativeWindowJS.tgGetInitDataUnsafe();
                final startParam = tgUnsafeData.start_param;

                NativeWindowJS.restPostTelegramInitData(tgInitData, startParam, function callback(data:Dynamic) {
                    Player.instance.setUserData(data);
                    EventManager.instance.notify(EventManager.EVENT_HOME_SCENE, {});
                });
            }
        } else {
            EventManager.instance.notify(EventManager.EVENT_HOME_SCENE, {});
        };
    }

	public function customUpdate(dt:Float, fps:Float) {
	}

}
