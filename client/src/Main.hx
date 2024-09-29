import game.tilemap.TilemapManager;
import game.js.NativeWindowJS;
import hxd.res.DefaultFont;

import game.scene.SceneManager;
import game.scene.base.BasicScene;
import game.GameConfig;
import game.Res;

class Main extends hxd.App {

	private var sceneManager:SceneManager;
	private var loadingText:h2d.Text;

	public static var JsScreenParams:Dynamic;
	public static var ActualScreenWidth = 0;
	public static var ActualScreenHeight = 0;
	public static var ScreenRatio = 0.0;
	public static var ScreenOrientation:String;

	private static var _engine:h3d.Engine;

	override function init() {
		_engine = engine;

		Main.SetBackgroundColor(0x000000);

		JsScreenParams = NativeWindowJS.getScreenParams();
		ScreenOrientation = JsScreenParams.orientation;
		final ratio = ScreenRatio = ScreenOrientation == 'portrait' ? 
			JsScreenParams.pageHeight / JsScreenParams.pageWidth : 
			JsScreenParams.pageWidth / JsScreenParams.pageHeight;
		ActualScreenWidth = ScreenOrientation == 'portrait' ? 720 : Std.int(720 * ratio);
		ActualScreenHeight = ScreenOrientation == 'portrait' ? Std.int(720 * ratio) : 720;

		loadingText = new h2d.Text(DefaultFont.get());
        loadingText.text = "Loading...";
        loadingText.textColor = GameConfig.FontColor;
        loadingText.dropShadow = { dx : 0.5, dy : 0.5, color : 0xFF0000, alpha : 0.8 };
        loadingText.textAlign = Center;
        loadingText.setScale(6);
        loadingText.setPosition(s2d.width / 2, s2d.height / 2);
        s2d.addChild(loadingText);

		Res.instance.init(function callback(params:ResLoadingProgressCallback) {
			if (params.done) {
				haxe.Timer.delay(function delay() {
					Main.SetBackgroundColor(0x788a88);
					this.sceneManager = new SceneManager(function callback(scene:BasicScene) {
						setScene2D(scene);
						sevents.addScene(scene.getInputScene());
					});
				}, 500);
			}
			loadingText.text = 'Loading... ' + params.progress + '%';
		});

		TilemapManager.instance.init();
	}

	override function update(dt:Float) {
		if (sceneManager != null) {
			sceneManager.getCurrentScene().update(dt, engine.fps);
		}
	}

	override function onResize() {
		if (sceneManager != null) {
			this.sceneManager.onResize();
		}
	}

	static function main() {
		if (GameConfig.instance.ResProvider == ResourceProvider.LOCAL) {
			// #if debug
				hxd.Res.initEmbed();
			// #end
		}
		new Main();
	}

	public static function SetBackgroundColor(color:Int) {
		_engine.backgroundColor = color;
	}

}