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

	var RAGNAR = 8;
}

class EntityShape {
	public var shape:ShapeStruct;

	public function new(shape:ShapeStruct) {
		this.shape = shape;

		if (shape.rectOffsetX == 0 && shape.rectOffsetY == 0) {
			this.shape.rectOffsetX = Std.int(shape.width / 2);
			this.shape.rectOffsetY = Std.int(shape.height / 2);
		}
	}

	public function toRect(x:Float, y:Float, rotation:Float, side:Side) {
		final sideOffset = side == RIGHT ? 0 : -shape.width + 45;
		return new Rectangle(x + this.shape.rectOffsetX + sideOffset, y + this.shape.rectOffsetY, shape.width, shape.height, rotation);
	}

	public function toJson() {
		return Json.stringify({
			width: shape.width,
			height: shape.height,
			rectOffsetX: shape.rectOffsetX,
			rectOffsetY: shape.rectOffsetY,
		});
	}
}

typedef CharacterMovementStruct = {
	canWalk:Bool,
	canRun:Bool,
	runSpeed:Int,
	movementDelay:Float,
	vitality:Int,
	vitalityConsumptionPerSec:Int,
	vitalityRegenPerSec:Int,
}

typedef ShapeStruct = {
	width:Int,
	height:Int,
	rectOffsetX:Int,
	rectOffsetY:Int,
}

typedef MeleeStruct = {
	aoe:Bool,
	shape: ShapeStruct,
}

typedef ProjectileStruct = {
	aoe:Bool,
	penetration:Bool,
	speed:Float,
	travelDistance:Float,
	projectiles:Int,
	shape: ShapeStruct,
	?aoeShape: ShapeStruct,
}

typedef CharacterActionStruct = {
	actionType:CharacterActionType,
	damage:Int,
	inputDelay:Float,
	?meleeStruct:MeleeStruct,
	?projectileStruct:ProjectileStruct,
}

typedef BaseEntityStruct = {
	x:Int,
	y:Int,
	?entityType:EntityType,
	?entityShape:ShapeStruct,
	?id:String,
	?ownerId:String,
	?rotation:Float,
}

typedef CharacterEntityMinStruct = {
    id:String,
    ?ownerId:String,
    x:Int,
    y:Int,
	?side: Side,
    ?entityType:EntityType,
}

typedef CharacterEntityFullStruct = {
	base:BaseEntityStruct,
	movement:CharacterMovementStruct,
	actionMain:CharacterActionStruct,
	?action1:CharacterActionStruct,
	?action2:CharacterActionStruct,
	?action3:CharacterActionStruct,
	?actionUltimate:CharacterActionStruct,
	health:Int,
}

typedef CharacterActionCallbackParams = { 
    entityId:String, 
    actionType:CharacterActionType, 
    shape:ShapeStruct, 
    hurtEntities: Array<String>,
    deadEntities: Array<String>,
};

class BaseEntity {
	public var x:Int;
	public var y:Int;
	public var entityType:EntityType;
	public var entityShape:ShapeStruct;
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

	public function getBaseStruct() {
		final struct:BaseEntityStruct = {
			x: this.x,
			y: this.y,
			entityType: this.entityType,
			entityShape: this.entityShape,
			id: this.id,
			ownerId: this.ownerId,
			rotation: this.rotation
		};
		return struct;
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
	public var side = Side.RIGHT;

	public function new(struct:CharacterEntityFullStruct) {
		super(struct.base);

		this.health = struct.health;
		this.movement = struct.movement;
		this.actionMain = struct.actionMain;
		this.action1 = struct.action1;
		this.action2 = struct.action2;
		this.action3 = struct.action3;
		this.actionUltimate = struct.actionUltimate;
	}

	public function toFullStruct() {
		final fullEntity:CharacterEntityFullStruct = {
			base: getBaseStruct(),
			movement: this.movement,
			health: this.health,
			actionMain: this.actionMain,
			action1: this.action1,
			action2: this.action2,
			action3: this.action3,
			actionUltimate: this.actionUltimate,
		};
		return fullEntity;
	}

	public function toMinStruct() {
		final minEntity:CharacterEntityMinStruct = {
			id: this.id,
			x: this.x,
			y: this.y,
			side: this.side,
		};
		return minEntity;
	}

	public static function CreateFromDynamic(struct:CharacterEntityFullStruct) {
		return new CharacterEntity(struct);
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
