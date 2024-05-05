package game.entity.character;

import game.entity.character.animation.EntityAnimations;
import game.entity.character.animation.EntityAnimations.EntityAnimation;
import engine.base.BaseTypesAndClasses.EntityShape;
import engine.base.geometry.Point;
import engine.base.entity.impl.EngineCharacterEntity;
import haxe.Timer;
import hxd.Math;

abstract class ClientBaseEntity extends h2d.Object {

    public var animation:EntityAnimation;

    private var debugActionShape:EntityShape;

    var engineEntity:EngineCharacterEntity;
    var targetServerPosition = new Point();

    public function new(s2d:h2d.Scene) {
        super(s2d);
    }

    // ------------------------------------------------------------
    // General
    //-------------------------------------------------------------

    public function update(dt:Float) {
        moveToServerPosition(dt);
    }

	public function debugDraw(graphics:h2d.Graphics) {
        final debugActionShape = getDebugActionShape();
        if (debugActionShape != null) {
            Utils.DrawRect(graphics, debugActionShape.toRect(x, y, engineEntity.currentDirectionSide), GameConfig.GreenColor);
        }

        Utils.DrawRect(graphics, engineEntity.getBodyRectangle(), GameConfig.GreenColor);
    }

    public function initiateEngineEntity(engineEntity:EngineCharacterEntity) {
		this.engineEntity = engineEntity;
		setPosition(engineEntity.getX(), engineEntity.getY());

        switch (engineEntity.getEntityType()) {
            case KNIGHT:
                animation = CharacterAnimations.LoadKnightAnimation(this);
            case SAMURAI:
                animation = CharacterAnimations.LoadSamuraiAnimation(this);
            case SKELETON_WARRIOR:
                animation = CharacterAnimations.LoadSkeletonWarriorAnimation(this);
            case SKELETON_ARCHER:
                animation = CharacterAnimations.LoadSkeletonArcherAnimation(this);
            default:
        }
	}

    public function setTragetServerPosition(x:Int, y:Int) {
        targetServerPosition.x = x;
        targetServerPosition.y = y;
    }

    public function moveToServerPosition(dt:Float) {
        if (animation.enableMoveAnimation) {

            // if (this.engineEntity.getEntityType() == SKELETON_WARRIOR) {
            //     final side = targetServerPosition.x > x ? Side.RIGHT : Side.LEFT;
            //     animation.setSide(side);
            // } else {
            //     animation.setSide(isRightSide() ? RIGHT : LEFT);
            // }

            animation.setSide(this.engineEntity.currentDirectionSide);

            final distance = targetServerPosition.distance(new Point(x, y));
            if (distance > 1) {
                // TODO пофиксить частый визуальных баг при смене стороны движения
                // if (distance > 2) {
                animation.setAnimationState(RUN);
                // } else {
                //     animation.setAnimationState(WALK);
                // }
                
                x = Math.lerp(x, targetServerPosition.x, 0.08);
                y = Math.lerp(y, targetServerPosition.y, 0.08);
            } else {
                animation.setAnimationState(IDLE);
            }
        }
    }

    public function setDebugActionShape(shape:EntityShape) {
        debugActionShape = shape;

        // if (isRightSide()) {
        //     debugActionShape.rectOffsetX = shape.rectOffsetX;
        // } else {
        //     debugActionShape.rectOffsetX = -15;
        // }

        Timer.delay(function callback() {
            debugActionShape = null;
        }, 300);
    }

    // private function isRightSide() {
    //     if ([MOVE_LEFT, MOVE_UP_LEFT, MOVE_DOWN_LEFT].contains(engineEntity.getDirection())) {
    //         return false;
    //     } else if ([MOVE_RIGHT, MOVE_UP_RIGHT, MOVE_DOWN_RIGHT].contains(engineEntity.getDirection())) {
    //         return true;
    //     } else {
    //         return true;
    //     }
    // }

    // Getters

    public function getId() {
        return engineEntity.getId();
    }

    public function getOwnerId() {
        return engineEntity.getOwnerId();
    }

    public function getBodyRectangle() {
		return engineEntity.getBodyRectangle();
	}

    public function getDebugActionShape() {
        return debugActionShape;
    }

}