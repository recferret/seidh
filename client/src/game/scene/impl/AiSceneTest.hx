package game.scene.impl;

import engine.seidh.SeidhGameEngine;
import game.scene.base.BasicScene;

class SceneAiTest extends BasicScene {

	private var botId = 0;

    public function new() {
		super(new SeidhGameEngine(), function callback(params:BasicSceneClickCallback) {
			// TODO do not hardcode offsets
			createCharacterEntityFromMinimalStruct('' + botId, '' + botId, Std.int(params.clickX) - 50, Std.int(params.clickY) - 100, ZOMBIE_BOY);
			botId++;
		});

		createCharacterEntityFromMinimalStruct(Player.instance.playerEntityId, Player.instance.playerId, 350, 100, RAGNAR_LOH);
    }

    // --------------------------------------
	// Impl
	// --------------------------------------

	public function start() {
	}

	public function customUpdate(dt:Float, fps:Float) {
	}

}