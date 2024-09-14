package game.scene.impl;

import h2d.Bitmap;

import game.js.NativeWindowJS;

import game.event.EventManager;
import game.network.Networking.UserBalancePayload;
import game.scene.home.CollectionContent;
import game.scene.home.BoostContent;
import game.scene.home.FriendsContent;
import game.scene.base.BasicScene;
import game.scene.home.BasicHomeContent;
import game.scene.home.PlayContent;
import game.sound.SoundManager;
import game.ui.dialog.Dialog.DialogManager;
import game.Res.SeidhResource;

enum HomeSceneContent {
	HomePlayContent;
	HomeLeadersContent;
	HomeBoostContent;
	HomeCollectionContent;
	HomeFriendsContent;
}

class HomeScene extends BasicScene implements EventListener {
	private var homeSceneContent:HomeSceneContent;
	private var pageContent:BasicHomeContent;

	private final playContent:PlayContent;
	private final boostContent:BoostContent;
	private final collectionContent:CollectionContent;
	private final friendsContent:FriendsContent;

	public function new() {
		super(null);

		playContent = new PlayContent();
		boostContent = new BoostContent();
		collectionContent = new CollectionContent();
		friendsContent = new FriendsContent();

        // ------------------------------------
        // Tree frame
        // ------------------------------------

        final frameHeader = new h2d.Bitmap(Res.instance.getTileResource(SeidhResource.UI_HOME_HEADER), this);
        frameHeader.setPosition(Main.ActualScreenWidth / 2, frameHeader.tile.height / 2);

        final frameFooter = new h2d.Bitmap(Res.instance.getTileResource(SeidhResource.UI_HOME_FOOTER), this);
        frameFooter.setPosition(Main.ActualScreenWidth / 2, Main.ActualScreenHeight - frameFooter.tile.height / 2);

		// Frames left
		final leftSideFrameTop = new h2d.Bitmap(Res.instance.getTileResource(SeidhResource.UI_HOME_FRAME), this);
		leftSideFrameTop.setPosition(leftSideFrameTop.tile.width / 2, frameHeader.tile.height + (leftSideFrameTop.tile.height * 1) / 2);

		for (i in 2...7) {
			final leftSideFrameMiddle = new h2d.Bitmap(Res.instance.getTileResource(SeidhResource.UI_HOME_FRAME), this);
			leftSideFrameMiddle.setPosition(leftSideFrameMiddle.tile.width / 2, frameHeader.tile.height + (leftSideFrameMiddle.tile.height * i) / 2);
		}

		final leftSideFrameBottom = new h2d.Bitmap(Res.instance.getTileResource(SeidhResource.UI_HOME_FRAME), this);
		leftSideFrameBottom.setPosition(leftSideFrameBottom.tile.width / 2, Main.ActualScreenHeight - frameFooter.tile.height + 1 - (leftSideFrameBottom.tile.height * 1) / 2);
		
		// Frames right
		final rightSideFrameTop = new h2d.Bitmap(Res.instance.getTileResource(SeidhResource.UI_HOME_FRAME), this);
		rightSideFrameTop.tile.flipX();
		rightSideFrameTop.setPosition(Main.ActualScreenWidth - rightSideFrameTop.tile.width / 2, frameHeader.tile.height + (rightSideFrameTop.tile.height * 1) / 2);

		for (i in 2...7) {
			final rightSideFrameMiddle = new h2d.Bitmap(Res.instance.getTileResource(SeidhResource.UI_HOME_FRAME), this);
			rightSideFrameMiddle.tile.flipX();
			rightSideFrameMiddle.setPosition(Main.ActualScreenWidth - rightSideFrameMiddle.tile.width / 2, frameHeader.tile.height + (rightSideFrameMiddle.tile.height * i) / 2);
		}

		final rightSideFrameBottom = new h2d.Bitmap(Res.instance.getTileResource(SeidhResource.UI_HOME_FRAME), this);
		rightSideFrameBottom.tile.flipX();
		rightSideFrameBottom.setPosition(Main.ActualScreenWidth - rightSideFrameBottom.tile.width / 2, Main.ActualScreenHeight - frameFooter.tile.height + 1 - (rightSideFrameBottom.tile.height * 1) / 2);

		// Make content above 
		setSceneContent(HomeSceneContent.HomePlayContent);

		// ---------------------------------------------------
		// Bottom bar buttons
		// ---------------------------------------------------

		final menuButtonWidth = Std.int(Main.ActualScreenWidth / 6) + 10;
		final buttonBottomPosY = Main.ActualScreenHeight - 84;

		final homeTileOn = Res.instance.getTileResource(SeidhResource.UI_HOME_HOME_YAY);
		final homeTileOff = Res.instance.getTileResource(SeidhResource.UI_HOME_HOME_NAY);

		final boostTileOn = Res.instance.getTileResource(SeidhResource.UI_HOME_BOOST_YAY);
		final boostTileOff = Res.instance.getTileResource(SeidhResource.UI_HOME_BOOST_NAY);

		final collectionTileOn = Res.instance.getTileResource(SeidhResource.UI_HOME_COLLECT_YAY);
		final collectionTileOff = Res.instance.getTileResource(SeidhResource.UI_HOME_COLLECT_NAY);

		final friendsTileOn = Res.instance.getTileResource(SeidhResource.UI_HOME_FRIEND_YAY);
		final friendsTileOff = Res.instance.getTileResource(SeidhResource.UI_HOME_FRIEND_NAY);
		
		final bottomButtonHome = new h2d.Bitmap(homeTileOn, this);
		final bottomButtonBoost = new h2d.Bitmap(boostTileOff, this);
		final bottomButtonCollection = new h2d.Bitmap(collectionTileOff, this);
		final bottomButtonFriends = new h2d.Bitmap(friendsTileOff, this);

		// Home button

		bottomButtonHome.setPosition(menuButtonWidth + 11,  buttonBottomPosY);

		final interactionHome = new h2d.Interactive(bottomButtonHome.tile.width, bottomButtonHome.tile.height);
		interactionHome.setPosition(menuButtonWidth - bottomButtonHome.tile.width / 2, buttonBottomPosY - bottomButtonHome.tile.height / 2);
		addChild(interactionHome);

		interactionHome.onPush = function(event : hxd.Event) {
			if (!DialogManager.IsDialogActive && this.homeSceneContent != HomeSceneContent.HomePlayContent) {
				bottomButtonHome.tile = homeTileOff;
			}
		}
		interactionHome.onRelease = function(event : hxd.Event) {
			if (!DialogManager.IsDialogActive && this.homeSceneContent != HomeSceneContent.HomePlayContent) {
				bottomButtonHome.tile = homeTileOn;
			}
		}
		interactionHome.onClick = function(event : hxd.Event) {
			if (!DialogManager.IsDialogActive && this.homeSceneContent != HomeSceneContent.HomePlayContent) {
				SoundManager.instance.playButton1();
				NativeWindowJS.trackHomeClick();

				bottomButtonBoost.tile = boostTileOff;
				bottomButtonCollection.tile = collectionTileOff;
				bottomButtonFriends.tile = friendsTileOff;
				setSceneContent(HomeSceneContent.HomePlayContent);
			}
		}

		// Boost button

		bottomButtonBoost.setPosition((menuButtonWidth + 13) * 2, buttonBottomPosY);

		final interactionBoost = new h2d.Interactive(bottomButtonBoost.tile.width, bottomButtonBoost.tile.height);
		interactionBoost.setPosition(menuButtonWidth * 2.2 - bottomButtonBoost.tile.width / 2, buttonBottomPosY - bottomButtonBoost.tile.height / 2);
		addChild(interactionBoost);

		interactionBoost.onPush = function(event : hxd.Event) {
			if (!DialogManager.IsDialogActive && this.homeSceneContent != HomeSceneContent.HomeBoostContent) {
				bottomButtonBoost.tile = boostTileOff;
			}
		}
		interactionBoost.onRelease = function(event : hxd.Event) {
			if (!DialogManager.IsDialogActive && this.homeSceneContent != HomeSceneContent.HomeBoostContent) {
				bottomButtonBoost.tile = boostTileOn;
			}
		}
		interactionBoost.onClick = function(event : hxd.Event) {
			if (!DialogManager.IsDialogActive && this.homeSceneContent != HomeSceneContent.HomeBoostContent) {
				SoundManager.instance.playButton1();
				NativeWindowJS.trackBoostsClick();

				bottomButtonHome.tile = homeTileOff;
				bottomButtonCollection.tile = collectionTileOff;
				bottomButtonFriends.tile = friendsTileOff;
				setSceneContent(HomeSceneContent.HomeBoostContent);
			}
		}

		// Collection button

		bottomButtonCollection.setPosition((menuButtonWidth + 14) * 3, buttonBottomPosY);

		final interactionCollection = new h2d.Interactive(bottomButtonCollection.tile.width, bottomButtonCollection.tile.height);
		interactionCollection.setPosition(menuButtonWidth * 3.4 - bottomButtonCollection.tile.width / 2, buttonBottomPosY - bottomButtonCollection.tile.height / 2);
		addChild(interactionCollection);

		interactionCollection.onPush = function(event : hxd.Event) {
			if (!DialogManager.IsDialogActive && this.homeSceneContent != HomeSceneContent.HomeCollectionContent) {
				bottomButtonCollection.tile = collectionTileOff;
			}
		}
		interactionCollection.onRelease = function(event : hxd.Event) {
			if (!DialogManager.IsDialogActive && this.homeSceneContent != HomeSceneContent.HomeCollectionContent) {
				bottomButtonCollection.tile = collectionTileOn;
			}
		}
		interactionCollection.onClick = function(event : hxd.Event) {
			if (!DialogManager.IsDialogActive && this.homeSceneContent != HomeSceneContent.HomeCollectionContent) {
				SoundManager.instance.playButton1();
				NativeWindowJS.trackCollectionClick();

				bottomButtonHome.tile = homeTileOff;
				bottomButtonBoost.tile = boostTileOff;
				bottomButtonFriends.tile = friendsTileOff;
				setSceneContent(HomeSceneContent.HomeCollectionContent);
			}
		}

		// Friends button

		bottomButtonFriends.setPosition((menuButtonWidth + 15) * 4, buttonBottomPosY);

		final interactionFriends = new h2d.Interactive(bottomButtonFriends.tile.width, bottomButtonFriends.tile.height);
		interactionFriends.setPosition(menuButtonWidth * 4.6 - bottomButtonFriends.tile.width / 2, buttonBottomPosY - bottomButtonFriends.tile.height / 2);
		addChild(interactionFriends);

		interactionFriends.onPush = function(event : hxd.Event) {
			if (!DialogManager.IsDialogActive && this.homeSceneContent != HomeSceneContent.HomeFriendsContent) {
				bottomButtonFriends.tile = friendsTileOff;
			}
		}
		interactionFriends.onRelease = function(event : hxd.Event) {
			if (!DialogManager.IsDialogActive && this.homeSceneContent != HomeSceneContent.HomeFriendsContent) {
				bottomButtonFriends.tile = friendsTileOn;
			}
		}
		interactionFriends.onClick = function(event : hxd.Event) {
			if (!DialogManager.IsDialogActive && this.homeSceneContent != HomeSceneContent.HomeFriendsContent) {
				SoundManager.instance.playButton1();
				NativeWindowJS.trackFriendsClick();

				bottomButtonHome.tile = homeTileOff;
				bottomButtonBoost.tile = boostTileOff;
				bottomButtonCollection.tile = collectionTileOff;
				setSceneContent(HomeSceneContent.HomeFriendsContent);
			}
		}

		SoundManager.instance.playMenuTheme();

		EventManager.instance.subscribe(EventManager.EVENT_USER_BALANCE, this);
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

	public function notify(event:String, message:Dynamic) {
		switch (event) {
			case EventManager.EVENT_USER_BALANCE:
				processUserBalanceEvent(message);
		}
	}

	// --------------------------------------
	// Common
	// --------------------------------------

	private function processUserBalanceEvent(payload:UserBalancePayload) {
		Player.instance.tokens = payload.balance;
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
					NativeWindowJS.trackHomeClick();
					pageContent = playContent;
				case HomeBoostContent:
					NativeWindowJS.trackBoostsClick();
					pageContent = boostContent;
				case HomeCollectionContent:
					NativeWindowJS.trackCollectionClick();
					pageContent = collectionContent;
				case HomeFriendsContent:
					NativeWindowJS.trackFriendsClick();
					pageContent = friendsContent;
				default:
			}

			addChildAt(pageContent, 0);
		}
	}

}
