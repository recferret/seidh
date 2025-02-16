package game.entity.character;

import engine.base.geometry.Rectangle;
import engine.base.geometry.Point;
import engine.base.entity.impl.EngineCharacterEntity;
import engine.base.types.TypesBaseEntity;
import engine.seidh.types.TypesSeidhEntity;

import game.entity.character.animation.CharacterAnimations;
import game.scene.impl.game.GameScene;
import game.utils.Utils;

import hxd.Math;

abstract class ClientCharacterEntity extends BasicClientEntity<EngineCharacterEntity> {

    public final animation:CharacterAnimation;

    final targetServerPosition = new Point();

    public function new(s2d:h2d.Scene, engineEntity:EngineCharacterEntity) {
        super();

        s2d.add(this, GameScene.LAYER_CHARACTERS_AND_BOOSTS);

		this.engineEntity = engineEntity;
		setPosition(engineEntity.getX(), engineEntity.getY());

        animation = CharacterAnimations.LoadCharacterAnimation(this, engineEntity.getId(), engineEntity.getEntityType());
        animation.setSide(engineEntity.getSide());
    }

    // ------------------------------------------------
    // Abstraction
    // ------------------------------------------------

    public abstract function fxDeath():Void;
    public abstract function getRect():Rectangle;
    public abstract function getBottomRect():Rectangle;

    // ------------------------------------------------
    // Abstract implemenation
    // ------------------------------------------------

    public function update(dt:Float, fps:Float) {
        if (engineEntity.isAlive && engineEntity.spawned) {
            moveToServerPosition(dt, fps);
        }
    }

	public function debugDraw(graphics:h2d.Graphics) {
        if (engineEntity.isPlayer()) {
            final line = getForwardLookingLine(engineEntity.playerForwardLookingLineLength);
            Utils.DrawLine(graphics, 
                line.x1,
                line.y1,
                line.x2,
                line.y2,
                engineEntity.intersectsWithCharacter ? GameClientConfig.RedColor : GameClientConfig.BlueColor);

            // PickUp rect
            Utils.DrawCircle(graphics, engineEntity.getBodyCircle(), GameClientConfig.RedColor);
        } else if (engineEntity.botForwardLookingLine != null) {
            Utils.DrawLine(graphics, 
                engineEntity.botForwardLookingLine.x1,
                engineEntity.botForwardLookingLine.y1,
                engineEntity.botForwardLookingLine.x2,
                engineEntity.botForwardLookingLine.y2,
                engineEntity.intersectsWithCharacter ? GameClientConfig.RedColor : GameClientConfig.BlueColor);   
        }

        if (engineEntity.getActionRect(false) != null) {
            Utils.DrawRect(graphics, engineEntity.getActionRect(false), GameClientConfig.RedColor);
        }

        Utils.DrawRect(graphics, engineEntity.getBodyRectangle(), GameClientConfig.GreenColor);
    }
 
    // ------------------------------------------------
    // General
    // ------------------------------------------------

    public function setTragetServerPosition(x:Float, y:Float) {
        if (targetServerPosition.x != x || targetServerPosition.y != y) {
            targetServerPosition.x = x;
            targetServerPosition.y = y;
        }
    }

    public function moveToServerPosition(dt:Float, fps:Float) {
        animation.setSide(engineEntity.getSide());

        final distance = targetServerPosition.distance(new Point(x, y));
        if (distance > 1) {
            x = Math.lerp(x, targetServerPosition.x, 0.06);
            y = Math.lerp(y, targetServerPosition.y, 0.06);
        }

        if (animation.enableMoveAnimation && distance > 7) {
            animation.setAnimationState(RUN);
            // Do not enterrupt attack animation, because of interpolation character may still move 
        } else if (
            animation.getAnimationState() != CharacterAnimationState.ACTION_MAIN && 
            animation.getAnimationState() != CharacterAnimationState.ACTION_1 && 
            animation.getAnimationState() != CharacterAnimationState.ACTION_2 && 
            distance != 0) 
        {
            animation.setAnimationState(IDLE);
        }
    }

    public function performAction(action:CharacterActionType, reverseAnimation:Bool) {
        switch (action) {
            case CharacterActionType.ACTION_MAIN:
                animation.setAnimationState(CharacterAnimationState.ACTION_MAIN);
            case CharacterActionType.ACTION_1:
                animation.setAnimationState(CharacterAnimationState.ACTION_1);
            case CharacterActionType.ACTION_2:
                animation.setAnimationState(CharacterAnimationState.ACTION_2, reverseAnimation);
            case CharacterActionType.ACTION_3:
                animation.setAnimationState(CharacterAnimationState.ACTION_3);
            default:
        }
    }

    // ------------------------------------------------
    // FX
    // ------------------------------------------------

    private function adjustRunAnimationSpeed() {
        animation.setRunAnimationSpeed(engineEntity.getMovementSpeedFactor());
    }

    // ------------------------------------------------
    // Getters
    // ------------------------------------------------

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

    public function getEntityType() {
        return engineEntity.getEntityType();
    }

    public function getSide() {
        return engineEntity.getSide();
    }

    public function isPlayer() {
        return engineEntity.isPlayer();
    }
    
    public function isMonster() {
        return engineEntity.isMonster();
    }

    public function getCurrentHealth() {
        return engineEntity.getCurrentHealth();
    }

    public function getMaxHealth() {
        return engineEntity.getMaxHealth();
    }

	// ------------------------------------------------
	// Adjust setters
	// ------------------------------------------------

	public function ajdustMovement(speed:Int, inputDelay:Float) {
		engineEntity.adjustMovement(speed, inputDelay);
	}

    public function adjustActionMain(width:Int, height:Int, offsetX:Int, offsetY:Int, inputDelay:Float, damage:Int) {
		engineEntity.adjustActionMain(width, height, offsetX, offsetY, inputDelay, damage);
	}

}