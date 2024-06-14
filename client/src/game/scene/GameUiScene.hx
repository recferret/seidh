package game.scene;

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

		outerCircle = new h2d.Bitmap(hxd.Res.input.joystick_1.toTile().center(), this);
		innerCircle = new h2d.Bitmap(hxd.Res.input.joystick_2.toTile().center(), this);
		
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
		if (GameConfig.DebugDraw) {
			customGraphics.clear();
		}

		if (inputActive) {
			final p1 = new engine.base.geometry.Point(outerCircle.localToGlobal().x, outerCircle.localToGlobal().y);
			final p2 = new engine.base.geometry.Point(lastMousePos.x, lastMousePos.y);
			angle = MathUtils.angleBetweenPoints(p1, p2);
			callback(angle);

			controlTargetPos = MathUtils.rotatePointAroundCenter(p1.x + 80, p1.y, p1.x, p1.y, angle);

			if (GameConfig.DebugDraw) {
				customGraphics.lineStyle(2, 0xEA8220);
				customGraphics.moveTo(p1.x, p1.y);
				customGraphics.lineTo(controlTargetPos.x, controlTargetPos.y);
				customGraphics.endFill();
			}
		}

		if (GameConfig.DebugDraw) {
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

	private final buttonA:h2d.Bitmap;
	private final buttonB:h2d.Bitmap;

	private final barHp:BarHp;
	private final barXp:BarXp;
	private final barGold:BarGold;
    
    public function new(
		isMobileDevice:Bool, 
		buttonPressedCallback:ButtonPressed->Void,
		joystickMovedCallback:Float->Void,
	) {
        super();

		this.isMobileDevice = isMobileDevice;

        movementController = new MovementController(this, function callback(angle:Float) {
			if (joystickMovedCallback != null) {
				joystickMovedCallback(angle);
			}
        });

		buttonA = new h2d.Bitmap(hxd.Res.input.pad_1.toTile(), this);
		buttonB = new h2d.Bitmap(hxd.Res.input.pad_2.toTile(), this);

		final interactionButtonA = new h2d.Interactive(buttonA.tile.width, buttonA.tile.height, buttonA);
		interactionButtonA.onClick = function(event:hxd.Event) {
			if (buttonPressedCallback != null) {
				buttonPressedCallback(ButtonPressed.A);
			}
		}

		final interactionButtonB = new h2d.Interactive(buttonB.tile.width, buttonB.tile.height, buttonB);
		interactionButtonB.onClick = function(event:hxd.Event) {
			if (buttonPressedCallback != null) {
				buttonPressedCallback(ButtonPressed.B);
			}
		}

		barHp = new BarHp(this);
		barHp.setPosition(5, 5);

		barXp = new BarXp(this);
		barXp.setPosition(5, 5 + barHp.getBitmapHeight());

		barGold = new BarGold(this);
		barGold.setPosition(BasicScene.ActualScreenWidth - barGold.getBitmapWidth() - 5, 5);
    }

	public function resize(orientation:String, w:Int, h:Int) {
		scaleMode = ScaleMode.Stretch(w, h);
		final rectSize = 400;

		movementController.initiate(rectSize / 2, h - rectSize / 2, rectSize);

		buttonA.setPosition(w - (buttonA.tile.width * 1.4), h - (buttonA.tile.height * 2.8));
		buttonB.setPosition(w - (buttonB.tile.width * 1.4), h - (buttonB.tile.height * 1.3));
	}

    public function update(playerCurrentHealth:Int, playerMaxHealth:Int) {
		movementController.update();
		barHp.update(playerCurrentHealth, playerMaxHealth);
		barXp.update();
    }

	public function release() {
		movementController.release();
	}

    public function updateCursorPosition(x:Float, y:Float) {
        movementController.updateCursorPosition(x, y);
    }

	public function showWinDialog(zombiesKilled:Int) {
		new Dialog(
			this, 
			DialogType.BIG, 
			"You have won!", 
			"Zombies killed: " + zombiesKilled,
			function callback() {
				EventManager.instance.notify(EventManager.EVENT_HOME_SCENE, {});
			}
		);
	}

	public function showLoseDialog(zombiesKilled:Int) {
		new Dialog(
			this, 
			DialogType.BIG, 
			"You lose!", 
			"Zombies killed: " + zombiesKilled,
			function callback() {
				EventManager.instance.notify(EventManager.EVENT_HOME_SCENE, {});
			}
		);
	}

}