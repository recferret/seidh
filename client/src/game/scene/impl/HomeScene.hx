package game.scene.impl;

import hxd.Event.EventKind;
import game.scene.SceneManager.GameScene;
import game.scene.base.BasicScene;

class HomeScene extends BasicScene {
	private var selectSceneCallback:GameScene->Void;

	private final menuButtonSize:Int;
	private final menuButtonSizeHalf:Int;
	private final buttonBottomPosY:Float;

	public function new(selectSceneCallback:GameScene->Void) {
		super(null, function callback(params:BasicSceneClickCallback) {
			if (params.eventKind == EventKind.EPush && params.clickY > buttonBottomPosY) {
				if (params.clickX <= menuButtonSize) {
					trace('Button 1 click');
				} 
				
				if (params.clickX >= menuButtonSize && params.clickX <= menuButtonSize * 2) {
					trace('Button 2 click');
				}

				if (params.clickX >= menuButtonSize * 2 && params.clickX <= menuButtonSize * 3) {
					trace('Button 3 click');
				}

				if (params.clickX >= menuButtonSize * 3 && params.clickX <= menuButtonSize * 4) {
					trace('Button 4 click');
				}

				if (params.clickX >= menuButtonSize * 4 && params.clickX <= menuButtonSize * 5) {
					trace('Button 5 click');
				}
			}
		});

		this.selectSceneCallback = selectSceneCallback;

		menuButtonSize = Std.int(actualScreenWidth / 5);
		menuButtonSizeHalf = Std.int(menuButtonSize / 2);

		final b1 = addBottomBarButton(menuButtonSize, 'Button 1');
		buttonBottomPosY = actualScreenHeight - menuButtonSizeHalf - (b1.tf.getSize().height * 2);

		b1.fui.setPosition(menuButtonSizeHalf, buttonBottomPosY);

		final b2 = addBottomBarButton(menuButtonSize, 'Button 2');
		b2.fui.setPosition(menuButtonSize + menuButtonSizeHalf, buttonBottomPosY);

		final b3 = addBottomBarButton(menuButtonSize, 'Button 3');
		b3.fui.setPosition(menuButtonSize * 2 + menuButtonSizeHalf, buttonBottomPosY);

		final b4 = addBottomBarButton(menuButtonSize, 'Button 4');
		b4.fui.setPosition(menuButtonSize * 3 + menuButtonSizeHalf, buttonBottomPosY);

		final b5 = addBottomBarButton(menuButtonSize, 'Button 5');
		b5.fui.setPosition(menuButtonSize * 4 + menuButtonSizeHalf, buttonBottomPosY);
	}

	// --------------------------------------
	// Impl
	// --------------------------------------

	public function start() {}

	public function customUpdate(dt:Float, fps:Float) {}

	// --------------------------------------
	// General
	// --------------------------------------

	public function addBottomBarButton(targetButtonSize:Float, text:String) {
		final fui = new h2d.Flow(this);
		fui.layout = Vertical;
		fui.verticalSpacing = 10;

		final iconTile = h2d.Tile.fromColor(0xFF0000);
		iconTile.setSize(targetButtonSize, targetButtonSize);
		final iconBmp = new h2d.Bitmap(iconTile.center());

		fui.addChild(iconBmp);

		final tf = new h2d.Text(hxd.res.DefaultFont.get(), fui);
		tf.text = text;
		tf.setScale(2);
		tf.textAlign = Center;

		return {
			fui: fui,
			tf: tf
		}
	}

	private function selectScene(gameScene:GameScene) {
		if (selectSceneCallback != null) {
			selectSceneCallback(gameScene);
		}
	}
}
