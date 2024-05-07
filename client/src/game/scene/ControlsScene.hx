package game.scene;

import game.utils.Utils;
import engine.base.BaseTypesAndClasses;
import engine.base.MathUtils;
import engine.base.geometry.Point;
import engine.base.geometry.Rectangle;
import engine.seidh.SeidhGameEngine;

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

		outerCircle = new h2d.Bitmap(hxd.Res.input.cirlce_1.toTile().center(), this);
		innerCircle = new h2d.Bitmap(hxd.Res.input.circle_2.toTile().center(), this);
		
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
		if (inputActive) {
			final p1 = new engine.base.geometry.Point(outerCircle.localToGlobal().x, outerCircle.localToGlobal().y);
			final p2 = new engine.base.geometry.Point(lastMousePos.x, lastMousePos.y);
			angle = MathUtils.angleBetweenPoints(p1, p2);
			callback(angle);

			controlTargetPos = MathUtils.rotatePointAroundCenter(p1.x + 80, p1.y, p1.x, p1.y, angle);

			customGraphics.clear();

			Utils.DrawRect(customGraphics, shapeRect, GameConfig.RedColor);

			customGraphics.lineStyle(2, 0xEA8220);
			customGraphics.moveTo(p1.x, p1.y);
			customGraphics.lineTo(controlTargetPos.x, controlTargetPos.y);
			customGraphics.endFill();
		} else {
			customGraphics.clear();
			Utils.DrawRect(customGraphics, shapeRect, GameConfig.RedColor);
		}
	}

	private function innerCircleDefaultPos() {
		innerCircle.setPosition(
			0, 0
		);
	}
}

enum abstract ButtonPressed(Int) {
	var A = 1;
	var B = 2;
	var X = 3;
	var Y = 4;
}

class ControlsScene extends h2d.Scene {

	private final movementController:MovementController;
	private final text:h2d.Text;
    
    public function new(baseEngine:SeidhGameEngine, buttonPressedCallback:ButtonPressed->Void) {
        super();

        scaleMode = ScaleMode.Zoom(2);

        movementController = new MovementController(this, function callback(angle:Float) {
            final playerId = Player.instance.playerId;
            final playerEntityId = Player.instance.playerEntityId;
            final playerMovementInputType = CharacterActionType.MOVE;

            if (playerMovementInputType != null) {
                final movementAllowance = baseEngine.checkLocalMovementInputAllowance(playerEntityId);
                if (movementAllowance) {
                    baseEngine.addInputCommandClient(new PlayerInputCommand(playerMovementInputType, angle, playerId, Player.instance.incrementAndGetInputIndex()));
                }
            }
        });
        movementController.initiate(250, 250, 400);

		final buttonScale = 2;
		final buttonSize = 80;
		final buttonScaledSize = buttonScale * buttonSize;

		final buttonA = new h2d.Bitmap(hxd.Res.input.button_a.toTile(), this);
		final buttonB = new h2d.Bitmap(hxd.Res.input.button_b.toTile(), this);

		buttonA.scale(buttonScale);
		buttonB.scale(buttonScale);

		buttonA.setPosition(width - (buttonScaledSize * 2), buttonScaledSize / 2);
		buttonB.setPosition(width - (buttonScaledSize * 2), buttonScaledSize * 2);

		final interactionButtonA = new h2d.Interactive(buttonSize, buttonSize, buttonA);
		interactionButtonA.onClick = function(event : hxd.Event) {
			if (buttonPressedCallback != null) {
				buttonPressedCallback(ButtonPressed.A);
			}
		}

		final interactionButtonB = new h2d.Interactive(buttonSize, buttonSize, buttonB);
		interactionButtonB.onClick = function(event : hxd.Event) {
			if (buttonPressedCallback != null) {
				buttonPressedCallback(ButtonPressed.B);
			}
		}

		// Debug interface

		final fui = new h2d.Flow(this);
		fui.layout = Vertical;
		fui.verticalSpacing = 5;
		fui.padding = 10;

		text = new h2d.Text(hxd.res.DefaultFont.get(), fui);
    }

    public function update() {
		movementController.update();
    }

	public function release() {
		movementController.release();
	}

    public function updateCursorPosition(x:Float, y:Float) {
        movementController.updateCursorPosition(x, y);
    }

}