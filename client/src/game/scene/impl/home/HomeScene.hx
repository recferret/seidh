package game.scene.impl.home;

import h2d.filter.Displacement;
import h2d.Bitmap;
import h3d.Engine;

import engine.base.MathUtils;
import engine.base.geometry.Point;

import game.analytics.Analytics;
import game.event.EventManager;
import game.network.Networking.UserBalancePayload;
import game.scene.base.BasicScene;
import game.scene.impl.home.collection.CollectionContent;
import game.scene.impl.home.boost.BoostContent;
import game.scene.impl.home.friends.FriendsContent;
import game.scene.impl.home.play.PlayContent;
import game.scene.impl.home.BasicHomeContent;
import game.sound.SoundManager;
import game.tilemap.TilemapManager;
import game.ui.dialog.Dialog.DialogManager;
import game.ui.text.TextUtils;
import game.ui.text.TextIcon;
import game.Res.SeidhResource;

enum HomeSceneContent {
	HomePlayContent;
	HomeLeadersContent;
	HomeBoostContent;
	HomeCollectionContent;
	HomeFriendsContent;
}

class HomeScene extends BasicScene implements EventListener {
	private final playContent = new PlayContent();
	private final boostContent = new BoostContent();
	private final collectionContent = new CollectionContent();
	private final friendsContent = new FriendsContent();

	private var homeSceneContent:HomeSceneContent;
	private var pageContent:BasicHomeContent;

    private var titleText:h2d.Text;
	private var usernameText:h2d.Text;
	private var friendsTextIcon:TextIcon;
	private var coinsTextIcon:TextIcon;
	private var teethTextIcon:TextIcon;

    private var screenDarknessDisplacementTile:h2d.Tile;

	private var inTouch = false;
	private var touchStarted = false;
	private var lastTouchPos = new Point(0, 0);
	private var timeSinceLastTouch = 0.0;
	private final touchActivationTime = 0.100;

	private var contentObject:h2d.Object;
	private final contentObjectOffsetX = 0.0;
	private final contentObjectOffsetY = 0.0;

	public function new() {
		super(function callback(params: BasicSceneClickCallback) {
			if (homeSceneContent == HomeSceneContent.HomeBoostContent) {
				if (!touchStarted) {
					touchStarted = true;
				}

				if (inTouch) {
					timeSinceLastTouch = 0.0;

					final touchPosDiff = new Point(
						Math.abs(lastTouchPos.x - params.x),
						Math.abs(lastTouchPos.y - params.y),
					);

					if (params.y > lastTouchPos.y) {
						pageContent.contentScrollY += touchPosDiff.y;
					} else if (params.y < lastTouchPos.y) {
						if (DeviceInfo.ActualScreenHeight >= 1280) {
							if (BoostContent.LastCardPosY - 100 > DeviceInfo.JsScreenParams.screenHeight) {
								pageContent.contentScrollY -= touchPosDiff.y;
							}
						} else {
							if (BoostContent.LastCardPosY > DeviceInfo.JsScreenParams.screenHeight) {
								pageContent.contentScrollY -= touchPosDiff.y;
							}
						}
					}

					if (pageContent.contentScrollY > 0) {
						pageContent.contentScrollY = 0;
					}
				}

				lastTouchPos.x = params.x;
				lastTouchPos.y = params.y;
			}
		});

		contentObject = new h2d.Object(this);

		if (!DeviceInfo.IsMobile) {
			contentObjectOffsetX = DeviceInfo.ActualScreenWidth / 2 - (720 / 2);
			contentObjectOffsetY = DeviceInfo.ActualScreenHeight / 2 - (1280 / 2);

			final intContentObjectOffsetX = Std.int(contentObjectOffsetX);
			final intContentObjectOffsetY = Std.int(contentObjectOffsetY);

			final topBlackEmptySpaceBitmap = new h2d.Bitmap(h2d.Tile.fromColor(0x0000000, DeviceInfo.ActualScreenWidth, intContentObjectOffsetY));
			topBlackEmptySpaceBitmap.setPosition(0, 0);
			addChild(topBlackEmptySpaceBitmap);

			final bottomBlackEmptySpaceBitmap = new h2d.Bitmap(h2d.Tile.fromColor(0x0000000, DeviceInfo.ActualScreenWidth, intContentObjectOffsetY));
			bottomBlackEmptySpaceBitmap.setPosition(0, DeviceInfo.ActualScreenHeight - intContentObjectOffsetY);
			addChild(bottomBlackEmptySpaceBitmap);

			final leftBlackEmptySpaceBitmap = new h2d.Bitmap(h2d.Tile.fromColor(0x0000000, intContentObjectOffsetX, DeviceInfo.ActualScreenHeight));
			leftBlackEmptySpaceBitmap.setPosition(0, 0);
			addChild(leftBlackEmptySpaceBitmap);

			final rightBlackEmptySpaceBitmap = new h2d.Bitmap(h2d.Tile.fromColor(0x0000000, intContentObjectOffsetX, DeviceInfo.ActualScreenHeight));
			rightBlackEmptySpaceBitmap.setPosition(DeviceInfo.ActualScreenWidth - intContentObjectOffsetX, 0);
			addChild(rightBlackEmptySpaceBitmap);
		}
		contentObject.setPosition(contentObjectOffsetX, contentObjectOffsetY);

		setSceneContent(HomeSceneContent.HomePlayContent);
		generateBackground();
		frame();
		headerItems();
		bottomButtons();

		SoundManager.instance.playMenuTheme();
		EventManager.instance.subscribe(EventManager.EVENT_USER_BALANCE, this);
	}

	// --------------------------------------
	// Abstraction
	// --------------------------------------

	public function absOnEvent(event:hxd.Event) {}

	public function absStart() {}

	public function absOnResize(w:Int, h:Int) {}

	public function absRender(e:Engine) {}

	public function absDestroy() {}

	public function absUpdate(dt:Float, fps:Float) {
		if (pageContent != null) {
			var discreteX = 1.0;
			var discreteY = 7.0;

			if (DeviceInfo.IsMobile && DeviceInfo.ScreenOrientation == 'landscape') {
				discreteX = discreteY = 5.0;
			}

			screenDarknessDisplacementTile.scrollDiscrete(discreteX * dt, discreteY * dt);
			pageContent.update(dt);

			if (touchStarted) {
				if (timeSinceLastTouch == 0.0 || timeSinceLastTouch <= touchActivationTime) {
					inTouch = true;
				} else {
					inTouch = false;
					touchStarted = false;
					timeSinceLastTouch = 0.0;
					lastTouchPos.x = 0;
					lastTouchPos.y = 0;
				}

				timeSinceLastTouch += dt;
			}
		}
	}

	public function notify(event:String, message:Dynamic) {
		switch (event) {
			case EventManager.EVENT_USER_BALANCE:
				processUserBalanceEvent(message);
		}
	}

	// --------------------------------------
	// UI elements
	// --------------------------------------

	private function headerItems() {
		final tgFullscreenOffsetY = DeviceInfo.IsMobile ? 80 : 0;

		titleText = TextUtils.GetDefaultTextObject(
			DeviceInfo.TargetPortraitScreenWidth / 2 + contentObjectOffsetX,
			70 + contentObjectOffsetY,
			1.5,
			Center,
			GameClientConfig.DefaultFontColor,
		);
		titleText.text = 'HOME';
		addChild(titleText);

		usernameText = TextUtils.GetDefaultTextObject(
			80 + contentObjectOffsetX,
			70 + contentObjectOffsetY + tgFullscreenOffsetY,
			1,
			Left,
			GameClientConfig.DefaultFontColor,
		);
		usernameText.text = Player.instance.userInfo.userName;
        addChild(usernameText);

		friendsTextIcon = new TextIcon(this, TilemapManager.instance.getTile(TileType.WEALTH_FRIENDS), Left, 10);
		friendsTextIcon.setText('0/0');
		friendsTextIcon.setPosition(
			100 + contentObjectOffsetX,
			120 + contentObjectOffsetY + tgFullscreenOffsetY,
		);
		
		coinsTextIcon = new TextIcon(this, TilemapManager.instance.getTile(TileType.WEALTH_COINS), Right, 10);
		coinsTextIcon.setText(Std.string(Player.instance.userInfo.coins));
		coinsTextIcon.setPosition(
			DeviceInfo.TargetPortraitScreenWidth - 90 + contentObjectOffsetX,
			80 + contentObjectOffsetY + tgFullscreenOffsetY,
		);

		teethTextIcon = new TextIcon(this, TilemapManager.instance.getTile(TileType.WEALTH_TEETH), Right, 5);
		teethTextIcon.setText(Std.string(Player.instance.userInfo.teeth));
		teethTextIcon.setPosition(
			DeviceInfo.TargetPortraitScreenWidth - 90 + contentObjectOffsetX,
			120 + contentObjectOffsetY + tgFullscreenOffsetY,
		);
	}

	private function frame() {
		new HomeFrame(this, contentObjectOffsetX, contentObjectOffsetY);
	}

	private function bottomButtons() {
		// ---------------------------------------------------
		// Bottom bar buttons
		// ---------------------------------------------------

		final menuButtonWidth = Std.int(DeviceInfo.TargetPortraitScreenWidth / 6) + 10;
		final buttonBottomPosY = DeviceInfo.TargetPortraitScreenHeight - 84;

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
		bottomButtonHome.setPosition(
			(menuButtonWidth + 9) + contentObjectOffsetX, 
			buttonBottomPosY + contentObjectOffsetY + 6,
		);

		final interactionHome = new h2d.Interactive(bottomButtonHome.tile.width, bottomButtonHome.tile.height);
		interactionHome.setPosition(
			menuButtonWidth - bottomButtonHome.tile.width / 2 + contentObjectOffsetX,
			buttonBottomPosY - bottomButtonHome.tile.height / 2 + contentObjectOffsetY,
		);
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
				titleText.text = 'HOME';

				SoundManager.instance.playButton1();
				Analytics.instance.trackHomeClick();

				bottomButtonBoost.tile = boostTileOff;
				bottomButtonCollection.tile = collectionTileOff;
				bottomButtonFriends.tile = friendsTileOff;
				setSceneContent(HomeSceneContent.HomePlayContent);
			}
		}

		// Boost button
		bottomButtonBoost.setPosition(
			(menuButtonWidth + 13) * 2 + contentObjectOffsetX,
			buttonBottomPosY + contentObjectOffsetY + 6,
		);

		final interactionBoost = new h2d.Interactive(bottomButtonBoost.tile.width, bottomButtonBoost.tile.height);
		interactionBoost.setPosition(
			menuButtonWidth * 2.2 - bottomButtonBoost.tile.width / 2 + contentObjectOffsetX, 
			buttonBottomPosY - bottomButtonBoost.tile.height / 2 + contentObjectOffsetY,
		);
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
				titleText.text = 'BOOSTS';

				SoundManager.instance.playButton1();
				Analytics.instance.trackBoostsClick();

				bottomButtonHome.tile = homeTileOff;
				bottomButtonCollection.tile = collectionTileOff;
				bottomButtonFriends.tile = friendsTileOff;
				setSceneContent(HomeSceneContent.HomeBoostContent);
			}
		}

		// Collection button
		bottomButtonCollection.setPosition(
			(menuButtonWidth + 14) * 3 + contentObjectOffsetX, 
			buttonBottomPosY + contentObjectOffsetY + 6,
		);

		final interactionCollection = new h2d.Interactive(bottomButtonCollection.tile.width, bottomButtonCollection.tile.height);
		interactionCollection.setPosition(
			menuButtonWidth * 3.4 - bottomButtonCollection.tile.width / 2 + contentObjectOffsetX, 
			buttonBottomPosY - bottomButtonCollection.tile.height / 2 + contentObjectOffsetY,
		);
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
				titleText.text = 'COLLECTION';

				SoundManager.instance.playButton1();
				Analytics.instance.trackCollectionClick();

				bottomButtonHome.tile = homeTileOff;
				bottomButtonBoost.tile = boostTileOff;
				bottomButtonFriends.tile = friendsTileOff;
				setSceneContent(HomeSceneContent.HomeCollectionContent);
			}
		}

		// Friends button
		bottomButtonFriends.setPosition(
			(menuButtonWidth + 15) * 4 + contentObjectOffsetX,
			buttonBottomPosY + contentObjectOffsetY + 6,
		);

		final interactionFriends = new h2d.Interactive(bottomButtonFriends.tile.width, bottomButtonFriends.tile.height);
		interactionFriends.setPosition(
			menuButtonWidth * 4.6 - bottomButtonFriends.tile.width / 2 + contentObjectOffsetX,
			buttonBottomPosY - bottomButtonFriends.tile.height / 2 + contentObjectOffsetY,
		);
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
				titleText.text = 'FRIENDS';

				SoundManager.instance.playButton1();
				Analytics.instance.trackFriendsClick();

				bottomButtonHome.tile = homeTileOff;
				bottomButtonBoost.tile = boostTileOff;
				bottomButtonCollection.tile = collectionTileOff;
				setSceneContent(HomeSceneContent.HomeFriendsContent);
			}
		}
	}

	private function generateBackground() {
        screenDarknessDisplacementTile = Res.instance.getTileResource(SeidhResource.FX_NORMALMAP);

		final backgroundObject = new h2d.Object();
		contentObject.addChildAt(backgroundObject, 0);

		// ------------------------------------
        // Grass
        // ------------------------------------

        for (x in 0...(Std.int(720 / 183) + 1)) {
            for (y in 0...(Std.int(1280 / 183) + 1)) {
                var groundTile:h2d.Tile = null; 
                final groundRnd = MathUtils.randomIntInRange(1, 4);

                if (groundRnd == 1) {
                    groundTile = Res.instance.getTileResource(SeidhResource.TERRAIN_GROUND_1);
                } else if (groundRnd == 2) {
                    groundTile = Res.instance.getTileResource(SeidhResource.TERRAIN_GROUND_2);
                } else if (groundRnd == 3) {
                    groundTile = Res.instance.getTileResource(SeidhResource.TERRAIN_GROUND_3);
                } else if (groundRnd == 4) {
                    groundTile = Res.instance.getTileResource(SeidhResource.TERRAIN_GROUND_4);
                }

                final grass = new h2d.Bitmap(groundTile, backgroundObject);
                grass.setPosition(
					grass.tile.width / 2 + (x * grass.tile.width),
					grass.tile.height / 2 + (y * grass.tile.height),
				);
            }
        }

        // ------------------------------------
        // Trees
        // ------------------------------------

        inline function placeTree(x:Float, y:Float) {
            final treeBitmap = MathUtils.randomIntInRange(1, 2) == 1 ? 
                new h2d.Bitmap(Res.instance.getTileResource(SeidhResource.TERRAIN_TREE_1)) : 
                new h2d.Bitmap(Res.instance.getTileResource(SeidhResource.TERRAIN_TREE_2));
            treeBitmap.setPosition(x, y);
            backgroundObject.addChild(treeBitmap);
        }

        placeTree(70, 600);
        placeTree(100, 210);
        placeTree(160, 320);
        placeTree(300, 280);

        placeTree(500, 300);
        placeTree(400, 200);
        placeTree(600, 350);
        placeTree(660, 550);

        // ------------------------------------
        // Weed
        // ------------------------------------

        inline function placeWeed(x:Float, y:Float) {
            final treeBitmap = MathUtils.randomIntInRange(1, 2) == 1 ? 
                new h2d.Bitmap(Res.instance.getTileResource(SeidhResource.TERRAIN_WEED_1)) : 
                new h2d.Bitmap(Res.instance.getTileResource(SeidhResource.TERRAIN_WEED_2));
            treeBitmap.setPosition(x, y);
            backgroundObject.addChild(treeBitmap);
        }

        placeWeed(100, 1200);
        placeWeed(200, 1100);

        placeWeed(600, 1100);

        // ------------------------------------
        // Shadow
        // ------------------------------------

        final darkness = new h2d.Bitmap(Res.instance.getTileResource(SeidhResource.UI_HOME_DARKNESS), contentObject);

		if (DeviceInfo.IsMobile) {
			if (DeviceInfo.ScreenOrientation == 'landscape') {
				darkness.scaleY = DeviceInfo.ActualScreenWidth / 1280;
				darkness.rotate(MathUtils.degreeToRads(90));
			} else {
				darkness.scaleY = DeviceInfo.ActualScreenHeight / 1280;
			}
		}

        darkness.filter = new Displacement(screenDarknessDisplacementTile, 14, 14);
        darkness.setPosition(DeviceInfo.TargetPortraitScreenWidth / 2, DeviceInfo.TargetPortraitScreenHeight / 2);
	}

	// --------------------------------------
	// General
	// --------------------------------------

	private function setSceneContent(homeSceneContent:HomeSceneContent) {
		if (this.homeSceneContent != homeSceneContent) {
			this.homeSceneContent = homeSceneContent;

			if (pageContent != null) {
				contentObject.removeChild(pageContent);
				pageContent = null;
			}

			switch (homeSceneContent) {
				case HomePlayContent:
					pageContent = playContent;
				case HomeBoostContent:
					pageContent = boostContent;
				case HomeCollectionContent:
					pageContent = collectionContent;
				case HomeFriendsContent:
					pageContent = friendsContent;
				default:
			}

			contentObject.addChildAt(pageContent, 1);
		}
	}

	private function processUserBalanceEvent(payload:UserBalancePayload) {
		Player.instance.userInfo.coins = payload.coins;
		Player.instance.userInfo.teeth = payload.teeth;

		coinsTextIcon.setText(Std.string(Player.instance.userInfo.coins));
		teethTextIcon.setText(Std.string(Player.instance.userInfo.teeth));
	}

}
