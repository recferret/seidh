package game.scene.impl.game;

import h2d.Bitmap;

#if debug
import haxe.ui.Toolkit;
#end

import engine.base.MathUtils;
import engine.base.geometry.Point;
import engine.base.geometry.Rectangle;

import game.Res.SeidhResource;
import game.event.EventManager;
import game.tilemap.TilemapManager;
import game.ui.bar.BossBar;
import game.ui.bar.FilledBar;
import game.ui.bar.IconBar;
import game.ui.debug.CharacterAndZombieBalanceView;
import game.ui.dialog.Dialog;
import game.ui.text.TextUtils;
import game.utils.Utils;

enum abstract ButtonPressed(Int) {
	var A = 1;
	var B = 2;
	var X = 3;
	var Y = 4;
}

class MovementController extends h2d.Object {

	private var outerCircle:h2d.Bitmap;
	private var innerCircle:h2d.Bitmap;
	private var customGraphics:h2d.Graphics;

	private var inputActive = false;
	private var camera:h2d.Camera;

	private var angle = 0.0;
	private var controlTargetPos = new Point();
	private var lastMousePos = new h2d.col.Point();
	private var callback:Float->Void;

	private var shapeRect = new Rectangle(0,0,0,0,0);

    public function new(s2d:h2d.Scene, callback:Float->Void) {
        super(s2d);

		this.callback = callback;

		camera = s2d.camera;
		customGraphics = new h2d.Graphics(s2d);

		outerCircle = new h2d.Bitmap(Res.instance.getTileResource(SeidhResource.UI_GAME_JOYSTICK_1), this);
		innerCircle = new h2d.Bitmap(Res.instance.getTileResource(SeidhResource.UI_GAME_JOYSTICK_2), this);
		
		innerCircleDefaultPos();
    }

	public function release() {
		innerCircle.alpha = 1;
		inputActive = false;

		innerCircleDefaultPos();
	}

	public function updateCursorPosition(x:Float, y:Float) {
		var p = new h2d.col.Point(x, y);
		camera.screenToCamera(p);

		if (shapeRect.containtPoint(new Point(p.x, p.y))) {
			lastMousePos.x = x;
			lastMousePos.y = y;
			camera.screenToCamera(lastMousePos);

			innerCircle.alpha = 0.7;
			inputActive = true;

			innerCircle.setPosition(controlTargetPos.x - shapeRect.x, controlTargetPos.y - shapeRect.y);
		} else {
			innerCircle.alpha = 1;
			inputActive = false;

			innerCircleDefaultPos();
		}
	}

	public function setPositionAndUpdateShape(x:Float, y:Float, rectSize:Int) {
		setPosition(x, y);
		shapeRect = new Rectangle(x,y, rectSize, rectSize, 0);
	}

	public function update() {
		if (GameClientConfig.instance.DebugDraw) {
			customGraphics.clear();
		}

		if (inputActive) {
			final p1 = new engine.base.geometry.Point(outerCircle.localToGlobal().x, outerCircle.localToGlobal().y);
			final p2 = new engine.base.geometry.Point(lastMousePos.x, lastMousePos.y);
			angle = MathUtils.angleBetweenPoints(p1, p2);
			callback(angle);

			controlTargetPos = MathUtils.rotatePointAroundCenter(p1.x + 80, p1.y, p1.x, p1.y, angle);

			if (GameClientConfig.instance.DebugDraw) {
				customGraphics.lineStyle(2, 0xEA8220);
				customGraphics.moveTo(p1.x, p1.y);
				customGraphics.lineTo(controlTargetPos.x, controlTargetPos.y);
				customGraphics.endFill();
			}
		}

		if (GameClientConfig.instance.DebugDraw) {
			Utils.DrawRect(customGraphics, shapeRect, GameClientConfig.RedColor);
		}
	}

	private function innerCircleDefaultPos() {
		innerCircle.setPosition(
			0, 0
		);
	}
}

class GameUiScene extends h2d.Scene {

	public static final ShowDebugUi = false;

	private var frameObjects = new Array<h2d.Bitmap>();
	private var screenWidth:Int = 0;
	private var screenHeight:Int = 0;

	private final movementController:MovementController;
	private final fullScreenVerticalPaddingPercent = 12;
	private final skillSlot:h2d.Bitmap;
	private final skillIcon:h2d.Bitmap;
	private final skillSlotInteraction:h2d.Interactive;
	private final playerHealthBar:FilledBar;
	private final playerCoinsBar:IconBar;
	private final bossBar:BossBar;
	private final objectiveText:h2d.Text;

	#if debug
	private var characterAndZombieBalanceView:CharacterAndZombieBalanceView;
	#end
 
    public function new() {
        super();

		#if debug
		if (ShowDebugUi) {
			Toolkit.init({
				root: this,
				manualUpdate: false,
			});
			characterAndZombieBalanceView = new CharacterAndZombieBalanceView();
			addChild(characterAndZombieBalanceView);
		}
		#end

		// --------------------------------------------
		// Input
		// --------------------------------------------

		if (DeviceInfo.IsMobile) {
	        movementController = new MovementController(this, function callback(angle:Float) {
				EventManager.instance.notify(EventManager.EVENT_PLAYER_MOVE, angle);
        	});
		}

		skillSlot = new h2d.Bitmap(TilemapManager.instance.getTile(TileType.ICON_SKILL_BACKGROUND), this);
		skillIcon = new h2d.Bitmap(TilemapManager.instance.getTile(TileType.SKILL_ACTION_MAIN), this);

		skillSlotInteraction = new h2d.Interactive(skillSlot.tile.width, skillSlot.tile.height);
		skillSlotInteraction.onClick = function(event:hxd.Event) {
			EventManager.instance.notify(EventManager.EVENT_PLAYER_MAIN_ACTION, {});
		}
		addChild(skillSlotInteraction);

		// --------------------------------------------
		// Bars
		// --------------------------------------------

		playerHealthBar = new FilledBar(GameClientConfig.HpBarColor, false);
		addChild(playerHealthBar);

		playerCoinsBar = new IconBar('0');
		addChild(playerCoinsBar);

		bossBar = new BossBar();
		bossBar.alpha = 0;
		addChild(bossBar);

		// --------------------------------------------
		// Survive timer
		// --------------------------------------------

		objectiveText = TextUtils.GetDefaultTextObject(360, 90, 1.5, Center, GameClientConfig.DefaultFontColor);
		objectiveText.alpha = 0;
		addChild(objectiveText);

		// --------------------------------------------
		// Frame
		// --------------------------------------------

		drawFrame();
    }

	public function resize(orientation:String, w:Int, h:Int) {
		scaleMode = ScaleMode.Stretch(w, h);
		
		objectiveText.setPosition(
			DeviceInfo.ActualScreenWidth / 2,
			DeviceInfo.ActualScreenHeight / 100 * fullScreenVerticalPaddingPercent + 50,
		);

		updateBarsPosition(w, h);
		updateMovementControllerPosition(w, h);
		updateSkillPosition(w, h);
	}

	public function updateUi() {
		#if debug
		if (characterAndZombieBalanceView != null) {
			characterAndZombieBalanceView.update();
		}
		#end
	}

	public function release() {
		if (movementController != null) {
			movementController.release();
		}
	}

    public function updateCursorPosition(x:Float, y:Float) {
		if (movementController != null) {
        	movementController.updateCursorPosition(x, y);
		}
    }

	public function showObjectiveText() {
		objectiveText.alpha = 1;
		bossBar.alpha = 0;
	}

	// ----------------------------------
	// Bars
	// ----------------------------------

	public function updatePlayer(playerCurrentHealth:Int, playerMaxHealth:Int) {
		if (movementController != null) {
			movementController.update();
		}
		playerHealthBar.updateBar(playerCurrentHealth, playerMaxHealth);
    }

	public function updateBossHealth(bossCurrentHealth:Int, bossMaxHealth:Int) {
		bossBar.updateBossHealth(bossCurrentHealth, bossMaxHealth);
	}

	public function addCoins(coins:Int) {
		playerCoinsBar.updateText(Std.string(coins));
		playerCoinsBar.pulseAnim();
	}

	public function addHealth() {
		playerHealthBar.pulseAnim();
	}

	public function showBossBar() {
		objectiveText.alpha = 0;
		bossBar.appearAnimation();
	}

	private function updateBarsPosition(w, h) {
		var playerHealthBarX = 180;
		var playerHealthBarY = DeviceInfo.IsMobile ? 
			DeviceInfo.ActualScreenHeight / 100 * fullScreenVerticalPaddingPercent + 10: 50;
		playerHealthBar.setPosition(playerHealthBarX, playerHealthBarY);
		
		var playerCoinsBarX = playerHealthBar.x + playerHealthBar.getBitmapWidth() + 10;
		if (DeviceInfo.IsMobile && DeviceInfo.ScreenOrientation == 'portrait') {
			playerCoinsBarX = DeviceInfo.ActualScreenWidth - playerCoinsBar.getBitmapWidth() / 2 - 75;
		}
 
		var playerCoinsBarY = DeviceInfo.IsMobile ? 
			DeviceInfo.ActualScreenHeight / 100 * fullScreenVerticalPaddingPercent + 10 : 50;
		playerCoinsBar.setPosition(playerCoinsBarX, playerCoinsBarY);

		bossBar.setTargetY(DeviceInfo.ActualScreenHeight / 100 * fullScreenVerticalPaddingPercent + 150);
	}

	// ----------------------------------
	// Text objective
	// ----------------------------------

	public function killTheBossObjective() {
		objectiveText.text = 'Kill the BOSS!';
	}

	public function updateSurviveTimerObjective(secondsToSurvive:Int, secondsPassed:Int) {
		objectiveText.text = 'Survive for ${secondsToSurvive - secondsPassed} seconds';
	}

	public function updateMonstersLeftObjective(mobsLeft:Int) {
		var text = 'Kill ${mobsLeft} monster';
		if (mobsLeft > 1) {
			text += 's';
		}
		objectiveText.text = text;
	}

	// ----------------------------------
	// Dialogs
	// ----------------------------------

	public function showWinDialog(zombiesKilled:Int) {
		DialogManager.ShowDialog(
			this, 
			DialogType.MEDIUM,
			null,
			{ label: "You have won!", scale: 1, color: GameClientConfig.DefaultFontColor, },
			{ label: "Zombies killed: " + zombiesKilled, scale: 1, color: GameClientConfig.DefaultFontColor, },
			null,
			{
                buttons: ONE,
				positiveLabel: "OK",
				positiveCallback: function positiveCallback() {
					EventManager.instance.notify(EventManager.EVENT_HOME_SCENE, {});
				},
				negativeLabel: null,
				negativeCallback: null,
			},
		);
	}

	public function showLoseDialog(zombiesKilled:Int) {
		DialogManager.ShowDialog(
			this,
			DialogType.SMALL,
			null,
			{ label: "You lose!", scale: 1, color: GameClientConfig.DefaultFontColor, },
			null,
			null,
			{
                buttons: ONE,
				positiveLabel: "OK",
				positiveCallback: function positiveCallback() {
					EventManager.instance.notify(EventManager.EVENT_HOME_SCENE, {});
				},
				negativeLabel: null,
				negativeCallback: null,
			},
		);
	}

	// ----------------------------------
	// Controls
	// ----------------------------------

	private function updateMovementControllerPosition(w:Int, h:Int) {
		if (movementController != null) {
			final rectSize = 400;
			movementController.setPositionAndUpdateShape(rectSize / 2, h - rectSize / 2, rectSize);
		}
	}

	private function updateSkillPosition(w:Int, h:Int) {
		var skillIconX = w - skillSlot.tile.width;
		var skillIconY = h - (skillSlot.tile.height);
		var skillIteractionX = w - skillSlot.tile.width - skillSlot.tile.width / 2;
		var skillIteractionY = h - skillSlot.tile.height - skillSlot.tile.height / 2;

		skillIcon.setPosition(skillIconX, skillIconY);
		skillSlot.setPosition(skillIconX, skillIconY);
		skillSlotInteraction.setPosition(skillIteractionX, skillIteractionY);

		redrawFrame();
	}

	// ----------------------------------
	// Frame
	// ----------------------------------

	private function drawFrame() {
		final frameHorizontalTile = Res.instance.getTileResource(SeidhResource.UI_GAME_FRAME_HORIZONTAL);
		final frameVerticalTile = Res.instance.getTileResource(SeidhResource.UI_GAME_FRAME_VERTICAL);

		// Header
		final headerFrameLeft = new h2d.Bitmap(Res.instance.getTileResource(SeidhResource.UI_GAME_HEADER_FRAME_LEFT));
		headerFrameLeft.setPosition(
			headerFrameLeft.tile.width / 2,
			headerFrameLeft.tile.height / 2,
		);
		frameObjects.push(headerFrameLeft);

		final headerFrameRight = new h2d.Bitmap(Res.instance.getTileResource(SeidhResource.UI_GAME_HEADER_FRAME_RIGHT));
		headerFrameRight.setPosition(
			DeviceInfo.ActualScreenWidth - headerFrameRight.tile.width / 2,
			headerFrameRight.tile.height / 2,
		);
		frameObjects.push(headerFrameRight);

		// Footer
		final footerFrameLeft = new h2d.Bitmap(Res.instance.getTileResource(SeidhResource.UI_GAME_FOOTER_FRAME_LEFT));
		footerFrameLeft.setPosition(
			footerFrameLeft.tile.width / 2,
			DeviceInfo.ActualScreenHeight - footerFrameLeft.tile.height / 2,
		);
		frameObjects.push(footerFrameLeft);

		final footerFrameRight = new h2d.Bitmap(Res.instance.getTileResource(SeidhResource.UI_GAME_FOOTER_FRAME_RIGHT));
		footerFrameRight.setPosition(
			DeviceInfo.ActualScreenWidth - footerFrameRight.tile.width / 2,
			DeviceInfo.ActualScreenHeight - footerFrameRight.tile.height / 2,
		);
		frameObjects.push(footerFrameRight);

		// Horizontal frames
		final screenWidthMinusCornerFrames = DeviceInfo.ActualScreenWidth - (headerFrameLeft.tile.width * 2);

		for (i in 0...Std.int(screenWidthMinusCornerFrames / frameHorizontalTile.width) + 1) {
			final frameHorizontalTop = new h2d.Bitmap(frameHorizontalTile);
			frameHorizontalTop.setPosition(
				headerFrameLeft.tile.width + frameHorizontalTile.width / 2 + (frameHorizontalTile.width * i),
				frameHorizontalTile.height / 2,
			);

			final frameHorizontalBottom = new h2d.Bitmap(frameHorizontalTile);
			frameHorizontalBottom.setPosition(
				headerFrameLeft.tile.width + frameHorizontalTile.width / 2 + (frameHorizontalTile.width * i),
				DeviceInfo.ActualScreenHeight - frameHorizontalTile.height / 2,
			);

			frameObjects.push(frameHorizontalTop);
			frameObjects.push(frameHorizontalBottom);
		}
		
		// Vertical frames
		final screenHeightMinusCornerFrames = DeviceInfo.ActualScreenHeight - (headerFrameLeft.tile.height * 2);

		for (i in 0...Std.int(screenHeightMinusCornerFrames / frameVerticalTile.width) + 1) {
			final frameVerticalLeft = new h2d.Bitmap(frameVerticalTile);
			frameVerticalLeft.setPosition(
				frameVerticalTile.width / 2,
				headerFrameLeft.tile.height + frameVerticalTile.height / 2 + (frameVerticalTile.height * i),
			);

			final frameVerticalRight = new h2d.Bitmap(frameVerticalTile);
			frameVerticalRight.setPosition(
				DeviceInfo.ActualScreenWidth - frameVerticalTile.width / 2,
				headerFrameLeft.tile.height + frameVerticalTile.height / 2 + (frameVerticalTile.height * i),
			);

			frameObjects.push(frameVerticalLeft);
			frameObjects.push(frameVerticalRight);
		}

		for (value in frameObjects) {
			addChild(value);
		}
	}

	private function redrawFrame() {
		for (value in frameObjects) {
			removeChild(value);
		}
		frameObjects = new Array<h2d.Bitmap>();
		drawFrame();
	}
}