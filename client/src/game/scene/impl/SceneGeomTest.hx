package game.scene.impl;

import engine.base.MathUtils;
import engine.base.geometry.Rectangle;
import engine.base.geometry.Line;
import game.scene.base.BasicScene;
import game.utils.Utils;
import h2d.col.Point;
import hxd.Window;

class SceneGeomTest extends BasicScene {
	// Two rect collides with each other
	private final rect1 = new Rectangle(200, 200, 300, 300, 0);
	private final rect2 = new Rectangle(200, 550, 300, 300, 0);
	// Rect to collide with mouse
	private final mouseRect = new Rectangle(1100, 400, 300, 500, 0);

	public function new() {
		super(null);

		// camera.setPosition(1280 / 2, 720 / 2);

		// camera.scale(0.5, 0.5);
	}

	// --------------------------------------
	// Impl
	// --------------------------------------

	public function start() {
	}

	public function customUpdate(dt:Float, fps:Float) {
		// ------------------------------------------
		// Two rect collide test
		// ------------------------------------------
		rect2.r += MathUtils.degreeToRads(0.1);
		var collideRectColor = GameConfig.GreenColor;
		if (rect1.intersectsWithRect(rect2)) {
			collideRectColor = GameConfig.RedColor;
		}
		Utils.DrawRect(debugGraphics, rect1, collideRectColor);
		Utils.DrawRect(debugGraphics, rect2, collideRectColor);
		// ------------------------------------------
		// Mouse cursor and rect collide test
		// ------------------------------------------
		mouseRect.r += MathUtils.degreeToRads(0.1);
		final mousePos = new Point(Window.getInstance().mouseX, Window.getInstance().mouseY);
		final mouseToCameraPos = new Point(mousePos.x, mousePos.y);
		camera.sceneToCamera(mouseToCameraPos);
		final cursorToMouseRectLine = new Line(mouseToCameraPos.x, mouseToCameraPos.y, mouseRect.x, mouseRect.y);
		var mouseRectColor = GameConfig.YellowColor;
		if (mouseRect.getLines().lineB.intersectsWithLine(cursorToMouseRectLine)
			|| mouseRect.getLines().lineD.intersectsWithLine(cursorToMouseRectLine)) {
			mouseRectColor = GameConfig.RedColor;
		}
		Utils.DrawRect(debugGraphics, mouseRect, mouseRectColor);
		debugGraphics.lineStyle(3, GameConfig.YellowColor);
		debugGraphics.moveTo(cursorToMouseRectLine.x1, cursorToMouseRectLine.y1);
		debugGraphics.lineTo(cursorToMouseRectLine.x2, cursorToMouseRectLine.y2);
	}

}
