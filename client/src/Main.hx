import game.scene.SceneManager;
import game.scene.base.BasicScene;

class Main extends hxd.App {

	private var sceneManager:SceneManager;

	private static var _engine:h3d.Engine;

	override function init() {
		_engine = engine;

		Main.SetBackgroundColor(0x71664C);

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

	public static function SetBackgroundColor(color:Int) {
		_engine.backgroundColor = color;
	}

}