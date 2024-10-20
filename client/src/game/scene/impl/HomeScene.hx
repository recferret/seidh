package game.scene.impl;

import hxd.res.DefaultFont;
import game.tilemap.TilemapManager;
import game.ui.text.WealthTextIcon;
import engine.base.MathUtils;
import h2d.filter.Displacement;
import engine.base.geometry.Point;
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
	private final playContent = new PlayContent();
	private final boostContent = new BoostContent();
	private final collectionContent = new CollectionContent();
	private final friendsContent = new FriendsContent();

	private var homeSceneContent:HomeSceneContent;
	private var pageContent:BasicHomeContent;

	private var usernameText:h2d.Text;
	private var friendsTextIcon:WealthTextIcon;
	private var coinsTextIcon:WealthTextIcon;
	private var teethTextIcon:WealthTextIcon;

    private var titleBitmap:h2d.Bitmap;
    private var collectionTitleTile:h2d.Tile;
    private var friendsTitleTile:h2d.Tile;
    private var storeTitleTile:h2d.Tile;
    private var screenDarknessDisplacementTile:h2d.Tile;

	private var inTouch = false;
	private var touchStarted = false;
	private var lastTouchPos = new Point(0, 0);
	private var timeSinceLastTouch = 0.0;
	private final touchActivationTime = 0.100; 

	public function new() {
		super(null, function callback(params: BasicSceneClickCallback) {
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
						pageContent.contentScrollY -= touchPosDiff.y;
					}

					if (pageContent.contentScrollY < 0 || pageContent.y > 0) {
						pageContent.contentScrollY = 0;
					}
				}

				lastTouchPos.x = params.x;
				lastTouchPos.y = params.y;
			}
		});

		headerItems();
		generateBackground();
		frame();
		setSceneContent(HomeSceneContent.HomePlayContent);
		bottomButtons();

		SoundManager.instance.playMenuTheme();
		EventManager.instance.subscribe(EventManager.EVENT_USER_BALANCE, this);
	}

	// --------------------------------------
	// Impl
	// --------------------------------------

	public function start() {}

	public function customUpdate(dt:Float, fps:Float) {
		if (pageContent != null) {
			screenDarknessDisplacementTile.scrollDiscrete(1 * dt, 7 * dt);
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
        collectionTitleTile = Res.instance.getTileResource(SeidhResource.UI_HOME_TITLE_COLLECTION);
		friendsTitleTile = Res.instance.getTileResource(SeidhResource.UI_HOME_TITLE_FRIENDS);
		storeTitleTile = Res.instance.getTileResource(SeidhResource.UI_HOME_TITLE_STORE);

		titleBitmap = new h2d.Bitmap(this);
		titleBitmap.alpha = 0;
		titleBitmap.setPosition(Main.ActualScreenWidth / 2, 100);

		usernameText = new h2d.Text(DefaultFont.get());
        usernameText.textColor = GameConfig.FontColor;
        usernameText.dropShadow = { dx : 0.5, dy : 0.5, color : 0xFF0000, alpha : 0.8 };
        usernameText.textAlign = Left;
		usernameText.text = "FerretRec";
        usernameText.setScale(2);
		usernameText.setPosition(80, 70);
        addChild(usernameText);

		friendsTextIcon = new WealthTextIcon(this, TilemapManager.instance.getTile(TileType.WEALTH_FRIENDS), Left);
		friendsTextIcon.setText('10/100');
		friendsTextIcon.setPosition(100, 120);
		
		coinsTextIcon = new WealthTextIcon(this, TilemapManager.instance.getTile(TileType.WEALTH_COINS), Right);
		coinsTextIcon.setText('10000');
		coinsTextIcon.setPosition(Main.ActualScreenWidth - 90, 80);

		teethTextIcon = new WealthTextIcon(this, TilemapManager.instance.getTile(TileType.WEALTH_TEETH), Right);
		teethTextIcon.setText('100');
		teethTextIcon.setPosition(Main.ActualScreenWidth - 90, 120);
	}

	private function frame() {
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
	}

	private function bottomButtons() {
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
				titleBitmap.alpha = 0;
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
				titleBitmap.alpha = 1;
				titleBitmap.tile = storeTitleTile;

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
				titleBitmap.alpha = 1;
				titleBitmap.tile = collectionTitleTile;

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
				titleBitmap.alpha = 1;
				titleBitmap.tile = friendsTitleTile;

				SoundManager.instance.playButton1();
				NativeWindowJS.trackFriendsClick();

				bottomButtonHome.tile = homeTileOff;
				bottomButtonBoost.tile = boostTileOff;
				bottomButtonCollection.tile = collectionTileOff;
				setSceneContent(HomeSceneContent.HomeFriendsContent);
			}
		}
	}

	// --------------------------------------
	// General
	// --------------------------------------

	private function generateBackground() {
        screenDarknessDisplacementTile = Res.instance.getTileResource(SeidhResource.FX_NORMALMAP);

		final backgroundObject = new h2d.Object();
		addChildAt(backgroundObject, 0);

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
                grass.setPosition(grass.tile.width / 2 + (x * grass.tile.width), grass.tile.height / 2 + (y * grass.tile.height));
            }
        }

        // ------------------------------------
        // Trees
        // ------------------------------------

        function placeTree(x:Float, y:Float) {
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

        function placeWeed(x:Float, y:Float) {
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

        final darkness = new h2d.Bitmap(Res.instance.getTileResource(SeidhResource.UI_HOME_DARKNESS), backgroundObject);
        final darknessScaleRatio = Main.ActualScreenHeight / 1280;
        darkness.scaleY = darknessScaleRatio;

        darkness.filter = new Displacement(screenDarknessDisplacementTile, 14, 14);
        darkness.setPosition(Main.ActualScreenWidth / 2, Main.ActualScreenHeight / 2);
	}

	private function processUserBalanceEvent(payload:UserBalancePayload) {
		Player.instance.coins = payload.coins;
		Player.instance.teeth = payload.teeth;
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

			addChildAt(pageContent, 1);
		}
	}

}
