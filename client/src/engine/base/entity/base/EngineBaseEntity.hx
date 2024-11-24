package engine.base.entity.base;

import haxe.Int32;

import engine.base.geometry.Circle;
import engine.base.BaseTypesAndClasses;
import engine.base.geometry.Rectangle;

abstract class EngineBaseEntity {

	public var serverX:Int;
	public var serverY:Int;
    final baseEntity:BaseEntity;
    var previousTickHash:Int32;
	var currentTickHash:Int32;

    public function new(baseEntity:BaseEntity) {
        this.baseEntity = baseEntity;
    }

    public abstract function update(dt:Float):Void;

	public function isChanged() {
		return previousTickHash != currentTickHash;
	}

    // ------------------------------------------------
    // General
    // ------------------------------------------------

	public function moveBy(x:Float, y:Float) {
		baseEntity.x += Std.int(x);
		baseEntity.y += Std.int(y);
	}

    // ------------------------------------------------
    // Getters
    // ------------------------------------------------

	public function getBodyRectangle(rotated:Bool = false) {
		final shapeWidth = baseEntity.entityShape.width;
		final shapeHeight = baseEntity.entityShape.height;
		final rectOffsetX = baseEntity.entityShape.rectOffsetX;
		final rectOffsetY = baseEntity.entityShape.rectOffsetY;
		final x = baseEntity.x;
		final y = baseEntity.y;
		return new Rectangle(x + 0, y + rectOffsetY, shapeWidth, shapeHeight, rotated ? baseEntity.rotation : 0);
		// return new Rectangle(x + (baseEntity.side == Side.RIGHT ? -rectOffsetX : rectOffsetX), y + rectOffsetY, shapeWidth, shapeHeight, rotated ? baseEntity.rotation : 0);
	}

	public function getBodyCircle() {
		final x = baseEntity.x;
		final y = baseEntity.y;
		return new Circle(x, y, baseEntity.entityShape.radius);
	}

    public function getX() {
		return baseEntity.x;
	}

	public function getY() {
		return baseEntity.y;
	}

	public function getId() {
		return baseEntity.id;
	}

	public function getEntityType() {
		return baseEntity.entityType;
	}

	public function getOwnerId() {
		return baseEntity.ownerId;
	}

	public function getRotation() {
		return baseEntity.rotation;
	}

	public function isPlayer() {
		return baseEntity.entityType == EntityType.RAGNAR_LOH || baseEntity.entityType == EntityType.RAGNAR_NORM;
	}

	public function isBot() {
		return baseEntity.entityType == EntityType.ZOMBIE_BOY || baseEntity.entityType == EntityType.ZOMBIE_GIRL;
	}

    // ------------------------------------------------
    // Setters
    // ------------------------------------------------

    public function setX(x:Int) {
		baseEntity.x = x;
	}

	public function setY(y:Int) {
		baseEntity.y = y;
	}

	public function setRotation(r:Float) {
		baseEntity.rotation = r;
	}

}