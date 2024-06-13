package game.scene.impl;

import game.scene.home.CollectionContent;
import h2d.Bitmap;
import hxd.Event.EventKind;
import game.scene.home.BoostContent;
import game.scene.home.FriendsContent;
import game.scene.base.BasicScene;
import game.scene.home.BasicHomeContent;
import game.scene.home.PlayContent;

enum HomeSceneContent {
	HomePlayContent;
	HomeLeadersContent;
	HomeBoostContent;
	HomeCollectionContent;
	HomeFriendsContent;
}

class HomeScene extends BasicScene {
	private var homeSceneContent:HomeSceneContent;
	private var pageContent:BasicHomeContent;

	private var menuButtonSize = 0.0;
	private var menuButtonSizeHalf = 0.0;
	private var buttonBottomPosY = 0.0;

	public function new() {
		super(null, function callback(params:BasicSceneClickCallback) {
			if (params.eventKind == EventKind.EPush && params.clickY > buttonBottomPosY - menuButtonSize) {
				if (params.clickX <= menuButtonSize) {
					setSceneContent(HomeSceneContent.HomePlayContent);
					SceneManager.Sound.playButton1();
				} 
				if (params.clickX >= menuButtonSize * 4 && params.clickX <= menuButtonSize * 5) {
					setSceneContent(HomeSceneContent.HomeFriendsContent);
					SceneManager.Sound.playButton1();
				}
				if (params.clickX >= menuButtonSize * 2 && params.clickX <= menuButtonSize * 3) {
					setSceneContent(HomeSceneContent.HomeBoostContent);
					SceneManager.Sound.playButton1();
				}

				if (params.clickX >= menuButtonSize * 3 && params.clickX <= menuButtonSize * 4) {
					setSceneContent(HomeSceneContent.HomeCollectionContent);
					SceneManager.Sound.playButton1();
				}
			}
		});

		setSceneContent(HomeSceneContent.HomePlayContent);

		// Bottom bar buttons

        final homeFrame = new h2d.Bitmap(hxd.Res.ui.home.home_frame.toTile(), this);
		homeFrame.scaleY = BasicScene.ActualScreenHeight / 1280;

		// ragnar.setPosition(BasicScene.ActualScreenWidth / 2, BasicScene.ActualScreenHeight / 4);
		// ragnar.setScale(1.5);

		menuButtonSize = Std.int(BasicScene.ActualScreenWidth / 5);
		menuButtonSizeHalf = Std.int(menuButtonSize / 2);

		final b1 = addBottomBarButton(menuButtonSize, 'Play');
		buttonBottomPosY = BasicScene.ActualScreenHeight - menuButtonSizeHalf - (b1.tf.getSize().height * 2);

		b1.fui.setPosition(menuButtonSizeHalf, buttonBottomPosY);

		// final b2 = addBottomBarButton(menuButtonSize, 'Leaders');
		// b2.fui.setPosition(menuButtonSize + menuButtonSizeHalf, buttonBottomPosY);

		final b3 = addBottomBarButton(menuButtonSize, 'Boost');
		b3.fui.setPosition(menuButtonSize * 2 + menuButtonSizeHalf, buttonBottomPosY);

		final b4 = addBottomBarButton(menuButtonSize, 'Collection');
		b4.fui.setPosition(menuButtonSize * 3 + menuButtonSizeHalf, buttonBottomPosY);

		final b5 = addBottomBarButton(menuButtonSize, 'Friends');
		b5.fui.setPosition(menuButtonSize * 4 + menuButtonSizeHalf, buttonBottomPosY);

		// 

		SceneManager.Sound.playMenuTheme();
	}

	// --------------------------------------
	// Impl
	// --------------------------------------

	public function start() {}

	public function customUpdate(dt:Float, fps:Float) {
		if (pageContent != null) {
			pageContent.update(dt);
		}
	}

	// --------------------------------------
	// Common
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

	private function setSceneContent(homeSceneContent:HomeSceneContent) {
		if (this.homeSceneContent != homeSceneContent) {
			this.homeSceneContent = homeSceneContent;

			if (pageContent != null) {
				removeChild(pageContent);
				pageContent = null;
			}

			switch (homeSceneContent) {
				case HomePlayContent:
					pageContent = new PlayContent(this); 
				// case LeadersContent:
				// 	pageContent = new LeadersContent(this); 
				case HomeBoostContent:
					pageContent = new BoostContent(this); 
				case HomeCollectionContent:
					pageContent = new CollectionContent(this); 
				case HomeFriendsContent:
					pageContent = new FriendsContent(this); 
				default:
			}

			addChildAt(pageContent, 0);
		}
	}

}
