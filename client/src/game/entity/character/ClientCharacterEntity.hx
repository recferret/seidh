package game.entity.character;

import game.sound.SoundManager;
import game.fx.FxManager;
import game.utils.Utils;
import game.entity.character.animation.CharacterAnimations;
import engine.base.BaseTypesAndClasses;
import engine.base.geometry.Point;
import engine.base.entity.impl.EngineCharacterEntity;
import hxd.Math;

class ClientCharacterEntity extends BasicClientEntity<EngineCharacterEntity> {

    public var animation:CharacterAnimation;

    var targetServerPosition = new Point();

    public function new(s2d:h2d.Scene) {
        super(s2d);
    }

    // ------------------------------------------------------------
    // Abstraction
    // ------------------------------------------------------------

    public function update(dt:Float) {
        moveToServerPosition(dt);
    }

	public function debugDraw(graphics:h2d.Graphics) {
        // Debug bot movement direction
        if (engineEntity.botForwardLookingLine != null) {
            final p1 = new h2d.col.Point(engineEntity.botForwardLookingLine.x1, engineEntity.botForwardLookingLine.y1);
            final p2 = new h2d.col.Point(engineEntity.botForwardLookingLine.x2, engineEntity.botForwardLookingLine.y2);
            Utils.DrawLine(graphics, p1, p2, engineEntity.intersectsWithCharacter ? GameConfig.RedColor : GameConfig.BlueColor);    
        }

        // DebugActionShape
        if (engineEntity.getCurrentActionRect(true) != null) {
            Utils.DrawRect(graphics, engineEntity.getCurrentActionRect(true), GameConfig.GreenColor);
        }

        Utils.DrawRect(graphics, engineEntity.getBodyRectangle(), GameConfig.GreenColor);
    }

    public function initiateEngineEntity(engineEntity:EngineCharacterEntity) {
		this.engineEntity = engineEntity;
		setPosition(engineEntity.getX(), engineEntity.getY());

        switch (engineEntity.getEntityType()) {
            case EntityType.RAGNAR_LOH:
                animation = CharacterAnimations.LoadRagnarLohAnimation(this);
            case EntityType.RAGNAR_NORM:
                animation = CharacterAnimations.LoadRagnarNormAnimation(this);
            case EntityType.ZOMBIE_BOY:
                animation = CharacterAnimations.LoadZombieBoyAnimation(this);
            case EntityType.ZOMBIE_GIRL:
                animation = CharacterAnimations.LoadZombieGirlAnimation(this);
            default:
        }
	}
 
    // ------------------------------------------------------------
    // General
    // ------------------------------------------------------------

    public function setTragetServerPosition(x:Float, y:Float) {
        targetServerPosition.x = x;
        targetServerPosition.y = y;
    }

    public function moveToServerPosition(dt:Float) {
        if (animation.enableMoveAnimation) {
            animation.setSide(engineEntity.getSide());

            final distance = targetServerPosition.distance(new Point(x, y));
            if (distance > 1) {
                animation.setAnimationState(RUN);
                x = Math.lerp(x, targetServerPosition.x, 0.045);
                y = Math.lerp(y, targetServerPosition.y, 0.045);
            } else {
                animation.setAnimationState(IDLE);
            }
        }
    }

    // ------------------------------------------------------------
    // FX
    // ------------------------------------------------------------

    public function fxActionMain() {
        switch (getEntityType()) {
            case RAGNAR_LOH:
                final fxPosX = getSide() == RIGHT ? x + getBodyRectangle().w / 1.5 : x - getBodyRectangle().w / 1.5;
                FxManager.instance.ragnarAttack(fxPosX, y, getSide());
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
            case RAGNAR_NORM:
                SoundManager.instance.playVikingDeath();
            case ZOMBIE_BOY:
            case ZOMBIE_GIRL:
                SoundManager.instance.playZombieDeath();
            default:
        }
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

    // ------------------------------------------------------------
    // Setters
    // ------------------------------------------------------------


    public function setSideDebug(side:Side) {
        if (GameConfig.Debug) {
            engineEntity.setSide(side);
            animation.setSide(side);
        }
    }
}