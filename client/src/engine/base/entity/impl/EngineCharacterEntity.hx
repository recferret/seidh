package engine.base.entity.impl;

import haxe.Int32;
import uuid.Uuid;
import engine.base.BaseTypesAndClasses;
import engine.base.entity.base.EngineBaseEntity;

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
	private var lastDeltaTime:Float;

	public final isPlayer:Bool;
	public var isAlive = true;
	public var isCollides = true;

	public var killerId:String;

	// ------------------------------------------------
	// Movement
	// ------------------------------------------------

	public var currentDirectionSide = Side.RIGHT;
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

	private var lastLocalMeleeAttackInputCheck = 0.0;
	private var lastLocalRangedInputCheck = 0.0;
	private var lastLocalDefendInputCheck = 0.0;

	private final meleeActions = new Array<CharacterActionStruct>();
	private final rangedActions = new Array<CharacterActionStruct>();
	private var defendAction:CharacterActionStruct;
	private var runAttackAction:CharacterActionStruct;

	// ------------------------------------------------
	// Callbacks
	// ------------------------------------------------

	public var customUpdate:GameEntityCustomUpdate;
	public var customCollide:GameEntityCustomCollide;

	public function new(characterEntity:CharacterEntity) {
		super(characterEntity);

		this.characterEntity = characterEntity;

		this.isPlayer = [EntityType.KNIGHT, EntityType.SAMURAI].contains(baseEntity.entityType);

		if (baseEntity.id == null) {
			baseEntity.id = Uuid.short();
		}
		if (baseEntity.ownerId == null) {
			baseEntity.ownerId = Uuid.short();
		}

		currentVitality = this.characterEntity.movement.vitality;

		for (action in this.characterEntity.actions) {
			switch (action.actionType) {
				case CharacterActionType.MELEE_ATTACK_1:
					meleeActions.push(action);
				case CharacterActionType.MELEE_ATTACK_2:
					meleeActions.push(action);
				case CharacterActionType.MELEE_ATTACK_3:
					meleeActions.push(action);
				case CharacterActionType.RUN_ATTACK:
					runAttackAction = action;
				case CharacterActionType.RANGED_ATTACK1:
					rangedActions.push(action);
				case CharacterActionType.RANGED_ATTACK2:
					rangedActions.push(action);
				case CharacterActionType.DEFEND:
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

	public function setTargetObject(targetObjectEntity:EngineBaseEntity) {
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
		if (characterEntity.movement.canRun && !isWalking && !isRunning) {
			currentVitality += characterEntity.movement.vitalityRegenPerSec;
		}
	}

	public function determenisticMove() {
		var speed = characterEntity.movement.walkSpeed;

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

		currentDirectionSide = (baseEntity.x + dx) > baseEntity.x ? Side.RIGHT : Side.LEFT;

		baseEntity.x += Std.int(dx);
		baseEntity.y += Std.int(dy);
	}

	public function moveToTarget() {
		if (!ifTargetInAttackRange()) {
			final angleBetweenEntities = MathUtils.angleBetweenPoints(getBodyRectangle().getCenter(), targetObjectEntity.getBodyRectangle().getCenter());
			final speed = characterEntity.movement.walkSpeed;

			dx = speed * Math.cos(angleBetweenEntities) * lastDeltaTime;
			dy = speed * Math.sin(angleBetweenEntities) * lastDeltaTime;

			currentDirectionSide = (baseEntity.x + dx) > baseEntity.x ? Side.RIGHT : Side.LEFT;

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

	public function setNextActionToPerform(characterActionType:CharacterActionType) {
		isActing = true;
		switch (characterActionType) {
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
		characterEntity.health += add;
	}

	public function subtractHealth(subtract:Int) {
		characterEntity.health -= subtract;
		if (characterEntity.health < 0) {
			characterEntity.health = 0;
		}
		return characterEntity.health;
	}

	private function getRandomMeleeAction() {
		return meleeActions[Std.random(meleeActions.length)];
	}

	// ------------------------------------------------
	// Getters
	// ------------------------------------------------

	public function getFullEntity() {
		return characterEntity;
	}

	public function getMinEntity() {
		final minEntity:CharacterEntityMinStruct = {
			id: baseEntity.id,
			x: baseEntity.x,
			y: baseEntity.y,
			side: currentDirectionSide
		};
		return minEntity;
	}
	
	public function getCurrentActionRect() {
		return actionToPerform.shape.toRect(baseEntity.x, baseEntity.y, currentDirectionSide);
	}

	public function getHealth() {
		return characterEntity.health;
	}

}