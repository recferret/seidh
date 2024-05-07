package engine.base.entity.base;

import haxe.Int32;
import engine.base.BaseTypesAndClasses;
import engine.base.geometry.Rectangle;

abstract class EngineBaseEntity {

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
		baseEntity.x += x;
		baseEntity.y += y;
	}

    // ------------------------------------------------
    // Getters
    // ------------------------------------------------

	public function getBodyRectangle() {
		final shapeWidth = baseEntity.entityShape.width;
		final shapeHeight = baseEntity.entityShape.height;
		final rectOffsetX = baseEntity.entityShape.rectOffsetX;
		final rectOffsetY = baseEntity.entityShape.rectOffsetY;
		final x = baseEntity.x;
		final y = baseEntity.y;
		return new Rectangle(x + rectOffsetX, y + rectOffsetY, shapeWidth, shapeHeight, baseEntity.entityShape.rotation);
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

    // ------------------------------------------------
    // Setters
    // ------------------------------------------------

    public function setX(x:Float) {
		baseEntity.x = x;
	}

	public function setY(y:Float) {
		baseEntity.y = y;
	}

	public function setRotation(r:Float) {
		baseEntity.rotation = r;
	}

}