package game.utils;

import engine.base.geometry.Circle;
import engine.base.geometry.Rectangle;

class Utils {
	public static function EngineToClientPoint(p:engine.base.geometry.Point) {
		return new h2d.col.Point(p.x, p.y);
	}

	public static function ClientToEnginePoint(p:h2d.col.Point) {
		return new engine.base.geometry.Point(p.x, p.y);
	}

	public static function MaskEthAddress(text:String) {
		return text.substring(0, 4) + '...' + text.substring(text.length - 4, text.length);
	}

	public static function DrawCircle(graphics:h2d.Graphics, circle:Circle, color:Int) {
		graphics.lineStyle(2, color);

		graphics.drawCircle(circle.x, circle.y, circle.r);

		graphics.endFill();
	}

	public static function DrawLine(graphics:h2d.Graphics, x1:Float, y1:Float, x2:Float, y2:Float, color:Int) {
		graphics.lineStyle(2, color);

		graphics.moveTo(x1, y1);
		graphics.lineTo(x2, y2);

		graphics.endFill();
	}

	public static function DrawRect(graphics:h2d.Graphics, rect:Rectangle, color:Int) {
		graphics.lineStyle(2, color);

		// Top line
		graphics.lineTo(rect.getTopLeftPoint().x, rect.getTopLeftPoint().y);
		graphics.lineTo(rect.getTopRightPoint().x, rect.getTopRightPoint().y);

		// Right line
		graphics.lineTo(rect.getBottomRightPoint().x, rect.getBottomRightPoint().y);

		// Bottom line
		graphics.lineTo(rect.getBottomLeftPoint().x, rect.getBottomLeftPoint().y);

		// Left line
		graphics.lineTo(rect.getTopLeftPoint().x, rect.getTopLeftPoint().y);
	}

	public static function DrawRectFilled(graphics:h2d.Graphics, rect:Rectangle, color:Int) {
		graphics.beginFill(color);
		graphics.drawRect(rect.x, rect.y, rect.w, rect.h);
		graphics.endFill();
	}
}