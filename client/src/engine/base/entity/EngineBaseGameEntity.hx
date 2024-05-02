package engine.base.entity;

import haxe.Int32;
import uuid.Uuid;
import engine.base.BaseTypesAndClasses;
import engine.base.geometry.Rectangle;

interface GameEntityCustomUpdate {
	public function onUpdate():Void;
	public function postUpdate():Void;
}

interface GameEntityCustomCollide {
	public function onCollide():Void;
}

abstract class EngineBaseGameEntity {
	
	// ----------------------
	// General
	// ----------------------
	private var baseObjectEntity:BaseObjectEntity;
	private var targetObjectEntity:EngineBaseGameEntity;
	private var lastDeltaTime:Float;
	private var previousTickHash:Int32;
	private var currentTickHash:Int32;

	public final isPlayer:Bool;
	public var isAlive = true;
	public var isCollides = true;

	public var killerId:String;

	// ----------------------
	// Movement
	// ----------------------

	public var currentDirectionSide = Side.RIGHT;
	public var currentVitality:Int;
	public var isWalking = false;
	public var isRunning = false;

	// private var lastMovementInputCheck = 0.0;
	private var lastLocalMovementInputCheck = 0.0;

	public var dx = 0.0;
	public var dy = 0.0;

	// ----------------------
	// Actions
	// ----------------------

	public var isActing = false;
	public var actionToPerform:EntityActionStruct;

	private var lastLocalMeleeAttackInputCheck = 0.0;
	private var lastLocalRangedInputCheck = 0.0;
	private var lastLocalDefendInputCheck = 0.0;

	private final meleeActions = new Array<EntityActionStruct>();
	private final rangedActions = new Array<EntityActionStruct>();
	private final defendAction:EntityActionStruct;
	private final runAttackAction:EntityActionStruct;

	// ----------------------
	// Callbacks
	// ----------------------

	public var customUpdate:GameEntityCustomUpdate;
	public var customCollide:GameEntityCustomCollide;

	public function new(baseObjectEntity:BaseObjectEntity) {
		this.baseObjectEntity = baseObjectEntity;

		this.isPlayer = [EntityType.KNIGHT, EntityType.SAMURAI].contains(this.baseObjectEntity.entityType);

		if (baseObjectEntity.id == null) {
			this.baseObjectEntity.id = Uuid.short();
		}
		if (baseObjectEntity.ownerId == null) {
			this.baseObjectEntity.ownerId = Uuid.short();
		}

		currentVitality = this.baseObjectEntity.movement.vitality;

		for (action in this.baseObjectEntity.actions) {
			switch (action.actionType) {
				case EntityActionType.MELEE_ATTACK_1:
					meleeActions.push(action);
				case EntityActionType.MELEE_ATTACK_2:
					meleeActions.push(action);
				case EntityActionType.MELEE_ATTACK_3:
					meleeActions.push(action);
				case EntityActionType.RUN_ATTACK:
					runAttackAction = action;
				case EntityActionType.RANGED_ATTACK1:
					rangedActions.push(action);
				case EntityActionType.RANGED_ATTACK2:
					rangedActions.push(action);
				case EntityActionType.DEFEND:
					defendAction = action;
			}
		}
	}

	// ------------------------------------------------
	// Abstract
	// ------------------------------------------------

	public abstract function canPerformMove(playerInputType:PlayerInputType):Bool;

	public abstract function canPerformAction(playerInputType:PlayerInputType):Bool;

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
	}

	public function getBodyRectangle() {
		final shapeWidth = baseObjectEntity.entityShape.width;
		final shapeHeight = baseObjectEntity.entityShape.height;
		final rectOffsetX = baseObjectEntity.entityShape.rectOffsetX;
		final rectOffsetY = baseObjectEntity.entityShape.rectOffsetY;
		final x = baseObjectEntity.x;
		final y = baseObjectEntity.y;
		return new Rectangle(x + rectOffsetX, y + rectOffsetY, shapeWidth, shapeHeight, baseObjectEntity.entityShape.rotation);
	}

	public function getVirtualBodyRectangleInFuture(ticks:Int) {
		final cachedPositionX = baseObjectEntity.x;
		final cachedPositionY = baseObjectEntity.y;
		for (i in 0...ticks) {
			// move();
		}
		final resultingRect = getBodyRectangle();
		baseObjectEntity.x = cachedPositionX;
		baseObjectEntity.y = cachedPositionY;
		return resultingRect;
	}

	public function getForwardLookingLine(lineLength:Int) {
		final rect = getBodyRectangle();
		final x = rect.getCenter().x;
		final y = rect.getCenter().y;
		return {
			p1: rect.getCenter(),
			p2: MathUtils.rotatePointAroundCenter(x + lineLength, y, x, y, baseObjectEntity.rotation)
		}
	}

	public function collides(isCollides:Bool) {
		this.isCollides = isCollides;
		if (customCollide != null)
			customCollide.onCollide();
	}

	public function isChanged() {
		return previousTickHash != currentTickHash;
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

	public function setTargetObject(targetObjectEntity:EngineBaseGameEntity) {
		this.targetObjectEntity = targetObjectEntity;
	}

	public function hasTargetObject() {
		return this.targetObjectEntity != null;
	}

	public function ifTargetInAttackRange() {
		return distanceBetweenTarget() < 100;
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
		if (baseObjectEntity.movement.canRun && !isWalking && !isRunning) {
			currentVitality += baseObjectEntity.movement.vitalityRegenPerSec;
		}
	}

	public function determenisticMove() {
		var speed = baseObjectEntity.movement.walkSpeed;

		if (baseObjectEntity.movement.canRun && currentVitality > 0) {
			currentVitality -= baseObjectEntity.movement.vitalityConsumptionPerSec;
			speed = baseObjectEntity.movement.runSpeed;
			isRunning = true;
			isWalking = false;
		} else {
			isRunning = false;
			isWalking = true;
		}

		dx = speed * Math.cos(baseObjectEntity.rotation);
		dy = speed * Math.sin(baseObjectEntity.rotation);

		currentDirectionSide = (baseObjectEntity.x + dx) > baseObjectEntity.x ? Side.RIGHT : Side.LEFT;

		baseObjectEntity.x += Std.int(dx);
		baseObjectEntity.y += Std.int(dy);
	}

	public function moveToTarget() {
		if (!ifTargetInAttackRange()) {
			final angleBetweenEntities = MathUtils.angleBetweenPoints(getBodyRectangle().getCenter(), targetObjectEntity.getBodyRectangle().getCenter());

			var speed = baseObjectEntity.movement.walkSpeed;

			dx = speed * Math.cos(angleBetweenEntities) * lastDeltaTime;
			dy = speed * Math.sin(angleBetweenEntities) * lastDeltaTime;

			currentDirectionSide = (baseObjectEntity.x + dx) > baseObjectEntity.x ? Side.RIGHT : Side.LEFT;

			baseObjectEntity.x += Std.int(dx);
			baseObjectEntity.y += Std.int(dy);
		}
	}

	public function checkLocalMovementInput() {
		final now = haxe.Timer.stamp();
		if (lastLocalMovementInputCheck == 0 || lastLocalMovementInputCheck + baseObjectEntity.movement.movementDelay < now) {
			lastLocalMovementInputCheck = now;
			return true;
		} else {
			return false;
		}
	}

	public function checkLocalActionInputAndPrepare(playerInputType:PlayerInputType) {
		final now = haxe.Timer.stamp();
		final hardcodedActionInputDelay = 1;

		var allow = false;

		if (playerInputType == PlayerInputType.MELEE_ATTACK) {
			if (lastLocalMeleeAttackInputCheck == 0 || lastLocalMeleeAttackInputCheck + hardcodedActionInputDelay < now) {
				lastLocalMeleeAttackInputCheck = now;
				allow = true;

				actionToPerform = isRunning ? runAttackAction : getRandomMeleeAction();
			}
		} else if (playerInputType == PlayerInputType.RANGED_ATTACK) {
			if (lastLocalRangedInputCheck == 0 || lastLocalRangedInputCheck + hardcodedActionInputDelay < now) {
				lastLocalRangedInputCheck = now;
				allow = true;

				actionToPerform = rangedActions[Std.random(rangedActions.length)];
			}
		} else if (playerInputType == PlayerInputType.DEFEND) {
			if (lastLocalDefendInputCheck == 0 || lastLocalDefendInputCheck + hardcodedActionInputDelay < now) {
				lastLocalDefendInputCheck = now;
				allow = true;

				actionToPerform = defendAction;
			}
		}

		return allow;
	}

	public function aiMeleeAttack() {
		if (checkLocalActionInputAndPrepare(PlayerInputType.MELEE_ATTACK)) {
			isActing = true;
		}
	}

	public function setRandomMeleeAction() {
		isActing = true;
		actionToPerform = getRandomMeleeAction();
	}

	public function setNextActionToPerform(entityActionType:EntityActionType) {
		isActing = true;
		switch (entityActionType) {
			case MELEE_ATTACK_1:
				actionToPerform = meleeActions[0];
			case MELEE_ATTACK_2:
				actionToPerform = meleeActions[1];
			case MELEE_ATTACK_3:
				actionToPerform = meleeActions[2];
			case RUN_ATTACK:
				actionToPerform = runAttackAction;
			case RANGED_ATTACK1:
				actionToPerform = rangedActions[0];
			case RANGED_ATTACK2:
				actionToPerform = rangedActions[1];
			case DEFEND:
				actionToPerform = defendAction;
		}
	}

	public function addHealth(add:Int) {
		baseObjectEntity.health += add;
	}

	public function subtractHealth(subtract:Int) {
		baseObjectEntity.health -= subtract;
		if (baseObjectEntity.health < 0) {
			baseObjectEntity.health = 0;
		}
		return baseObjectEntity.health;
	}

	private function getRandomMeleeAction() {
		return meleeActions[Std.random(meleeActions.length)];
	}

	// ------------------------------------------------
	// Getters
	// ------------------------------------------------

	public function getFullEntity() {
		return baseObjectEntity;
	}

	public function getMinEntity() {
		final minEntity:EntityMinStruct = {
			id: baseObjectEntity.id,
			x: baseObjectEntity.x,
			y: baseObjectEntity.y,
			side: currentDirectionSide
		};
		return minEntity;
	}

	public function getX() {
		return baseObjectEntity.x;
	}

	public function getY() {
		return baseObjectEntity.y;
	}

	public function getId() {
		return baseObjectEntity.id;
	}

	public function getEntityType() {
		return baseObjectEntity.entityType;
	}

	public function getOwnerId() {
		return baseObjectEntity.ownerId;
	}

	public function getRotation() {
		return baseObjectEntity.rotation;
	}
	
	public function getCurrentActionRect() {
		return actionToPerform.shape.toRect(baseObjectEntity.x, baseObjectEntity.y, currentDirectionSide);
	}

	public function getHealth() {
		return baseObjectEntity.health;
	}

	// ------------------------------------------------
	// Setters
	// ------------------------------------------------

	public function setX(x:Int) {
		baseObjectEntity.x = x;
	}

	public function setY(y:Int) {
		baseObjectEntity.y = y;
	}

	public function setRotation(r:Float) {
		baseObjectEntity.rotation = r;
	}

}
