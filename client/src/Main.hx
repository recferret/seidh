import game.scene.SceneManager;
import game.scene.base.BasicScene;

class Main extends hxd.App {
	private var sceneManager:SceneManager;

	override function init() {
		engine.backgroundColor = 0xFCDCA1;

		this.sceneManager = new SceneManager(function callback(scene:BasicScene) {
			setScene2D(scene);
			sevents.addScene(scene.getInputScene());
		});
	}

	override function update(dt:Float) {
		sceneManager.getCurrentScene().update(dt, engine.fps);
	}

	override function onResize() {
		this.sceneManager.onResize();
	}

	static function main() {
		hxd.Res.initEmbed();
		new Main();
	}
}