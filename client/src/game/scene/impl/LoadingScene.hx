package game.scene.impl;

import h2d.Bitmap;
import game.js.NativeWindowJS;
import game.event.EventManager;
import game.scene.base.BasicScene;

class LoadingScene extends BasicScene {

    public function new() {
        super(null);

        final bg = new Bitmap(hxd.Res.seidh_load.toTile().center(), this);
        bg.setPosition(BasicScene.ActualScreenWidth / 2, BasicScene.ActualScreenHeight / 2);
        bg.scaleY = BasicScene.ActualScreenHeight / 1280;
    }

	// --------------------------------------
	// Impl
	// --------------------------------------

	public function start() {
        haxe.Timer.delay(function callback() {
            final checkTg = true;
            var tgInitData = null;

            if (checkTg) {
                tgInitData = NativeWindowJS.tgGetInitData(); 
                if (tgInitData == null || tgInitData.length == 0) {
                    trace('TG INIT ERROR');
                    // TODO show some popup about game error
                } else {
                    final tgUnsafeData = NativeWindowJS.tgGetInitDataUnsafe();
                    final startParam = tgUnsafeData.start_param;

                    // final startParam = "e2b9a99c-25dc-4835-b983-a887ccb3be08";

                    NativeWindowJS.restPostTelegramInitData(tgInitData, startParam, function callback(data:Dynamic) {
                        Player.instance.setUserData(data);
                        EventManager.instance.notify(EventManager.EVENT_HOME_SCENE, {});
                    });
                }
            }
        }, 2000);
    }

	public function customUpdate(dt:Float, fps:Float) {
	}

}
