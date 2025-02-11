import game.DeviceInfo;
import game.GameClientConfig;
import h2d.Bitmap;

import motion.Actuate;

import game.ui.text.TextUtils;
import game.sound.SoundManager;
import game.tilemap.TilemapManager;
import game.js.NativeWindowJS;
import game.network.Networking;
import game.scene.SceneManager;
import game.scene.base.BasicScene;
import game.Res;

class Main extends hxd.App {

    public static var NetworkingInstance:Networking;

	private static var sceneManager:SceneManager;
	private var loadingText:h2d.Text;

	private static var _engine:h3d.Engine;

	private static var defaultScreenOrientation:String;
	private static var defaultScreenWidth:Int;
	private static var defaultScreenHeight:Int;

	override function init() {
		super.init();

		_engine = engine;

		Main.NetworkingInstance = new Networking();
		Main.SetBackgroundColor(0x000000);

		setScreenParams();

		final ratio = DeviceInfo.ScreenRatio = DeviceInfo.ScreenOrientation == 'portrait' ? 
			DeviceInfo.JsScreenParams.pageHeight / DeviceInfo.JsScreenParams.pageWidth : 
			DeviceInfo.JsScreenParams.pageWidth / DeviceInfo.JsScreenParams.pageHeight;

		if (DeviceInfo.IsMobile) {
			DeviceInfo.ActualScreenWidth = 
				DeviceInfo.TargetPortraitScreenWidth = DeviceInfo.ScreenOrientation == 'portrait' ? 720 : Std.int(720 * ratio);
			DeviceInfo.ActualScreenHeight = 
				DeviceInfo.TargetPortraitScreenHeight = DeviceInfo.ScreenOrientation == 'portrait' ? Std.int(720 * ratio) : 720;
		} else {
			DeviceInfo.ActualScreenWidth = DeviceInfo.JsScreenParams.pageWidth;
			DeviceInfo.ActualScreenHeight = DeviceInfo.JsScreenParams.pageHeight;
			
			DeviceInfo.TargetPortraitScreenWidth = 720;
			DeviceInfo.TargetPortraitScreenHeight = 1280;
		}

		defaultScreenWidth = DeviceInfo.ActualScreenWidth;
		defaultScreenHeight = DeviceInfo.ActualScreenHeight;
		defaultScreenOrientation = DeviceInfo.ScreenOrientation;

		s2d.scaleMode = ScaleMode.Stretch(DeviceInfo.ActualScreenWidth, DeviceInfo.ActualScreenHeight);

		#if debug
		hxd.Res.initEmbed();
		Res.instance.init();
		loadSceneManager();
		#else
		hxd.Res.initEmbed2();

		final logo = new h2d.Bitmap(hxd.Res.seidh_load.toTile().center());
		logo.alpha = 0;
		logo.setPosition(
			DeviceInfo.ActualScreenWidth / 2,
			DeviceInfo.ActualScreenHeight / 2,
		);
		s2d.addChild(logo);

		loadingText = TextUtils.GetDefaultTextObject(s2d.width / 2, s2d.height - 100, 2, Center, GameClientConfig.DefaultFontColor);
		loadingText.text = "Loading...";
		s2d.addChild(loadingText);

        Actuate.tween(logo, 0.5, {
            alpha: 1,
        });

		Res.instance.loadRemotePakFile(function callback(callbackParam:ResLoadingProgressCallback) {
			if (callbackParam.done) {
				Res.instance.init();
				loadSceneManager();
			}
		});
		#end

		NativeWindowJS.listenForScreenOrientationChange(function callback() {
			setScreenParams();

			final portrait = DeviceInfo.ScreenOrientation == 'portrait';

			if (defaultScreenOrientation == 'portrait') {
				DeviceInfo.ActualScreenWidth = portrait ? defaultScreenWidth : defaultScreenHeight;
				DeviceInfo.ActualScreenHeight = portrait ? defaultScreenHeight : defaultScreenWidth;
			} else {
				DeviceInfo.ActualScreenWidth = portrait ? defaultScreenHeight : defaultScreenWidth;
				DeviceInfo.ActualScreenHeight = portrait ? defaultScreenWidth : defaultScreenHeight;
			}

			final w = DeviceInfo.ActualScreenWidth;
			final h = DeviceInfo.ActualScreenHeight;
	
			s2d.scaleMode = ScaleMode.Stretch(w, h);

			sceneManager.getCurrentScene().onResize();
		});
	}

	private function setScreenParams() {
		DeviceInfo.IsMobile = NativeWindowJS.isMobile();
		DeviceInfo.JsScreenParams = NativeWindowJS.getScreenParams();
		DeviceInfo.ScreenOrientation = DeviceInfo.JsScreenParams.orientation;
	}

	private function loadSceneManager() {
		haxe.Timer.delay(function delay() {
			Main.SetBackgroundColor(0x788a88);
			SoundManager.instance.init();
			TilemapManager.instance.init();
			sceneManager = new SceneManager(function callback(scene:BasicScene) {
				setScene2D(scene);
				sevents.addScene(scene.getInputScene());
			});
		}, 300);
	}

	override function update(dt:Float) {
		if (sceneManager != null && sceneManager.getCurrentScene() != null) {
			sceneManager.getCurrentScene().update(dt, engine.fps);
		}
	}

	override function onResize() {
		if (sceneManager != null) {
			sceneManager.onResize();
		}
	}

	public static function SetBackgroundColor(color:Int) {
		_engine.backgroundColor = color;
	}

	static function main() {
		new Main();
	}
}