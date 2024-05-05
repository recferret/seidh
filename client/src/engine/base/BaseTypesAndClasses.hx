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

enum abstract CharacterActionType(Int) {
	var MELEE_ATTACK_1 = 1;
	var MELEE_ATTACK_2 = 2;
	var MELEE_ATTACK_3 = 3;
	var RUN_ATTACK = 4;
	var RANGED_ATTACK1 = 5;
	var RANGED_ATTACK2 = 6;
	var DEFEND = 7;
}

enum abstract EntityType(Int) {
	var KNIGHT = 1;
	var SAMURAI = 2;
	var MAGE = 3;
	var SKELETON_WARRIOR = 4;
	var SKELETON_ARCHER = 5;
	var PROJECTILE_MAGIC_ARROW = 6;
	var PROJECTILE_MAGIC_SPHERE = 6;
}

class EntityShape {
	public var width:Int;
	public var height:Int;
	public var rectOffsetX:Int;
	public var rectOffsetY:Int;
	public var rotation = 0.0;

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

	public function toRect(x:Float, y:Float, side:Side) {
		final sideOffset = side == RIGHT ? 0 : -width + 45;
		return new Rectangle(x + this.rectOffsetX + sideOffset, y + this.rectOffsetY, width, height, 0);
	}

	public function toJson() {
		return Json.stringify({
			width: width,
			height: height,
			rectOffsetX: rectOffsetX,
			rectOffsetY: rectOffsetY,
			rotation: rotation,
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

typedef ProjectileStruct = {
	aoe:Bool,
	penetration:Bool,
	speed:Float,
	travelDistance:Float,
	projectiles:Int,
	shape: EntityShape,
}

typedef CharacterActionStruct = {
	actionType:CharacterActionType,
	damage:Int,
	shape: EntityShape,
	inputDelay:Float,
}

typedef BaseEntityStruct = {
	x:Int,
	y:Int,
	?entityType:EntityType,
	?entityShape:EntityShape,
	?id:String,
	?ownerId:String,
	?rotation:Float,
}

typedef CharacterEntityStruct = {
	base:BaseEntityStruct,
	characterMovementStruct:CharacterMovementStruct,
	characterActionStruct:Array<CharacterActionStruct>,
	dodgeChance:Int,
	health:Int,
}

class BaseEntity {
	public var x:Int;
	public var y:Int;
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
	public var dodgeChance:Int;
	public var movement:CharacterMovementStruct;
	public var actions:Array<CharacterActionStruct>;

	public function new(struct:CharacterEntityStruct) {
		super(struct.base);

		this.health = struct.health;
		this.dodgeChance = struct.dodgeChance;
		this.movement = struct.characterMovementStruct;
		this.actions = struct.characterActionStruct;
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
	x:Int,
	y:Int,
	side:Side
}

enum abstract PlayerInputType(Int) {
	var MOVE = 1;
	var MELEE_ATTACK = 2;
	var RANGED_ATTACK = 3;
	var DEFEND = 4;
}

class PlayerInputCommand {
	public var index:Int;
	public var inputType:PlayerInputType;
	public var movAngle: Float;
	public var playerId:String;

	public function new(inputType:PlayerInputType, movAngle:Float, playerId:String, ?index:Int) {
		this.inputType = inputType;
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
