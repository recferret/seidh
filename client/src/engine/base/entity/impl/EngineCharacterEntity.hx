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
	private var targetObjectEntity:EngineBaseEntity;
	private var randomizedTargetPos = new Point();

	private var lastDeltaTime:Float;

	public var isAlive = true;
	public var isCollides = true;
	public var canMove = true;
	public var intersectsWithCharacter = false;

	public var killerId:String;

	public var botForwardLookingLine:Line;
	private final botForwardLookingLineLength = 20;

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

		if (!isPlayer()) {
			botForwardLookingLine = new Line();
		} 

		// TODO base stuff
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

		if (customUpdate != null)
			customUpdate.onUpdate();

		if (targetObjectEntity != null)
			moveToTarget();

		if (customUpdate != null)
			customUpdate.postUpdate();

		renegerateVitality();
		updateHash();

		if (!this.isPlayer()) {
			final angleBetweenEntities = MathUtils.angleBetweenPoints(getBodyRectangle().getCenter(randomizedTargetPos.x, randomizedTargetPos.y), targetObjectEntity.getBodyRectangle().getCenter());
			baseEntity.rotation = angleBetweenEntities;

			final l = getForwardLookingLine(botForwardLookingLineLength);
			botForwardLookingLine.x1 = l.p1.x;
			botForwardLookingLine.y1 = l.p1.y; 
			botForwardLookingLine.x2 = l.p2.x;
			botForwardLookingLine.y2 = l.p2.y;

				// baseEntity.rotation = MathUtils.angleBetweenPoints(this.targetObjectEntity.getBodyRectangle().getCenter(), getBodyRectangle().getCenter());
		}
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
		final x = rect.getCenter().x;
		final y = rect.getCenter().y;
		return {
			p1: rect.getCenter(),
			p2: MathUtils.rotatePointAroundCenter(x + lineLength, y, x, y, baseEntity.rotation)
		}
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

		baseEntity.rotation = MathUtils.angleBetweenPoints(this.targetObjectEntity.getBodyRectangle().getCenter(), getBodyRectangle().getCenter());
	}

	public function getTargetObject() {
		return targetObjectEntity;
	}

	public function hasTargetObject() {
		return this.targetObjectEntity != null;
	}

	public function ifTargetInAttackRange() {
		return distanceBetweenTarget() < 80;
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

	public function moveToTarget() {
		if (canMove && !ifTargetInAttackRange()) {
			final speed = characterEntity.movement.runSpeed;

			dx = speed * Math.cos(baseEntity.rotation) * lastDeltaTime;
			dy = speed * Math.sin(baseEntity.rotation) * lastDeltaTime;

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

	public function aiMeleeAttack() {
		if (checkLocalActionInput(CharacterActionType.ACTION_MAIN)) {
			isActing = true;
		}
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
	}

	public function subtractHealth(subtract:Int) {
		characterEntity.health -= subtract;
		if (characterEntity.health < 0) {
			characterEntity.health = 0;
		}
		return characterEntity.health;
	}

	// ------------------------------------------------
	// Getters
	// ------------------------------------------------

	public function getEntityFullStruct() {
		return characterEntity.toFullStruct();
	}

	public function getEntityMinStruct() {
		return characterEntity.toMinStruct();
	}
	
	public function getCurrentActionRect() {
		if (actionToPerform.meleeStruct != null) {
			return actionToPerform.meleeStruct.shape.toRect(baseEntity.x, baseEntity.y, baseEntity.rotation, characterEntity.side);
		} else if (actionToPerform.projectileStruct != null) {
			return actionToPerform.projectileStruct.shape.toRect(baseEntity.x, baseEntity.y, baseEntity.rotation, characterEntity.side);
		} else {
			return null;
		}
	}

	public function getMovementSpeed() {
		return characterEntity.movement.runSpeed;
	}

	public function getHealth() {
		return characterEntity.health;
	}

	public function getSide() {
		return characterEntity.side;
	}

	// ------------------------------------------------
	// Setters
	// ------------------------------------------------

	public function setSide(side:Side) {
		characterEntity.side = side;
	}
}