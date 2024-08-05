package engine.base.entity.impl;

import haxe.Int32;
import uuid.Uuid;
import engine.base.BaseTypesAndClasses;
import engine.base.entity.base.EngineBaseEntity;
import engine.base.geometry.Point;
import engine.base.geometry.Line;

interface GameEntityCustomUpdate {
	public function onUpdate():Void;
	public function postUpdate():Void;
}

interface GameEntityCustomCollide {
	public function onCollide():Void;
}

abstract class EngineCharacterEntity extends EngineBaseEntity {

    // ------------------------------------------------
	// General
	// ------------------------------------------------

	private var characterEntity:CharacterEntity;
	private var maxHealth:Int;

	private var targetObjectEntity:EngineBaseEntity;
	private var randomizedTargetPos = new Point();

	private var lastDeltaTime:Float;

	public var isAlive = true;
	public var isCollides = true;
	public var canMove = true;
	public var intersectsWithCharacter = false;

	public var killerId:String;

	public final playerForwardLookingLineLength = 200;
	public final botForwardLookingLineLength = 100;

	public var botForwardLookingLine:Line;
	
	private final botAttackRange = 200;

	// ------------------------------------------------
	// Movement
	// ------------------------------------------------

	public var currentVitality:Int;
	public var isWalking = false;
	public var isRunning = false;

	private var lastLocalMovementInputCheck = 0.0;

	public var dx = 0.0;
	public var dy = 0.0;

	// ------------------------------------------------
	// Actions
	// ------------------------------------------------

	public var isActing = false;
	public var actionToPerform:CharacterActionStruct;

	private var lastActionMainInputCheck = 0.0;
	private var lastAction1InputCheck = 0.0;
	private var lastAction2InputCheck = 0.0;
	private var lastAction3InputCheck = 0.0;
	private var lastActionUltimateInputCheck = 0.0;

	private final actionMain:CharacterActionStruct;
	private final action1:CharacterActionStruct;
	private final action2:CharacterActionStruct;
	private final action3:CharacterActionStruct;
	private final actionUltimate:CharacterActionStruct;

	// ------------------------------------------------
	// Callbacks
	// ------------------------------------------------

	public var customUpdate:GameEntityCustomUpdate;
	public var customCollide:GameEntityCustomCollide;

	public function new(characterEntity:CharacterEntity) {
		super(characterEntity);

		this.characterEntity = characterEntity;
		maxHealth = characterEntity.health;

		if (!isPlayer()) {
			botForwardLookingLine = new Line();
		}

		if (baseEntity.id == null) {
			baseEntity.id = Uuid.short();
		}
		if (baseEntity.ownerId == null) {
			baseEntity.ownerId = Uuid.short();
		}

		currentVitality = this.characterEntity.movement.vitality;

		actionMain = this.characterEntity.actionMain;
		action1 = this.characterEntity.action1;
		action2 = this.characterEntity.action2;
		action3 = this.characterEntity.action3;
		actionUltimate = this.characterEntity.actionUltimate;
	}

	// ------------------------------------------------
	// Abstract
	// ------------------------------------------------

	public abstract function canPerformMove():Bool;

	public abstract function canPerformAction(characterActionType:CharacterActionType):Bool;

	public abstract function updateHashImpl():Int32;

	// ------------------------------------------------
	// General
	// ------------------------------------------------

	public function update(dt:Float) {
		lastDeltaTime = dt;

		if (hasTargetObject() && !isPlayer()) {
			// Rotate bot in the target direction
			final angleBetweenEntities = MathUtils.angleBetweenPoints(getBodyRectangle().getCenter(), targetObjectEntity.getBodyRectangle().getCenter());
			baseEntity.rotation = angleBetweenEntities;

			// Bot line sight for debug
			final l = getForwardLookingLine(botForwardLookingLineLength);
			botForwardLookingLine.x1 = l.x1;
			botForwardLookingLine.y1 = l.y1; 
			botForwardLookingLine.x2 = l.x2;
			botForwardLookingLine.y2 = l.y2;
		}

		if (customUpdate != null)
			customUpdate.onUpdate();

		// Ai
		if (hasTargetObject() && !isPlayer()) {
			aiMoveToTarget();
			if (EngineConfig.AI_ATTACK_ENABLED) {
				if (ifTargetInAttackRange()) {
					aiMeleeAttack();
				}
			}
		}

		if (customUpdate != null)
			customUpdate.postUpdate();

		renegerateVitality();
		updateHash();
	}

	public function getVirtualBodyRectangleInFuture(ticks:Int) {
		final cachedPositionX = baseEntity.x;
		final cachedPositionY = baseEntity.y;
		for (i in 0...ticks) {
			// move();
		}
		final resultingRect = getBodyRectangle();
		baseEntity.x = cachedPositionX;
		baseEntity.y = cachedPositionY;
		return resultingRect;
	}

	public function getForwardLookingLine(lineLength:Int) {
		final rect = getBodyRectangle();
		final x1 = rect.getCenter().x;
		final y1 = rect.getCenter().y;

		final p = MathUtils.rotatePointAroundCenter(x1 + lineLength, y1, x1, y1, baseEntity.rotation);
		final x2 = p.x;
		final y2 = p.y;

		return new Line(x1, y1, x2, y2);
	}

	function updateHash() {
		final hash = updateHashImpl();
		if (previousTickHash == null && currentTickHash == null) {
			previousTickHash = hash;
			currentTickHash = hash;
		} else {
			previousTickHash = currentTickHash;
			currentTickHash = hash;
		}
	}

	// ------------------------------------------------
	// Target
	// ------------------------------------------------

	public function setTargetObject(targetObjectEntity:EngineBaseEntity, randomizePos:Bool = false) {
		this.targetObjectEntity = targetObjectEntity;

		if (randomizePos) {
			final minusX = MathUtils.randomIntInRange(1, 2) == 1 ? true : false;
			final minusY = MathUtils.randomIntInRange(1, 2) == 1 ? true : false;
			final rndX = MathUtils.randomIntInRange(1, 30);
			final rndY = MathUtils.randomIntInRange(1, 30);
			randomizedTargetPos.x = minusX ? -rndX : rndX;
			randomizedTargetPos.y = minusY ? -rndY : rndY;
		} else {
			randomizedTargetPos.x = 0;
			randomizedTargetPos.y = 0;
		}
	}

	public function clearTargetObject() {
		this.targetObjectEntity = null;
	}

	public function getTargetObject() {
		return targetObjectEntity;
	}

	public function hasTargetObject() {
		return this.targetObjectEntity != null;
	}

	public function ifTargetInAttackRange() {
		return distanceBetweenTarget() < botAttackRange;
	}

	private function distanceBetweenTarget() {
		if (hasTargetObject()) {
			return getBodyRectangle().getCenter().distance(targetObjectEntity.getBodyRectangle().getCenter());
		} else {
			return 0;
		}
	}

	// ------------------------------------------------
	// Movement and input
	// ------------------------------------------------

	private function renegerateVitality() {
		if (characterEntity.movement.canRun && !isWalking && !isRunning) {
			currentVitality += characterEntity.movement.vitalityRegenPerSec;
		}
	}

	public function determenisticMove() {
		if (canMove) {
			var speed = characterEntity.movement.runSpeed;

			if (characterEntity.movement.canRun && currentVitality > 0) {
				currentVitality -= characterEntity.movement.vitalityConsumptionPerSec;
				speed = characterEntity.movement.runSpeed;
				isRunning = true;
				isWalking = false;
			} else {
				isRunning = false;
				isWalking = true;
			}

			dx = speed * Math.cos(baseEntity.rotation);
			dy = speed * Math.sin(baseEntity.rotation);

			characterEntity.side = (baseEntity.x + dx) > baseEntity.x ? Side.RIGHT : Side.LEFT;

			baseEntity.x += Std.int(dx);
			baseEntity.y += Std.int(dy);
		}
	}

	public function checkLocalMovementInput() {
		final now = haxe.Timer.stamp();
		if (lastLocalMovementInputCheck == 0 || lastLocalMovementInputCheck + characterEntity.movement.movementDelay < now) {
			lastLocalMovementInputCheck = now;
			return true;
		} else {
			return false;
		}
	}

	public function checkLocalActionInput(characterActionType:CharacterActionType) {
		final now = haxe.Timer.stamp();
		var allow = false;

		switch (characterActionType) {
			case CharacterActionType.ACTION_MAIN:
				if (lastActionMainInputCheck == 0 || lastActionMainInputCheck + actionMain.inputDelay < now) {
					lastActionMainInputCheck = now;
					allow = true;
				}
			case CharacterActionType.ACTION_1:
				if (lastAction1InputCheck == 0 || lastAction1InputCheck + action1.inputDelay < now) {
					lastAction1InputCheck = now;
					allow = true;
				}
			case CharacterActionType.ACTION_2:
				if (lastAction2InputCheck == 0 || lastAction2InputCheck + action2.inputDelay < now) {
					lastAction2InputCheck = now;
					allow = true;
				}
			case CharacterActionType.ACTION_3:
				if (lastAction3InputCheck == 0 || lastAction3InputCheck + action3.inputDelay < now) {
					lastAction3InputCheck = now;
					allow = true;
				}
			case CharacterActionType.ACTION_ULTIMATE:
				if (lastActionUltimateInputCheck == 0 || lastActionUltimateInputCheck + actionUltimate.inputDelay < now) {
					lastActionUltimateInputCheck = now;
					allow = true;
				}
			default:
		}

		return allow;
	}

	public function setNextActionToPerform(characterActionType:CharacterActionType) {
		isActing = true;
		switch (characterActionType) {
			case CharacterActionType.ACTION_MAIN:
				actionToPerform = actionMain;
			case CharacterActionType.ACTION_1:
				actionToPerform = action1;
			case CharacterActionType.ACTION_2:
				actionToPerform = action2;
			case CharacterActionType.ACTION_3:
				actionToPerform = action3;
			case CharacterActionType.ACTION_ULTIMATE:
				actionToPerform = actionUltimate;
			default:
		}
	}

	public function addHealth(add:Int) {
		characterEntity.health += add;
		if (characterEntity.health > maxHealth) {
			characterEntity.health = maxHealth;
		}
	}

	public function subtractHealth(subtract:Int) {
		characterEntity.health -= subtract;
		if (characterEntity.health < 0) {
			characterEntity.health = 0;
		}
		return characterEntity.health;
	}

	// ------------------------------------------------
	// AI
	// ------------------------------------------------

	private function aiMoveToTarget() {
		if (canMove && !ifTargetInAttackRange()) {
			final speed = characterEntity.movement.runSpeed;

			dx = speed * Math.cos(baseEntity.rotation) * lastDeltaTime;
			dy = speed * Math.sin(baseEntity.rotation) * lastDeltaTime;

			if (dx > 0.1 && dx < 1) {
				dx = 1;
			}
			if (dy > 0 && dy < 1) {
				dy = 1;
			}

			characterEntity.side = (baseEntity.x + dx) > baseEntity.x ? Side.RIGHT : Side.LEFT;

			baseEntity.x += Std.int(dx);
			baseEntity.y += Std.int(dy);
		}
	}

	public function aiMeleeAttack() {
		if (checkLocalActionInput(CharacterActionType.ACTION_MAIN)) {
			setNextActionToPerform(CharacterActionType.ACTION_MAIN);
		}
	}

	// ------------------------------------------------
	// Getters
	// ------------------------------------------------

	// Make it a part of an abstraction
	public function getEntityFullStruct() {
		return characterEntity.toFullStruct();
	}

	public function getEntityMinStruct() {
		return characterEntity.toMinStruct();
	}
	
	public function getCurrentActionRect() {
		final action = actionToPerform;

		if (action == null)
			return null;
		if (action.meleeStruct != null) {
			final shape = new EntityShape(action.meleeStruct.shape);

			final rect = shape.toRect(
				getBodyRectangle().getCenter().x,
				getBodyRectangle().getCenter().y,
				0, 
				characterEntity.side
			);

			return rect;
		} else if (action.projectileStruct != null) {
			final shape = new EntityShape(action.projectileStruct.shape);
			final rect = shape.toRect(
				baseEntity.x, 
				baseEntity.y, 
				0, 
				characterEntity.side
			);
			return rect;
		} else {
			return null;
		}
	}

	public function getMovementSpeed() {
		return characterEntity.movement.runSpeed;
	}

	public function getCurrentHealth() {
		return characterEntity.health;
	}

	public function getMaxHealth() {
		return maxHealth;
	}

	public function getSide() {
		return characterEntity.side;
	}

	public function getShape() {
		return characterEntity.entityShape;
	}

	// ------------------------------------------------
	// Setters
	// ------------------------------------------------

	public function setSide(side:Side) {
		characterEntity.side = side;
	}

	public function setHealth(health:Int) {
		return characterEntity.health = health;
	}
}