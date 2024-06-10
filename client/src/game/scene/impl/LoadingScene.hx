package game.scene.impl;

import game.js.NativeWindowJS;
import game.event.EventManager;
import game.scene.base.BasicScene;

class LoadingScene extends BasicScene {

    public function new() {
        super(null);

        trace('Loading...');
    }

	// --------------------------------------
	// Impl
	// --------------------------------------

	public function start() {
        haxe.Timer.delay(function callback() {
            final checkTg = true;
            var tgInitData = null;

            if (checkTg) {
                NativeWindowJS.debugAlert('1');
                tgInitData = NativeWindowJS.tgGetInitData(); 
                if (tgInitData == null || tgInitData.length == 0) {
                    NativeWindowJS.debugAlert('2');
                    trace('TG INIT ERROR');
                    // TODO show some popup about game error
                } else {
                    final tgUnsafeData = NativeWindowJS.tgGetInitDataUnsafe();
                    final startParam = tgUnsafeData.start_param;

                    NativeWindowJS.restPostTelegramInitData(tgInitData, startParam, function callback(data:Dynamic) {
                        // TODO validate data, success etc
                        Player.instance.setUserData(data);
                        EventManager.instance.notify(EventManager.EVENT_HOME_SCENE, {});
                    });
                }
            }
        }, 1000);
    }

	public function customUpdate(dt:Float, fps:Float) {
	}

}
