package game.scene.impl;

import engine.base.MathUtils;
import haxe.Timer;
import game.js.NativeWindowJS;
import engine.seidh.SeidhGameEngine;
import game.scene.base.BasicScene;

class SceneInputTest extends BasicScene {

	private var id = 0;

    public function new() {
		super(new SeidhGameEngine());

		// camera.scale(1, 1);

		// final text = addText(NativeWindowJS.tgGetInitData());
		// text.setPosition(0, 0);

		// NativeWindowJS.restPostTelegramInitData(NativeWindowJS.tgGetInitData());

		// addButton('TG FULLSCREEN', function callback(button:h2d.Flow) {
		// 	// hxd.Window.getInstance().displayMode = hxd.Window.DisplayMode.FullscreenResize;
		// 	NativeWindowJS.tgExpand();
		// 	fui.removeChild(button);
        // });

		// addButton('FULLSCREEN', function callback(button:h2d.Flow) {
		// 	hxd.Window.getInstance().displayMode = hxd.Window.DisplayMode.FullscreenResize;
		// 	fui.removeChild(button);
        // });


		createCharacterEntityFromMinimalStruct(Player.instance.playerEntityId, Player.instance.playerId, 2000, 2000, RAGNAR_LOH);

		spawnMobs();

		// function spawn() {
		// 	Timer.delay(function callback() {
		// 		final monsterId = '' + id++;
		// 		final x = MathUtils.randomIntInRange(-500, 1000);
		// 		final y = MathUtils.randomIntInRange(-500, 1000);
		// 		createCharacterEntityFromMinimalStruct(monsterId, monsterId, x, y, SKELETON_WARRIOR);
		// 		spawn();
		// 	}, 1000);
		// }

		// spawn();

		// createCharacterEntityFromMinimalStruct("2", "2", 470, 300, SKELETON_WARRIOR);

		// createGameEntityFromMinimalStruct("2", "2", 50, 300, SKELETON_WARRIOR);
		// createGameEntityFromMinimalStruct("3", "3", 850, 200, SKELETON_WARRIOR);
		// createGameEntityFromMinimalStruct("2", "2", 400, 200, SKELETON_WARRIOR);
		// createGameEntityFromMinimalStruct("3", "3", 500, 200, SKELETON_WARRIOR); 
 
		// final projectile = new ProjectileSphere(this);
    }

    // --------------------------------------
	// Impl
	// --------------------------------------

	public function start() {
	}

	public function customUpdate(dt:Float, fps:Float) {
	}

}