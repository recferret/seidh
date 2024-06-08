package game.scene;

import game.scene.impl.NetworkTestScene.SceneNetworkTest;
import game.scene.impl.SpritesSceneTest.SceneSpritesTest;
import game.scene.impl.InputSceneTest;
import game.scene.impl.AiSceneTest;
import game.scene.base.BasicScene;
import game.scene.impl.HomeScene;
import game.scene.impl.SceneGeomTest;

enum GameScene {

	SceneHome;
	SceneGame;

	// SceneInputTest;
	// SceneAiTest;
	// SceneGeomTest;
	// SceneSpritesTest;
	// SceneUiTest;
}

class SceneManager {
	private var sceneChangedCallback:BasicScene->Void;
	private var currentScene:BasicScene;

	public function new(sceneChangedCallback:BasicScene->Void, scene:GameScene = GameScene.SceneHome) {
		this.sceneChangedCallback = sceneChangedCallback;

		switch (scene) {
			case SceneHome:
				currentScene = new HomeScene(function callback(gameScene:GameScene) {
					// switch (gameScene) {
					// 	case SceneInputTest:
					// 		currentScene = new SceneInputTest();
					// 		currentScene.start();
					// 	case SceneAiTest:
					// 		currentScene = new SceneAiTest();
					// 		currentScene.start();
					// 	case SceneGeomTest:
					// 		currentScene = new SceneGeomTest();
					// 		currentScene.start();
					// 	default:
					// }
					// changeSceneCallback();
				});
			default:
		}

		// currentScene = new SceneAiTest();
		// currentScene = new SceneInputTest();
		// currentScene = new SceneSpritesTest();
		// currentScene = new SceneGeomTest();
		// currentScene = new SceneNetworkTest();
		// currentScene = new SceneUiTest();
		// currentScene.start();

		changeSceneCallback();
	}

	public function getCurrentScene() {
		return currentScene;
	}

	public function onResize() {
		currentScene.onResize();
	}

	private function changeSceneCallback() {
		if (sceneChangedCallback != null) {
			sceneChangedCallback(currentScene);
		}
	}
}
