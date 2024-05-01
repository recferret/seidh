package game.scene.impl;

import engine.base.MathUtils;
import h2d.col.Point;
import engine.holy.HolyGameEngine;
import game.scene.base.BasicScene;

class SceneInputTest extends BasicScene {

    public function new() {
		super(new HolyGameEngine());

		// camera.scale(2, 2);

		addButton('FULLSCREEN', function callback(button:h2d.Flow) {
			hxd.Window.getInstance().displayMode = hxd.Window.DisplayMode.FullscreenResize;
			fui.removeChild(button);
        });


		createGameEntityFromMinimalStruct(Player.instance.playerEntityId, Player.instance.playerId, 200, 200, KNIGHT);

		createGameEntityFromMinimalStruct("1", "1", 50, 200, SKELETON_WARRIOR);
		createGameEntityFromMinimalStruct("2", "2", 250, 200, SKELETON_WARRIOR);
		// createGameEntityFromMinimalStruct("2", "2", 400, 200, SKELETON_WARRIOR);
		// createGameEntityFromMinimalStruct("3", "3", 500, 200, SKELETON_WARRIOR); 
 

    }

    // --------------------------------------
	// Impl
	// --------------------------------------

	public function start() {
	}

	// Update client part and visuals
	public function customUpdate(dt:Float, fps:Float) {

		if (GameConfig.DebugDraw) {
			debugGraphics.clear();
		}
		for (clientEntity in clientMainEntities) {
			clientEntity.update(dt);

			if (GameConfig.DebugDraw) {
				clientEntity.debugDraw(debugGraphics);
			}
		}
	}

}