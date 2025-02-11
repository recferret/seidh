package game.scene;

import engine.seidh.types.TypesSeidhGame;
import game.scene.impl.game.BalanceScene;
import engine.base.types.TypesBaseEngine;

import game.event.EventManager;
import game.js.NativeWindowJS;
import game.scene.base.BasicScene;
import game.scene.impl.LoadingScene;
import game.scene.impl.home.HomeScene;
import game.scene.impl.game.GameScene;
import game.scene.impl.character.CharacterInfoScene.SceneCharacterInfo;
import game.scene.impl.MapSceneTest;

class SceneManager implements EventListener {
	private var sceneChangedCallback:BasicScene->Void;
	private var currentScene:BasicScene;
	
	public function new(sceneChangedCallback:BasicScene->Void) {
		this.sceneChangedCallback = sceneChangedCallback;

		NativeWindowJS.tgBackButtonCallback(function callback() {
			if (currentScene is GameScene) {
				EventManager.instance.notify(EventManager.EVENT_HOME_SCENE, {});
			}
		});

		EventManager.instance.subscribe(EventManager.EVENT_HOME_PLAY, this);
		EventManager.instance.subscribe(EventManager.EVENT_HOME_SCENE, this);
		EventManager.instance.subscribe(EventManager.EVENT_REF_SHARE, this);

		// currentScene = new GameScene(EngineMode.CLIENT_SINGLEPLAYER);
		// currentScene = new GameScene(EngineMode.CLIENT_MULTIPLAYER);

		// currentScene = new HomeScene();
		// currentScene = new SceneAiTest();
		// currentScene = new SceneInputTest();
		// currentScene = new SceneSpritesTest();
		// currentScene = new SceneGeomTest();
		// currentScene = new SceneNetworkTest();
		// currentScene = new SceneUiTest();
		// currentScene = new MapSceneTest();
		currentScene = new LoadingScene();
		// currentScene = new SceneCharacterInfo();
		// currentScene = new BalanceScene();
		currentScene.start();
		changeSceneCallback();
	}

	// --------------------------------------
	// Impl
	// --------------------------------------

	public function notify(event:String, message:Dynamic) {
		if (currentScene != null) {
			currentScene.destroy();
			currentScene = null;
		}

		switch (event) {
			case EventManager.EVENT_HOME_PLAY:
				currentScene = new GameScene(EngineMode.CLIENT_SINGLEPLAYER, WinCondition.KILL_MONSTERS_AND_BOSS);
				currentScene.start();

				NativeWindowJS.tgShowBackButton();
				changeSceneCallback();
			case EventManager.EVENT_HOME_SCENE:
				currentScene = new HomeScene();
				currentScene.start();

				NativeWindowJS.tgHideBackButton();
				changeSceneCallback();
			case EventManager.EVENT_REF_SHARE:
				NativeWindowJS.tgShareMyRefLink(Player.instance.userInfo.userId);
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
