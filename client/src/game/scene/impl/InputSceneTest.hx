package game.scene.impl;

import game.js.NativeWindowJS;
import game.effects.ProjectileSphere;
import engine.holy.HolyGameEngine;
import game.scene.base.BasicScene;

class SceneInputTest extends BasicScene {

    public function new() {
		super(new HolyGameEngine());

		// camera.scale(2, 2);

		addButton('TG FULLSCREEN', function callback(button:h2d.Flow) {
			// hxd.Window.getInstance().displayMode = hxd.Window.DisplayMode.FullscreenResize;
			NativeWindowJS.tgExpand();
			fui.removeChild(button);
        });

		// addButton('FULLSCREEN', function callback(button:h2d.Flow) {
		// 	hxd.Window.getInstance().displayMode = hxd.Window.DisplayMode.FullscreenResize;
		// 	fui.removeChild(button);
        // });


		createGameEntityFromMinimalStruct(Player.instance.playerEntityId, Player.instance.playerId, 200, 200, KNIGHT);

		createGameEntityFromMinimalStruct("1", "1", 50, 200, SKELETON_WARRIOR);
		// createGameEntityFromMinimalStruct("2", "2", 50, 300, SKELETON_WARRIOR);
		createGameEntityFromMinimalStruct("3", "3", 20, 300, SKELETON_WARRIOR);
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

	// Update client part and visuals
	public function customUpdate(dt:Float, fps:Float) {
		for (clientEntity in clientMainEntities) {
			clientEntity.update(dt);

			if (GameConfig.DebugDraw) {
				clientEntity.debugDraw(debugGraphics);
			}
		}
	}

}