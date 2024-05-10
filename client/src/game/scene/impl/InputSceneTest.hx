package game.scene.impl;

import engine.seidh.SeidhGameEngine;
import game.scene.base.BasicScene;

class SceneInputTest extends BasicScene {

    public function new() {
		super(new SeidhGameEngine());

		// camera.scale(2, 2);

		// addButton('TG FULLSCREEN', function callback(button:h2d.Flow) {
		// 	// hxd.Window.getInstance().displayMode = hxd.Window.DisplayMode.FullscreenResize;
		// 	NativeWindowJS.tgExpand();
		// 	fui.removeChild(button);
        // });

		// addButton('FULLSCREEN', function callback(button:h2d.Flow) {
		// 	hxd.Window.getInstance().displayMode = hxd.Window.DisplayMode.FullscreenResize;
		// 	fui.removeChild(button);
        // });


		createCharacterEntityFromMinimalStruct(Player.instance.playerEntityId, Player.instance.playerId, 300, 100, KNIGHT);

		createCharacterEntityFromMinimalStruct("1", "1", 400, 200, SKELETON_WARRIOR);
		createCharacterEntityFromMinimalStruct("2", "2", 470, 300, SKELETON_WARRIOR);

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