package game.scene.impl;

import h2d.Tile;
import h2d.Bitmap;
import hxd.Event.EventKind;
import game.scene.SceneManager.GameScene;
import game.scene.base.BasicScene;

class PlayContent extends h2d.Object {

	public function new(scene:h2d.Scene) {
		super(scene);

		// Top bar players online
		final textPlayersOnline = new h2d.Text(hxd.res.DefaultFont.get(), this);
		textPlayersOnline.setPosition(15, 15);
		textPlayersOnline.text = 'Players online: 100';
		textPlayersOnline.setScale(2);

		// Top bar player info
		final fuiUserInfo = new h2d.Flow(this);
		fuiUserInfo.layout = Vertical;
		fuiUserInfo.verticalSpacing = 10;

		final textUsername = new h2d.Text(hxd.res.DefaultFont.get(), fuiUserInfo);
		textUsername.text = 'Andrey Sokolov';
		textUsername.setScale(2);

		fuiUserInfo.setPosition(BasicScene.ActualScreenWidth - (textUsername.calcTextWidth('Andrey Sokolov') * 2) - 15, 15);

		final textUserBalance = new h2d.Text(hxd.res.DefaultFont.get(), fuiUserInfo);
		textUserBalance.text = 'Balance: 12000';
		textUserBalance.setScale(2);

		fuiUserInfo.setPosition(BasicScene.ActualScreenWidth - (textUserBalance.calcTextWidth('Balance: 12000') * 2) - 15, 15);

		// Current ragnar
		final ragnar = new h2d.Bitmap(hxd.Res.ragnar.ragnar_loh.toTile().center(), this);
		ragnar.setPosition(BasicScene.ActualScreenWidth / 2, BasicScene.ActualScreenHeight / 4);
		ragnar.setScale(1.5);

		// Level up button
		final levelUpButton = addButton(this, 'Level up', function callback(button:h2d.Flow) {
			trace('Level up');
		});
		levelUpButton.setPosition(ragnar.x - 128, ragnar.y + 128 * 2);

		// Play Button
		final playButton = addButton(this, 'Play', function callback(button:h2d.Flow) {
			trace('Play');
		});
		playButton.setPosition(ragnar.x - 128, ragnar.y + 128 * 4);

	}

	public function addButton(parent:h2d.Object, label: String, onClick: h2d.Flow -> Void) {
		final f = new h2d.Flow(parent);
		f.paddingHorizontal = 128;
		f.paddingVertical = 64;
		f.backgroundTile = h2d.Tile.fromColor(0x404040);
		var tf = new h2d.Text(hxd.res.DefaultFont.get(), f);
		tf.text = label;
		f.enableInteractive = true;
		f.interactive.cursor = Button;
		f.interactive.onClick = function(_) onClick(f);
		return f;
	}

}

enum HomeSceneContent {
	PlayContent;
	LeadersContent;
	BoostContent;
	CollectionContent;
	FriendsContent;
}

class HomeScene extends BasicScene {
	private var selectSceneCallback:GameScene->Void;

	private var homeSceneContent = HomeSceneContent.PlayContent;

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

		menuButtonSize = Std.int(BasicScene.ActualScreenWidth / 5);
		menuButtonSizeHalf = Std.int(menuButtonSize / 2);

		final b1 = addBottomBarButton(menuButtonSize, 'Play');
		buttonBottomPosY = BasicScene.ActualScreenHeight - menuButtonSizeHalf - (b1.tf.getSize().height * 2);

		b1.fui.setPosition(menuButtonSizeHalf, buttonBottomPosY);

		final b2 = addBottomBarButton(menuButtonSize, 'Leaders');
		b2.fui.setPosition(menuButtonSize + menuButtonSizeHalf, buttonBottomPosY);

		final b3 = addBottomBarButton(menuButtonSize, 'Boost');
		b3.fui.setPosition(menuButtonSize * 2 + menuButtonSizeHalf, buttonBottomPosY);

		final b4 = addBottomBarButton(menuButtonSize, 'Collection');
		b4.fui.setPosition(menuButtonSize * 3 + menuButtonSizeHalf, buttonBottomPosY);

		final b5 = addBottomBarButton(menuButtonSize, 'Friends');
		b5.fui.setPosition(menuButtonSize * 4 + menuButtonSizeHalf, buttonBottomPosY);

		setSceneContent();
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

	private function setSceneContent() {
		switch (homeSceneContent) {
			case PlayContent:
				addChild(new PlayContent(this));
			default:
		}
	}

	private function selectScene(gameScene:GameScene) {
		if (selectSceneCallback != null) {
			selectSceneCallback(gameScene);
		}
	}
}
