package game.scene.impl;

import engine.base.MathUtils;
import hxd.res.DefaultFont;
import h2d.Bitmap;

import game.scene.home.CollectionContent;
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
		super(null);

		setSceneContent(HomeSceneContent.HomePlayContent);

		final heightRatio = BasicScene.ActualScreenHeight / 1280;
		final heightScale = heightRatio == 1 ? 1 : 1.1;

        final homeFrame = new h2d.Bitmap(hxd.Res.ui.home.home_frame.toTile(), this);
		homeFrame.scaleY = heightRatio;

		// ---------------------------------------------------
		// Bottom bar buttons
		// ---------------------------------------------------

		menuButtonSize = Std.int(BasicScene.ActualScreenWidth / 6) + 10;
		menuButtonSizeHalf = Std.int(menuButtonSize / 2);
		buttonBottomPosY = BasicScene.ActualScreenHeight - (menuButtonSizeHalf / (heightRatio == 1 ? 1.2 : 1));

		final homeTileOn = hxd.Res.ui.home.button_home_on.toTile().center();
		final homeTileOff = hxd.Res.ui.home.button_home_off.toTile().center();

		final boostTileOn = hxd.Res.ui.home.button_boost_on.toTile().center();
		final boostTileOff = hxd.Res.ui.home.button_boost_off.toTile().center();

		final collectionTileOn = hxd.Res.ui.home.button_collect_on.toTile().center();
		final collectionTileOff = hxd.Res.ui.home.button_collect_off.toTile().center();

		final friendsTileOn = hxd.Res.ui.home.button_friends_on.toTile().center();
		final friendsTileOff = hxd.Res.ui.home.button_friends_off.toTile().center();
		
		final bottomButtonHome = new h2d.Bitmap(homeTileOn, this);
		final bottomButtonBoost = new h2d.Bitmap(boostTileOff, this);
		final bottomButtonCollection = new h2d.Bitmap(collectionTileOff, this);
		final bottomButtonFriends = new h2d.Bitmap(friendsTileOff, this);

		// Home button

		bottomButtonHome.setPosition(menuButtonSize, buttonBottomPosY);
		bottomButtonHome.setScale(heightScale);

		final interactionHome = new h2d.Interactive(bottomButtonHome.tile.width, bottomButtonHome.tile.height);
		interactionHome.setPosition(menuButtonSize - bottomButtonHome.tile.width / 2, buttonBottomPosY - bottomButtonHome.tile.height / 2);
		addChild(interactionHome);

		interactionHome.onPush = function(event : hxd.Event) {
			if (this.homeSceneContent != HomeSceneContent.HomePlayContent) {
				bottomButtonHome.tile = homeTileOff;
			} else {
				bottomButtonHome.tile = homeTileOn;
			}
		}
		interactionHome.onRelease = function(event : hxd.Event) {
			if (this.homeSceneContent != HomeSceneContent.HomePlayContent) {
				bottomButtonHome.tile = homeTileOn;
			} else {
				bottomButtonHome.tile = homeTileOff;
			}
		}
		interactionHome.onClick = function(event : hxd.Event) {
			SceneManager.Sound.playButton1();
			if (this.homeSceneContent != HomeSceneContent.HomePlayContent) {
				bottomButtonBoost.tile = boostTileOff;
				bottomButtonCollection.tile = collectionTileOff;
				bottomButtonFriends.tile = friendsTileOff;
				setSceneContent(HomeSceneContent.HomePlayContent);
			}
		}

		// Boost button

		bottomButtonBoost.setPosition(menuButtonSize * 2.2, buttonBottomPosY);
		bottomButtonBoost.setScale(heightScale);

		final interactionBoost = new h2d.Interactive(bottomButtonBoost.tile.width, bottomButtonBoost.tile.height);
		interactionBoost.setPosition(menuButtonSize * 2.2 - bottomButtonBoost.tile.width / 2, buttonBottomPosY - bottomButtonBoost.tile.height / 2);
		addChild(interactionBoost);

		interactionBoost.onPush = function(event : hxd.Event) {
			if (this.homeSceneContent != HomeSceneContent.HomeBoostContent) {
				bottomButtonBoost.tile = boostTileOff;
			} else {
				bottomButtonBoost.tile = boostTileOn;
			}
		}
		interactionBoost.onRelease = function(event : hxd.Event) {
			if (this.homeSceneContent != HomeSceneContent.HomeBoostContent) {
				bottomButtonBoost.tile = boostTileOn;
			} else {
				bottomButtonBoost.tile = boostTileOff;
			}
		}
		interactionBoost.onClick = function(event : hxd.Event) {
			SceneManager.Sound.playButton1();
			if (this.homeSceneContent != HomeSceneContent.HomeBoostContent) {
				bottomButtonHome.tile = homeTileOff;
				bottomButtonCollection.tile = collectionTileOff;
				bottomButtonFriends.tile = friendsTileOff;
				setSceneContent(HomeSceneContent.HomeBoostContent);
			}
		}

		// Collection button

		bottomButtonCollection.setPosition(menuButtonSize * 3.4, buttonBottomPosY);
		bottomButtonCollection.setScale(heightScale);

		final interactionCollection = new h2d.Interactive(bottomButtonCollection.tile.width, bottomButtonCollection.tile.height);
		interactionCollection.setPosition(menuButtonSize * 3.4 - bottomButtonCollection.tile.width / 2, buttonBottomPosY - bottomButtonCollection.tile.height / 2);
		addChild(interactionCollection);

		interactionCollection.onPush = function(event : hxd.Event) {
			if (this.homeSceneContent != HomeSceneContent.HomeCollectionContent) {
				bottomButtonCollection.tile = collectionTileOff;
			} else {
				bottomButtonCollection.tile = collectionTileOn;
			}
		}
		interactionCollection.onRelease = function(event : hxd.Event) {
			if (this.homeSceneContent != HomeSceneContent.HomeCollectionContent) {
				bottomButtonCollection.tile = collectionTileOn;
			} else {
				bottomButtonCollection.tile = collectionTileOff;
			}
		}
		interactionCollection.onClick = function(event : hxd.Event) {
			SceneManager.Sound.playButton1();
			if (this.homeSceneContent != HomeSceneContent.HomeCollectionContent) {
				bottomButtonHome.tile = homeTileOff;
				bottomButtonBoost.tile = boostTileOff;
				bottomButtonFriends.tile = friendsTileOff;
				setSceneContent(HomeSceneContent.HomeCollectionContent);
			}
		}

		// Friends button

		bottomButtonFriends.setPosition(menuButtonSize * 4.6, buttonBottomPosY);
		bottomButtonFriends.setScale(heightScale);

		final interactionFriends = new h2d.Interactive(bottomButtonFriends.tile.width, bottomButtonFriends.tile.height);
		interactionFriends.setPosition(menuButtonSize * 4.6 - bottomButtonFriends.tile.width / 2, buttonBottomPosY - bottomButtonFriends.tile.height / 2);
		addChild(interactionFriends);

		interactionFriends.onPush = function(event : hxd.Event) {
			if (this.homeSceneContent != HomeSceneContent.HomeFriendsContent) {
				bottomButtonFriends.tile = friendsTileOff;
			} else {
				bottomButtonFriends.tile = friendsTileOn;
			}
		}
		interactionFriends.onRelease = function(event : hxd.Event) {
			if (this.homeSceneContent != HomeSceneContent.HomeFriendsContent) {
				bottomButtonFriends.tile = friendsTileOn;
			} else {
				bottomButtonFriends.tile = friendsTileOff;
			}
		}
		interactionFriends.onClick = function(event : hxd.Event) {
			SceneManager.Sound.playButton1();
			if (this.homeSceneContent != HomeSceneContent.HomeFriendsContent) {
				bottomButtonHome.tile = homeTileOff;
				bottomButtonBoost.tile = boostTileOff;
				bottomButtonCollection.tile = collectionTileOff;
				setSceneContent(HomeSceneContent.HomeFriendsContent);
			}
		}

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
