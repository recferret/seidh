import game.ui.SampleView.ContainerComp;
import game.scene.SceneManager;
import game.scene.base.BasicScene;

class Main extends hxd.App {

	// var center : h2d.Flow;
	// var style = null;

	// override function init() {
	// 	center = new h2d.Flow(s2d);
	// 	center.horizontalAlign = center.verticalAlign = Middle;
	// 	onResize();
	// 	var root = new ContainerComp(Right, center);

	// 	// Override
	// 	root.btn.label = "Button";
	// 	root.btn1.label = "Highlight ON";
	// 	root.btn2.labelTxt.text = "Highlight OFF";

	// 	root.btn1.onClick = function() {
	// 		root.btn.dom.addClass("highlight");
	// 	}
	// 	root.btn2.onClick = function() {
	// 		root.btn.dom.removeClass("highlight");
	// 	}

	// 	style = new h2d.domkit.Style();
	// 	style.load(hxd.Res.style);
	// 	style.addObject(root);
	// }

	// override function onResize() {
	// 	center.minWidth = center.maxWidth = s2d.width;
	// 	center.minHeight = center.maxHeight = s2d.height;
	// }

	// override function update(dt:Float) {
	// 	style.sync();
	// }

	// static function main() {
	// 	hxd.Res.initEmbed();
	// 	new Main();
	// }

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