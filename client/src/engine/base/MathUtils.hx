package engine.base;

// import engine.base.BaseTypesAndClasses.PlayerInputType;
import engine.base.geometry.Line;
import engine.base.geometry.Point;

class MathUtils {

	// private static final MoveUpRads = degreeToRads(270);
	// private static final MoveUpLeftRads = degreeToRads(225);
	// private static final MoveUpRightRads = degreeToRads(315);
	// private static final MoveDownRads = degreeToRads(90);
	// private static final MoveDownLeftRads = degreeToRads(135);
	// private static final MoveDownRightRads = degreeToRads(45);
	// private static final MoveLeftRads = degreeToRads(180);
	// private static final MoveRightRads = degreeToRads(0);

	// public static function directionToRads(playerInputType:PlayerInputType) {
	// 	switch (playerInputType) {
    //         case MOVE_UP: {
	// 			return MoveUpRads;
    //         }
	// 		case MOVE_UP_LEFT: {
	// 			return MoveUpLeftRads;
    //         }
	// 		case MOVE_UP_RIGHT: {
	// 			return MoveUpRightRads;
    //         }
    //         case MOVE_DOWN: {
	// 			return MoveDownRads;
    //         }
	// 		case MOVE_DOWN_LEFT: {
	// 			return MoveDownLeftRads;
    //         }
	// 		case MOVE_DOWN_RIGHT: {
	// 			return MoveDownRightRads;
    //         }
    //         case MOVE_LEFT: {
	// 			return MoveLeftRads;
    //         }
    //         case MOVE_RIGHT: {
	// 			return MoveRightRads;
    //         }
    //         default:
	// 			return 0;
    //     }
	// }

	// public static function radsToDirection(rads:Float) {
	// 	switch (rads) {
    //         case MoveUpRads: {
	// 			return MOVE_UP;
    //         }
	// 		case MoveUpLeftRads: {
	// 			return MOVE_UP_LEFT;
    //         }
	// 		case MoveUpRightRads: {
	// 			return MOVE_UP_RIGHT;
    //         }
    //         case MoveDownRads: {
	// 			return MOVE_DOWN;
    //         }
	// 		case MoveDownLeftRads: {
	// 			return MOVE_DOWN_LEFT;
    //         }
	// 		case MoveDownRightRads: {
	// 			return MOVE_DOWN_RIGHT;
    //         }
    //         case MoveLeftRads: {
	// 			return MOVE_LEFT;
    //         }
    //         case MoveRightRads: {
	// 			return MOVE_RIGHT;
    //         }
    //         default:
	// 			return MOVE_RIGHT;
    //     }
	// }

    public static function angleBetweenPoints(point1:Point, point2:Point) {
		return Math.atan2(point2.y - point1.y, point2.x - point1.x);
	}

	public static function degreeToRads(degrees:Float) {
		return (Math.PI / 180) * degrees;
	}

	public static function radsToDegree(rads:Float) {
		return rads * (180 / Math.PI);
	}

	public static function normalizeAngle(rads:Float) {
		rads = rads % (2 * Math.PI);
		if (rads >= 0) {
			return rads;
		} else {
			return rads + 2 * Math.PI;
		}
	}

	public static function rotatePointAroundCenter(x:Float, y:Float, cx:Float, cy:Float, r:Float) {
		final cos = Math.cos(r);
		final sin = Math.sin(r);
		return new Point((cos * (x - cx)) - (sin * (y - cy)) + cx, (cos * (y - cy)) + (sin * (x - cx)) + cy);
	}

	public static function lineToLineIntersection(lineA:Line, lineB:Line) {
		final numA = (lineB.x2 - lineB.x1) * (lineA.y1 - lineB.y1) - (lineB.y2 - lineB.y1) * (lineA.x1 - lineB.x1);
		final numB = (lineA.x2 - lineA.x1) * (lineA.y1 - lineB.y1) - (lineA.y2 - lineA.y1) * (lineA.x1 - lineB.x1);
		final deNom = (lineB.y2 - lineB.y1) * (lineA.x2 - lineA.x1) - (lineB.x2 - lineB.x1) * (lineA.y2 - lineA.y1);
		if (deNom == 0) {
			return false;
		}
		final uA = numA / deNom;
		final uB = numB / deNom;
		return uA >= 0 && uA <= 1 && uB >= 0 && uB <= 1;
	}

	public static function differ(a:Float, b:Float, error:Float) {
		return Math.abs(a - b) > (error == 0 ? 1 : error);
	}

}