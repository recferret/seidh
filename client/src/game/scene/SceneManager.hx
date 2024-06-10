package game.scene;

import game.event.EventManager;
import game.js.NativeWindowJS;
import game.scene.impl.LoadingScene;
import game.scene.base.BasicScene;
import game.scene.impl.HomeScene;
import game.scene.impl.GameScene;

class SceneManager implements EventListener {
	private var sceneChangedCallback:BasicScene->Void;
	private var currentScene:BasicScene;

	public function new(sceneChangedCallback:BasicScene->Void) {
		this.sceneChangedCallback = sceneChangedCallback;

		EventManager.instance.subscribe(EventManager.EVENT_HOME_PLAY, this);
		EventManager.instance.subscribe(EventManager.EVENT_HOME_SCENE, this);
		EventManager.instance.subscribe(EventManager.EVENT_REF_SHARE, this);

		// currentScene = new GameScene(GameMode.SINGLEPLAYER);

		currentScene = new HomeScene();
		// currentScene = new SceneAiTest();
		// currentScene = new SceneInputTest();
		// currentScene = new SceneSpritesTest();
		// currentScene = new SceneGeomTest();
		// currentScene = new SceneNetworkTest();
		// currentScene = new SceneUiTest();

		// currentScene = new LoadingScene();
		// currentScene.start();

		changeSceneCallback();
	}

	// --------------------------------------
	// Impl
	// --------------------------------------

	public function notify(event:String, message:Dynamic) {
		switch (event) {
			case EventManager.EVENT_HOME_PLAY:
				currentScene = new GameScene(GameMode.SINGLEPLAYER);
				// currentScene = new GameScene(GameMode.MULTIPLAYER);
				changeSceneCallback();
			case EventManager.EVENT_HOME_SCENE:
				currentScene = new HomeScene();
				changeSceneCallback();
			case EventManager.EVENT_REF_SHARE:
				NativeWindowJS.tgShareMyRefLink(Player.instance.userId);
			default:
		}
	}

	// --------------------------------------
	// Common
	// --------------------------------------

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
