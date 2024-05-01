package game.scene.impl;

import game.scene.SceneManager.GameScene;
import game.scene.base.BasicScene;

class HomeScene extends BasicScene {
	private var selectSceneCallback:GameScene->Void;

	public function new(selectSceneCallback:GameScene->Void) {
		super(null);

		this.selectSceneCallback = selectSceneCallback;

		addButton('Input scene', (button:h2d.Flow) -> {
			selectScene(GameScene.SceneInputTest);
		});

		addButton('AI scene', (button:h2d.Flow) -> {
			selectScene(GameScene.SceneAiTest);
		});

		addButton('Geom test', (button:h2d.Flow) -> {
			selectScene(GameScene.SceneGeomTest);
		});
	}

	// --------------------------------------
	// Impl
	// --------------------------------------

	public function start() {}

	public function customUpdate(dt:Float, fps:Float) {}

	// --------------------------------------
	// General
	// --------------------------------------

	private function selectScene(gameScene:GameScene) {
		if (selectSceneCallback != null) {
			selectSceneCallback(gameScene);
		}
	}
}
