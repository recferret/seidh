package game.scene.impl;

import h3d.Engine;
import h2d.col.Point;
import hxd.Window;

import engine.base.MathUtils;
import engine.base.geometry.Rectangle;
import engine.base.geometry.Line;

import game.scene.base.BasicScene;
import game.utils.Utils;

class SceneGeomTest extends BasicScene {
	// Two rect collides with each other
	private final rect1 = new Rectangle(200, 200, 300, 300, 0);
	private final rect2 = new Rectangle(200, 550, 300, 300, 0);
	// Rect to collide with mouse
	private final mouseRect = new Rectangle(1100, 400, 300, 500, 0);

	public function new() {
		super(null);
	}

	// --------------------------------------
	// Abstraction
	// --------------------------------------

    public function absOnEvent(event:hxd.Event) {
    }

    public function absOnResize(w:Int, h:Int) {
    }

	public function absStart() {
    }

	public function absUpdate(dt:Float, fps:Float) {
		// ------------------------------------------
		// Two rect collide test
		// ------------------------------------------
		rect2.r += MathUtils.degreeToRads(0.1);
		var collideRectColor = GameClientConfig.GreenColor;
		if (rect1.intersectsWithRect(rect2)) {
			collideRectColor = GameClientConfig.RedColor;
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
		var mouseRectColor = GameClientConfig.YellowColor;
		if (mouseRect.getLines().lineB.intersectsWithLine(cursorToMouseRectLine)
			|| mouseRect.getLines().lineD.intersectsWithLine(cursorToMouseRectLine)) {
			mouseRectColor = GameClientConfig.RedColor;
		}
		Utils.DrawRect(debugGraphics, mouseRect, mouseRectColor);
		debugGraphics.lineStyle(3, GameClientConfig.YellowColor);
		debugGraphics.moveTo(cursorToMouseRectLine.x1, cursorToMouseRectLine.y1);
		debugGraphics.lineTo(cursorToMouseRectLine.x2, cursorToMouseRectLine.y2);
	}

    public function absRender(e:Engine) {
    }
    
    public function absDestroy() {
    }

}
