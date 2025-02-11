package game.scene.base;

import hxd.Event.EventKind;
import h3d.Engine;

typedef BasicSceneClickCallback = {
	x:Float,
	y:Float,
	eventKind:EventKind,
} 

// TODO this is not a basic scene, it a game actually
abstract class BasicScene extends h2d.Scene {

	public var debugGraphics:h2d.Graphics;
	public var uiScene:h2d.Scene;

	private var basicSceneCallback:BasicSceneClickCallback->Void;

	public function new(?basicSceneCallback:BasicSceneClickCallback->Void) {
		super();

		this.basicSceneCallback = basicSceneCallback;

		debugGraphics = new h2d.Graphics();
		debugGraphics.zOrder = 99;
		addChild(debugGraphics);

		function onEvent(event:hxd.Event) {
			absOnEvent(event);

			if (this.basicSceneCallback != null) {
				final clickPos = new h2d.col.Point(event.relX, event.relY);
				camera.screenToCamera(clickPos);

				this.basicSceneCallback({
					x: clickPos.x,
					y: clickPos.y,
					eventKind: event.kind
				});
			}
		}

		hxd.Window.getInstance().addEventTarget(onEvent);

		onResize();
	}

	// ABS

	public abstract function absOnEvent(event:hxd.Event):Void;
	public abstract function absOnResize(w:Int, h:Int):Void;
	public abstract function absStart():Void;
	public abstract function absRender(e:Engine):Void;
	public abstract function absDestroy():Void;
	public abstract function absUpdate(dt:Float, fps:Float):Void;

	// General

	public function setUiScene(scene:h2d.Scene) {
		uiScene = scene;
	}

	public function start() {
		absStart();
	}

	public function destroy() {
		absDestroy();
		removeChildren();
		uiScene = null;
		basicSceneCallback = null;
	}

	public function onResize() {
		final w = DeviceInfo.ActualScreenWidth;
		final h = DeviceInfo.ActualScreenHeight;

		scaleMode = ScaleMode.Stretch(w, h);

		absOnResize(w, h);
	}

	public function update(dt:Float, fps:Float) {
		debugGraphics.clear();

		absUpdate(dt, fps);
	}

	public override function render(e:Engine) {
		absRender(e);
		super.render(e);
		if (uiScene != null) {
			uiScene.render(e);
		}
	}

	public function getInputScene() {
		return uiScene != null ? uiScene : this;
	}

}