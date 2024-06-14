package engine.base.entity.impl;

import uuid.Uuid;
import engine.base.BaseTypesAndClasses;
import engine.base.entity.base.EngineBaseEntity;

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

}