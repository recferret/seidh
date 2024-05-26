package game.scene.impl;

import engine.seidh.SeidhGameEngine;
import game.scene.base.BasicScene;

class SceneUiTest extends BasicScene {

    public function new() {
		super(null);

        trace('SceneUiTest');

		// TODO impl

		addButton('Create game', (button:h2d.Flow) -> {
			
		});
		addButton('Join game', (button:h2d.Flow) -> {
			
		});
    }

    // --------------------------------------
	// Impl
	// --------------------------------------

	public function start() {
	}

	public function customUpdate(dt:Float, fps:Float) {
	}

}