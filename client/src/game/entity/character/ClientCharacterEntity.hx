package game.entity.character;

import game.utils.Utils;
import game.entity.character.animation.CharacterAnimations;
import engine.base.BaseTypesAndClasses;
import engine.base.geometry.Point;
import engine.base.entity.impl.EngineCharacterEntity;
import haxe.Timer;
import hxd.Math;

class ClientCharacterEntity extends h2d.Object {

    public var animation:CharacterAnimation;

    private var debugActionShape:EntityShape;
    private var engineEntity:EngineCharacterEntity;

    var targetServerPosition = new Point();

    public function new(s2d:h2d.Scene) {
        super(s2d);
    }

    // ------------------------------------------------------------
    // General
    // ------------------------------------------------------------

    public function update(dt:Float) {
        moveToServerPosition(dt);
    }

    // ------------------------------------------------------------
    // ABSTRACTION ?
    // ------------------------------------------------------------

	public function debugDraw(graphics:h2d.Graphics) {
        if (engineEntity.botForwardLookingLine != null) {
            final p1 = new h2d.col.Point(engineEntity.botForwardLookingLine.x1, engineEntity.botForwardLookingLine.y1);
            final p2 = new h2d.col.Point(engineEntity.botForwardLookingLine.x2, engineEntity.botForwardLookingLine.y2);
            Utils.DrawLine(graphics, p1, p2, engineEntity.intersectsWithCharacter ? GameConfig.RedColor : GameConfig.BlueColor);    
        }

        if (debugActionShape != null) {
            Utils.DrawRect(graphics, debugActionShape.toRect(x, y, 0, engineEntity.currentDirectionSide), GameConfig.GreenColor);
        }

        Utils.DrawRect(graphics, engineEntity.getBodyRectangle(), GameConfig.GreenColor);
    }

    public function initiateEngineEntity(engineEntity:EngineCharacterEntity) {
		this.engineEntity = engineEntity;
		setPosition(engineEntity.getX(), engineEntity.getY());

        switch (engineEntity.getEntityType()) {
            case EntityType.KNIGHT:
                animation = CharacterAnimations.LoadKnightAnimation(this);
            case EntityType.SAMURAI:
                animation = CharacterAnimations.LoadSamuraiAnimation(this);
            case EntityType.SKELETON_WARRIOR:
                animation = CharacterAnimations.LoadSkeletonWarriorAnimation(this);
            case EntityType.SKELETON_ARCHER:
                animation = CharacterAnimations.LoadSkeletonArcherAnimation(this);
            default:
        }
	}
 
    public function setTragetServerPosition(x:Float, y:Float) {
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

            animation.setSide(engineEntity.currentDirectionSide);

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

    public function intersectsWithCharacter() {
        return engineEntity.intersectsWithCharacter;
    }

    public function getForwardLookingLine(lineLength:Int) {
        return engineEntity.getForwardLookingLine(lineLength);
    }

    public function getDebugActionShape() {
        return debugActionShape;
    }

}