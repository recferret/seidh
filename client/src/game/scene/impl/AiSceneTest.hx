package game.scene.impl;

import engine.holy.HolyGameEngine;
import game.scene.base.BasicScene;

class SceneAiTest extends BasicScene {

	// private var player: Warrior1Entity;
	// private var enemy: Character;

    public function new() {
		super(new HolyGameEngine());

		trace('Scene AI test');

		// player = new Character('Player', this, 100, 100);
		// addChild(player);

		// enemy = new Character('Enemy', this, 600, 200);
		// addChild(enemy);

		// enemy.lookAt(player);
		// enemy.setSpeed(10);

		// player = new Warrior1Entity(this);
		// player.initiateEngineEntity(createGameEntity(SeidhCharacterType.Warrior1, 100, 100, 10, 96, 96));
		// player.setAnimationState(Idle);

		// final skeleton = createGameEntity(SeidhCharacterType.Skeleton, 300, 100, 10, 128, 128);
    }

    // --------------------------------------
	// Impl
	// --------------------------------------

	public function start() {
	}

	public function customUpdate(dt:Float, fps:Float) {
		// player.update(dt);
		// enemy.update(dt);

		// trace(enemy.seidhCharacterEntity.distanceBetweenTarget());

		// TODO debug draw here

		// Utils.DrawRect(debugGraphics, player.getBodyRect(), 0x0000FF);
		// Utils.DrawRect(debugGraphics, enemy.getBodyRect(), 0x0000FF);

		// if (enemy.seidhCharacterEntity.hasTargetObject()) {
		// 	final line = enemy.seidhCharacterEntity.getForwardLookingLine(200);
		// 	Utils.DrawLine(debugGraphics, Utils.EngineToClientPoint(line.p1), Utils.EngineToClientPoint(line.p2), 0x00ff00);
		// }
	}

}