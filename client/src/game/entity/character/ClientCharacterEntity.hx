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

    var engineEntity:EngineCharacterEntity;
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
        // TODO rmk shape for melee attacks
        if (debugActionShape != null) {
            // Utils.DrawRect(graphics, debugActionShape.toRect(x, y, engineEntity.currentDirectionSide), GameConfig.GreenColor);
        }

        Utils.DrawRect(graphics, engineEntity.getBodyRectangle(), GameConfig.GreenColor);
    }

    public function initiateEngineEntity(engineEntity:EngineCharacterEntity) {
		this.engineEntity = engineEntity;
		setPosition(engineEntity.getX(), engineEntity.getY());

        trace('CHARACTER POSITION:');
        trace(engineEntity.getX(), engineEntity.getY());

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