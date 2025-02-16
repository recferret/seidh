package engine.base.types;

import haxe.Int32;
import haxe.Json;
import engine.base.geometry.Rectangle;

// -----------------------------
// Actions
// -----------------------------

enum abstract CharacterActionType(Int) {
	var MOVE = 1;
	var ACTION_MAIN = 2;
	var ACTION_1 = 3;
	var ACTION_2 = 4;
	var ACTION_3 = 5;
	var ACTION_ULTIMATE = 6;
}

enum abstract CharacterActionEffect(Int) {
	var MELEE_ATTACK = 1;
	var RANGE_ATTACK = 2;
	var BUFF = 3;
	var SUMMON = 4;
	var TELEPORT = 5;
}

enum abstract CharacterActionState(Int) {
	var READY = 1;
	var IN_QUEUE = 2;
	var IN_PROGRESS = 3;
}

typedef MeleeStruct = {
	aoe:Bool,
	damage:Int,
	shape: ShapeStruct,
}

typedef ProjectileStruct = {
	aoe:Bool,
	damage:Int,
	penetrating:Bool,
	speed:Float,
	travelDistance:Float,
	shape: ShapeStruct,
	?aoeShape: ShapeStruct,
}

typedef CharacterMovementStruct = {
	canRun:Bool,
	runSpeed:Int,
	speedFactor:Int,
	inputDelay:Float,
}

typedef CharacterActionStruct = {
	actionType:CharacterActionType,
	actionEffect:CharacterActionEffect,
	inputDelay:Float,
	performDelayMs:Int,
	postDelayMs:Int,
	?meleeStruct:MeleeStruct,
	?projectileStruct:ProjectileStruct,
}

typedef CharacterActionCallbackParams = { 
    entityId:String,
	playActionAnim:Bool,
	playEffectAnim:Bool,
    actionType:CharacterActionType,
    actionEffect:CharacterActionEffect,
    ?damage:Int,
    ?shape:ShapeStruct,
    ?hurtEntities: Array<String>,
    ?deadEntities: Array<String>,
};

// -----------------------------
// Shapes
// -----------------------------

typedef ShapeStruct = {
	width:Int,
	height:Int,
	rectOffsetX:Int,
	rectOffsetY:Int,
	radius:Float,
}

class EntityShape {
	public var shape:ShapeStruct;

	public function new(shape:ShapeStruct) {
		this.shape = shape;
	}

	public function toRect(x:Float, y:Float, rotation:Float, side:Side) {
		final sideOffset = side == RIGHT ? shape.rectOffsetX : -shape.rectOffsetX;
		return new Rectangle(x + sideOffset, y + this.shape.rectOffsetY, shape.width, shape.height, rotation);
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

// -----------------------------
// Entities
// -----------------------------

enum abstract Side(Int) {
	var LEFT = 1;
	var RIGHT = 2;
}

enum abstract EntityType(String) {
	var RAGNAR_LOH = 'RAGNAR_LOH';
	var RAGNAR_BEAST = 'RAGNAR_BEAST';

	var ZOMBIE_BOY = 'ZOMBIE_BOY';
	var ZOMBIE_GIRL = 'ZOMBIE_GIRL';
	var GLAMR = 'GLAMR';

	var PROJECTILE_AXE = 'PROJECTILE_AXE';
	var PROJECTILE_SWORD = 'PROJECTILE_SWORD';

	var COIN = 'COIN';
	var HEALTH_POTION = 'HEALTH_POTION';
	var SALMON = 'SALMON';
}

// Base

typedef BaseEntityStruct = {
	x:Int,
	y:Int,
	?entityType:EntityType,
	?entityShape:ShapeStruct,
	?id:String,
	?ownerId:String,
	?rotation:Float,
}

class BaseEntity {
	public var x:Int;
	public var y:Int;
	public var entityType:EntityType;
	public var entityShape:ShapeStruct;
	public var id:String;
	public var ownerId:String;
	public var rotation:Float;
	public var side = Side.RIGHT;

	public function new(struct:BaseEntityStruct) {
		this.x = struct.x;
		this.y = struct.y;
		this.entityType = struct.entityType;
		this.entityShape = struct.entityShape;
		this.id = struct.id;
		this.ownerId = struct.ownerId;
		this.rotation = struct.rotation;

		if (this.rotation == null) {
			this.rotation = 0;
		}
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

// Character

typedef CharacterEntityMinStruct = {
    ?id:String,
    ?ownerId:String,
    x:Int,
    y:Int,
	?health:Int,
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

class CharacterEntity extends BaseEntity { 
	public var health:Int;
	public var movement:CharacterMovementStruct;
	public var actionMain:CharacterActionStruct;
	public var action1:CharacterActionStruct;
	public var action2:CharacterActionStruct;
	public var action3:CharacterActionStruct;
	public var actionUltimate:CharacterActionStruct;

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
			health: this.health,
			side: this.side,
		};
		return minEntity;
	}

	public static function CreateFromDynamic(struct:CharacterEntityFullStruct) {
		return new CharacterEntity(struct);
	}
}

// Projectile

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
