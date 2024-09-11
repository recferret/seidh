package game.entity.character;

import engine.base.geometry.Rectangle;
import engine.base.BaseTypesAndClasses;
import engine.base.geometry.Point;
import engine.base.entity.impl.EngineCharacterEntity;

import game.entity.character.animation.CharacterAnimations;
import game.fx.FxManager;
import game.scene.impl.GameScene;
import game.sound.SoundManager;
import game.utils.Utils;

import hxd.Math;

class ClientCharacterEntity extends BasicClientEntity<EngineCharacterEntity> {

    public var animation:CharacterAnimation;

    var targetServerPosition = new Point();
	var BaseGameScene(default, null):Int;

    public function new(s2d:h2d.Scene, engineEntity:EngineCharacterEntity) {
        super();

        s2d.add(this, 0, engineEntity.isPlayer() ? GameScene.RAGNAR_CHARACTER_LAYER : GameScene.ZOMBIE_CHARACTER_LAYER);

		this.engineEntity = engineEntity;
		setPosition(engineEntity.getX(), engineEntity.getY());

        switch (engineEntity.getEntityType()) {
            case EntityType.RAGNAR_LOH:
                animation = CharacterAnimations.LoadRagnarLohAnimation(this);
            case EntityType.RAGNAR_NORM:
                animation = CharacterAnimations.LoadRagnarNormAnimation(this);
            case EntityType.ZOMBIE_BOY:
                animation = CharacterAnimations.LoadZombieBoyAnimation(this);
                adjustRunAnimationSpeed();
            case EntityType.ZOMBIE_GIRL:
                animation = CharacterAnimations.LoadZombieGirlAnimation(this);
                adjustRunAnimationSpeed();
            default:
        }
    }

    // ------------------------------------------------------------
    // Abstraction
    // ------------------------------------------------------------

    public function update(dt:Float, fps:Float) {
        if (engineEntity.isAlive) {
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
                engineEntity.intersectsWithCharacter ? GameConfig.RedColor : GameConfig.BlueColor);
        } else if (engineEntity.botForwardLookingLine != null) {
            Utils.DrawLine(graphics, 
                engineEntity.botForwardLookingLine.x1,
                engineEntity.botForwardLookingLine.y1,
                engineEntity.botForwardLookingLine.x2,
                engineEntity.botForwardLookingLine.y2,
                engineEntity.intersectsWithCharacter ? GameConfig.RedColor : GameConfig.BlueColor);   
        }

        if (engineEntity.getCurrentActionRect() != null) {
            Utils.DrawRect(graphics, engineEntity.getCurrentActionRect(), GameConfig.GreenColor);
        }

        Utils.DrawRect(graphics, engineEntity.getBodyRectangle(), GameConfig.GreenColor);
    }
 
    // ------------------------------------------------------------
    // General
    // ------------------------------------------------------------

    public function setTragetServerPosition(x:Float, y:Float) {
        targetServerPosition.x = x;
        targetServerPosition.y = y;
    }

    public function moveToServerPosition(dt:Float, fps:Float) {
        animation.setSide(engineEntity.getSide());

        final distance = targetServerPosition.distance(new Point(x, y));
        if (distance > 1) {
            x = Math.lerp(x, targetServerPosition.x, 0.085);
            y = Math.lerp(y, targetServerPosition.y, 0.085);
        }

        if (animation.enableMoveAnimation && distance > 1) {
            animation.setAnimationState(RUN);
            // Do not enterrupt attack animation, because of interpolation character may still move 
        } else if (animation.getAnimationState() != CharacterAnimationState.ACTION_MAIN && distance < 1) {
            animation.setAnimationState(IDLE);
        }
    }

    public function actionMain() {
        animation.setAnimationState(ACTION_MAIN);
    }

    // ------------------------------------------------------------
    // FX
    // ------------------------------------------------------------

    private function adjustRunAnimationSpeed() {
        trace(engineEntity.getMovementSpeed(), engineEntity.getMovementSpeedFactor());

        animation.setRunAnimationSpeed(engineEntity.getMovementSpeedFactor());
    }

    public function fxActionMain() {
        switch (getEntityType()) {
            case RAGNAR_LOH:
                // final fxPosX = getSide() == RIGHT ? x + getBodyRectangle().w / 1.5 : x - getBodyRectangle().w / 1.5;
                // FxManager.instance.ragnarAttack(fxPosX, y, getSide());
                SoundManager.instance.playVikingHit();
            case ZOMBIE_BOY:
                final fxPosX = getSide() == RIGHT ? x : x;
                FxManager.instance.zombieAttack(fxPosX, y, getSide());
                SoundManager.instance.playZombieHit();
            case ZOMBIE_GIRL:
                final fxPosX = getSide() == RIGHT ? x : x;
                FxManager.instance.zombieAttack(fxPosX, y, getSide());
                SoundManager.instance.playZombieHit();
            default:
        }
    }

    public function fxHurt() {
        switch (getEntityType()) {
            case RAGNAR_LOH:
                FxManager.instance.blood(getSide() == RIGHT ? x + getBodyRectangle().w / 2 : x - getBodyRectangle().w / 2, y - getBodyRectangle().h / 5, getSide());
                SoundManager.instance.playVikingDmg();
            case ZOMBIE_BOY:
                FxManager.instance.blood(getSide() == RIGHT ? x + getBodyRectangle().w / 3 : x - getBodyRectangle().w / 3, y - getBodyRectangle().h / 5, getSide());
                SoundManager.instance.playZombieDmg();
            case ZOMBIE_GIRL:
                FxManager.instance.blood(getSide() == RIGHT ? x + getBodyRectangle().w / 3 : x - getBodyRectangle().w / 3, y - getBodyRectangle().h / 5, getSide());
                SoundManager.instance.playZombieDmg();
            default:
        }
    }

    public function fxDeath() {
        switch (getEntityType()) {
            case RAGNAR_LOH:
                SoundManager.instance.playVikingDeath();
            case RAGNAR_NORM:
                SoundManager.instance.playVikingDeath();
            case ZOMBIE_BOY:
                SoundManager.instance.playZombieDeath();
            case ZOMBIE_GIRL:
                SoundManager.instance.playZombieDeath();
            default:
        }
        animation.setAnimationState(DEAD);
    }

    // ------------------------------------------------------------
    // Getters
    // ------------------------------------------------------------

    public function getId() {
        return engineEntity.getId();
    }

    public function getOwnerId() {
        return engineEntity.getOwnerId();
    }

    public function getRect() {
        switch (getEntityType()) {
            case RAGNAR_LOH:
        		return new Rectangle(x, y, 221, 285, 0);
            case RAGNAR_NORM:
		        return new Rectangle(x, y, 221, 285, 0);
            case ZOMBIE_BOY:
		        return new Rectangle(x, y, 160, 235, 0);
            case ZOMBIE_GIRL:
		        return new Rectangle(x, y, 160, 235, 0);
            default:
                return null;
        }
	}

    public function getBottomRect() {
        switch (getEntityType()) {
            case RAGNAR_LOH:
        		return new Rectangle(x, y + 215 / 2, 221, 40, 0);
            case RAGNAR_NORM:
		        return new Rectangle(x, y + 215 / 2, 221, 40, 0);
            case ZOMBIE_BOY:
		        return new Rectangle(x, y + 190 / 2, 160, 40, 0);
            case ZOMBIE_GIRL:
		        return new Rectangle(x, y + 190 / 2, 160, 40, 0);
            default:
                return null;
        }
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

    public function getCurrentHealth() {
        return engineEntity.getCurrentHealth();
    }

    public function getMaxHealth() {
        return engineEntity.getMaxHealth();
    }

}