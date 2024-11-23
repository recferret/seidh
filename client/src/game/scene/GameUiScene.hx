package game.scene;

import game.tilemap.TilemapManager;
import hxd.res.DefaultFont;
import game.Res.SeidhResource;
import game.event.EventManager;
import game.scene.base.BasicScene;
import game.ui.dialog.Dialog;
import game.ui.bar.BarGold;
import game.ui.bar.BarXp;
import game.ui.bar.BarHp;
import game.utils.Utils;
import engine.base.MathUtils;
import engine.base.geometry.Point;
import engine.base.geometry.Rectangle;

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

	public function initiate(x:Float, y:Float, rectSize:Int) {
		setPosition(x, y);
		shapeRect = new Rectangle(x,y, rectSize, rectSize, 0);
	}

	public function update() {
		if (GameConfig.instance.DebugDraw) {
			customGraphics.clear();
		}

		if (inputActive) {
			final p1 = new engine.base.geometry.Point(outerCircle.localToGlobal().x, outerCircle.localToGlobal().y);
			final p2 = new engine.base.geometry.Point(lastMousePos.x, lastMousePos.y);
			angle = MathUtils.angleBetweenPoints(p1, p2);
			callback(angle);

			controlTargetPos = MathUtils.rotatePointAroundCenter(p1.x + 80, p1.y, p1.x, p1.y, angle);

			if (GameConfig.instance.DebugDraw) {
				customGraphics.lineStyle(2, 0xEA8220);
				customGraphics.moveTo(p1.x, p1.y);
				customGraphics.lineTo(controlTargetPos.x, controlTargetPos.y);
				customGraphics.endFill();
			}
		}

		if (GameConfig.instance.DebugDraw) {
			Utils.DrawRect(customGraphics, shapeRect, GameConfig.RedColor);
		}
	}

	private function innerCircleDefaultPos() {
		innerCircle.setPosition(
			0, 0
		);
	}
}

class GameUiScene extends h2d.Scene {

	private final movementController:MovementController;
	private final isMobileDevice:Bool;
	private var screenWidth:Int = 0;
	private var screenHeight:Int = 0;

	private final skillSlot:h2d.Bitmap;
	private final skillIcon:h2d.Bitmap;
	private final skillSlotInteraction:h2d.Interactive;

	private final barHp:BarHp;
	// private final barXp:BarXp;
	private final barGold:BarGold;

	private final surviveTimer:h2d.Text;
    
    public function new(
		isMobileDevice:Bool, 
		buttonPressedCallback:ButtonPressed->Void,
		joystickMovedCallback:Float->Void,
	) {
        super();

		this.isMobileDevice = isMobileDevice;

		// --------------------------------------------
		// Input
		// --------------------------------------------

        movementController = new MovementController(this, function callback(angle:Float) {
			if (joystickMovedCallback != null) {
				joystickMovedCallback(angle);
			}
        });

		skillSlot = new h2d.Bitmap(TilemapManager.instance.getTile(TileType.ICON_SKILL_BACKGROUND), this);
		skillIcon = new h2d.Bitmap(TilemapManager.instance.getTile(TileType.SKILL_ACTION_MAIN), this);

		skillSlotInteraction = new h2d.Interactive(skillSlot.tile.width, skillSlot.tile.height);
		skillSlotInteraction.onClick = function(event:hxd.Event) {
			if (buttonPressedCallback != null) {
				buttonPressedCallback(ButtonPressed.A);
			}
		}
		addChild(skillSlotInteraction);

		// --------------------------------------------
		// Bars
		// --------------------------------------------

		barHp = new BarHp(this);
		barHp.setPosition(185, 40);

		// barXp = new BarXp(this);
		// barXp.setPosition(185, 43 + barHp.getBitmapHeight());

		barGold = new BarGold(this);
		barGold.setPosition(Main.ActualScreenWidth - barGold.getBitmapWidth() / 1.2, 50);

		// --------------------------------------------
		// Survive timer
		// --------------------------------------------

		final font : h2d.Font = DefaultFont.get();
        surviveTimer = new h2d.Text(font);
        surviveTimer.text = 'Survive for .. seconds';
        surviveTimer.textColor = GameConfig.DefaultFontColor;
        surviveTimer.dropShadow = { dx : 0.5, dy : 0.5, color : 0xFF0000, alpha : 0.8 };
        surviveTimer.textAlign = Center;
        surviveTimer.setScale(3);
        surviveTimer.setPosition(360, 90);

		// --------------------------------------------
		// Frame
		// --------------------------------------------

		final frameHeader = new h2d.Bitmap(Res.instance.getTileResource(SeidhResource.UI_GAME_HEADER), this);
        frameHeader.setPosition(Main.ActualScreenWidth / 2, frameHeader.tile.height / 2);

        final frameFooter = new h2d.Bitmap(Res.instance.getTileResource(SeidhResource.UI_GAME_FOOTER), this);
        frameFooter.setPosition(Main.ActualScreenWidth / 2, Main.ActualScreenHeight - frameFooter.tile.height / 2);

		// Frames left
		final leftSideFrameTop = new h2d.Bitmap(Res.instance.getTileResource(SeidhResource.UI_GAME_FRAME), this);
		leftSideFrameTop.setPosition(leftSideFrameTop.tile.width / 2, frameHeader.tile.height + (leftSideFrameTop.tile.height * 1) / 2);

		for (i in 2...9) {
			final leftSideFrameMiddle = new h2d.Bitmap(Res.instance.getTileResource(SeidhResource.UI_GAME_FRAME), this);
			leftSideFrameMiddle.setPosition(leftSideFrameMiddle.tile.width / 2, frameHeader.tile.height + (leftSideFrameMiddle.tile.height * i) / 2);
		}

		final leftSideFrameBottom = new h2d.Bitmap(Res.instance.getTileResource(SeidhResource.UI_GAME_FRAME), this);
		leftSideFrameBottom.setPosition(leftSideFrameBottom.tile.width / 2, Main.ActualScreenHeight - frameFooter.tile.height + 1 - (leftSideFrameBottom.tile.height * 1) / 2);
		
		// Frames right
		final rightSideFrameTop = new h2d.Bitmap(Res.instance.getTileResource(SeidhResource.UI_GAME_FRAME_RIGHT), this);
		rightSideFrameTop.setPosition(Main.ActualScreenWidth - rightSideFrameTop.tile.width / 2, frameHeader.tile.height + (rightSideFrameTop.tile.height * 1) / 2);

		for (i in 2...9) {
			final rightSideFrameMiddle = new h2d.Bitmap(Res.instance.getTileResource(SeidhResource.UI_GAME_FRAME_RIGHT), this);
			rightSideFrameMiddle.setPosition(Main.ActualScreenWidth - rightSideFrameMiddle.tile.width / 2, frameHeader.tile.height + (rightSideFrameMiddle.tile.height * i) / 2);
		}

		final rightSideFrameBottom = new h2d.Bitmap(Res.instance.getTileResource(SeidhResource.UI_GAME_FRAME_RIGHT), this);
		rightSideFrameBottom.setPosition(Main.ActualScreenWidth - rightSideFrameBottom.tile.width / 2, Main.ActualScreenHeight - frameFooter.tile.height + 1 - (rightSideFrameBottom.tile.height * 1) / 2);

    }

	public function resize(orientation:String, w:Int, h:Int) {
		scaleMode = ScaleMode.Stretch(w, h);
		final rectSize = 400;

		movementController.initiate(rectSize / 2, h - rectSize / 2, rectSize);

		skillIcon.setPosition(w - (skillSlot.tile.width * 1), h - (skillSlot.tile.height * 2));
		skillSlot.setPosition(w - (skillSlot.tile.width * 1), h - (skillSlot.tile.height * 2));
		skillSlotInteraction.setPosition(
			w - (skillSlot.tile.width * 1) - skillSlot.tile.width / 2, 
			h - (skillSlot.tile.height * 2) - skillSlot.tile.height / 2
		);
	}

    public function update(playerCurrentHealth:Int, playerMaxHealth:Int) {
		movementController.update();
		barHp.update(playerCurrentHealth, playerMaxHealth);
		// barXp.update();
    }

	public function addGold() {
		barGold.addGold();
	}

	public function addHealth() {
		barHp.addHp();
	}

	public function release() {
		movementController.release();
	}

    public function updateCursorPosition(x:Float, y:Float) {
        movementController.updateCursorPosition(x, y);
    }

	public function addSurviveTimer() {
		addChild(surviveTimer);
	}

	public function updateSurviveTimer(secondsToSurvive:Int, secondsPassed:Int) {
		surviveTimer.text = 'Survive for ${secondsToSurvive - secondsPassed} seconds';
	}

	public function showWinDialog(zombiesKilled:Int) {
		DialogManager.ShowDialog(
			this, 
			DialogType.MEDIUM,
			null,
			{ label: "You have won!", scale: 3, color: GameConfig.DefaultFontColor, },
			{ label: "Zombies killed: " + zombiesKilled, scale: 3, color: GameConfig.DefaultFontColor, },
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
			{ label: "You lose!", scale: 3, color: GameConfig.DefaultFontColor, },
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

}