package engine.base.entity.impl;

import uuid.Uuid;

import engine.base.entity.base.EngineBaseEntity;
import engine.base.types.TypesBaseEntity;

class EngineCoinEntity extends EngineBaseEntity {

	public var amount:Int;

	public function new(baseEntity:BaseEntity, amount:Int) {
		super(baseEntity);

		if (baseEntity.id == null) {
			baseEntity.id = Uuid.short();
		}

		this.amount = amount;
	}

	public function update(dt:Float) {
	}

	public function getEntityBaseStruct() {
		return baseEntity.getBaseStruct();
	}

}