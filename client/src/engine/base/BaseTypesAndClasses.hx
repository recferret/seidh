package engine.base;

import haxe.Json;
import engine.base.geometry.Rectangle;

// -------------------------------
// General
// -------------------------------

enum abstract Side(Int) {
	var LEFT = 1;
	var RIGHT = 2;
}

enum abstract CharacterAnimationState(Int) {
	var IDLE = 1;
	var RUN = 2;
	var WALK = 3;

	var HURT = 4;
	var DEAD = 5;

	var ATTACK_1 = 6;
	var ATTACK_2 = 7;
	var ATTACK_3 = 8;
	var ATTACK_RUN = 9;

	var SHOT_1 = 10;
	var SHOT_2 = 11;

	var DEFEND = 12;
	var DODGE = 13;
}

enum abstract EntityType(Int) {
	var KNIGHT = 1;
	var SAMURAI = 2;
	var MAGE = 3;
	var SKELETON_WARRIOR = 4;
	var SKELETON_ARCHER = 5;
	var PROJECTILE_MAGIC_ARROW = 6;
	var PROJECTILE_MAGIC_SPHERE = 7;
}

class EntityShape {
	public var width:Int;
	public var height:Int;
	public var rectOffsetX:Int;
	public var rectOffsetY:Int;

	public function new(width:Int, height:Int, rectOffsetX:Int = 0, rectOffsetY:Int = 0) {
		this.width = width;
		this.height = height;

		if (rectOffsetX == 0 && rectOffsetY == 0) {
			this.rectOffsetX = Std.int(width / 2);
			this.rectOffsetY = Std.int(height / 2);
		} else {
			this.rectOffsetX = rectOffsetX;
			this.rectOffsetY = rectOffsetY;
		}
	}

	public function toRect(x:Float, y:Float, rotation:Float, side:Side) {
		final sideOffset = side == RIGHT ? 0 : -width + 45;
		return new Rectangle(x + this.rectOffsetX + sideOffset, y + this.rectOffsetY, width, height, rotation);
	}

	public function toJson() {
		return Json.stringify({
			width: width,
			height: height,
			rectOffsetX: rectOffsetX,
			rectOffsetY: rectOffsetY,
		});
	}
}

typedef CharacterMovementStruct = {
	canWalk:Bool,
	canRun:Bool,
	walkSpeed:Int,
	runSpeed:Int,
	movementDelay:Float,
	vitality:Int,
	vitalityConsumptionPerSec:Int,
	vitalityRegenPerSec:Int,
}

typedef MeleeStruct = {
	aoe:Bool,
	shape: EntityShape,
}

typedef ProjectileStruct = {
	aoe:Bool,
	penetration:Bool,
	speed:Float,
	travelDistance:Float,
	projectiles:Int,
	shape: EntityShape,
	?aoeShape: EntityShape,
}

typedef CharacterActionStruct = {
	actionType:CharacterActionType,
	damage:Int,
	inputDelay:Float,
	?meleeStruct:MeleeStruct,
	?projectileStruct:ProjectileStruct,
}

typedef BaseEntityStruct = {
	x:Float,
	y:Float,
	?entityType:EntityType,
	?entityShape:EntityShape,
	?id:String,
	?ownerId:String,
	?rotation:Float,
}

typedef CharacterEntityStruct = {
	base:BaseEntityStruct,
	characterMovementStruct:CharacterMovementStruct,
	characterActionMainStruct:CharacterActionStruct,
	?characterAction1Struct:CharacterActionStruct,
	?characterAction2Struct:CharacterActionStruct,
	?characterAction3Struct:CharacterActionStruct,
	?characterActionUltimate:CharacterActionStruct,
	health:Int,
}

class BaseEntity {
	public var x:Float;
	public var y:Float;
	public var entityType:EntityType;
	public var entityShape:EntityShape;
	public var id:String;
	public var ownerId:String;
	public var rotation:Float;

	public function new(struct:BaseEntityStruct) {
		this.x = struct.x;
		this.y = struct.y;
		this.entityType = struct.entityType;
		this.entityShape = struct.entityShape;
		this.id = struct.id;
		this.ownerId = struct.ownerId;
		this.rotation = struct.rotation;
	}
}

class CharacterEntity extends BaseEntity {
	public var health:Int;
	public var movement:CharacterMovementStruct;
	public var actionMain:CharacterActionStruct;
	public var action1:CharacterActionStruct;
	public var action2:CharacterActionStruct;
	public var action3:CharacterActionStruct;
	public var actionUltimate:CharacterActionStruct;

	public function new(struct:CharacterEntityStruct) {
		super(struct.base);

		this.health = struct.health;
		this.movement = struct.characterMovementStruct;
		this.actionMain = struct.characterActionMainStruct;
		this.action1 = struct.characterAction1Struct;
		this.action2 = struct.characterAction2Struct;
		this.action3 = struct.characterAction3Struct;
		this.actionUltimate = struct.characterActionUltimate;
	}
}

typedef ProjectileEntityStruct = {
	base:BaseEntityStruct,
	projectile:ProjectileStruct,
}

class ProjectileEntity extends BaseEntity {
	public var projectile:ProjectileStruct;

	public function new(struct:ProjectileEntityStruct) {
		super(struct.base);

		this.projectile = struct.projectile;
	}
}

// -------------------------------
// Multiplayer
// -------------------------------

// NEED SIDE ?

typedef CharacterEntityMinStruct = {
	id:String,
	x:Float,
	y:Float,
	side:Side
}

enum abstract CharacterActionType(Int) {
	var MOVE = 1;
	var ACTION_MAIN = 2;
	var ACTION_1 = 3;
	var ACTION_2 = 4;
	var ACTION_3 = 5;
	var ACTION_ULTIMATE = 6;
}

class PlayerInputCommand {
	public var index:Int;
	public var actionType:CharacterActionType;
	public var movAngle:Float;
	public var playerId:String;

	public function new(actionType:CharacterActionType, movAngle:Float, playerId:String, ?index:Int) {
		this.actionType = actionType;
		this.movAngle = movAngle;
		this.playerId = playerId;
		this.index = index;
	}
}

class InputCommandEngineWrapped {
	public var playerInputCommand:PlayerInputCommand;
	public var tick:Int;

	public function new(playerInputCommand:PlayerInputCommand, tick:Int) {
		this.playerInputCommand = playerInputCommand;
		this.tick = tick;
	}
}
