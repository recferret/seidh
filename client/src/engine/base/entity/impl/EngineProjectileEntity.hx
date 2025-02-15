package engine.base.entity.impl;

import uuid.Uuid;

import engine.base.entity.base.EngineBaseEntity;
import engine.base.types.TypesBaseEntity;

class EngineProjectileEntity extends EngineBaseEntity {

    // ------------------------------------------------
	// General
	// ------------------------------------------------

    public var allowMovement = true;
    private var traveledDistance = 0.0;
	private var projectileEntity:ProjectileEntity;

    public function new(projectileEntity:ProjectileEntity) {
		super(projectileEntity);

        this.projectileEntity = projectileEntity;

		if (baseEntity.id == null) {
			baseEntity.id = Uuid.short();
		}
		if (baseEntity.ownerId == null) {
			baseEntity.ownerId = Uuid.short();
		}
    }

    public function update(dt:Float) {
		if (allowMovement) {
			final step = calculateAndGetFrameMoveStep(dt);
			moveBy(step.dx, step.dy);
		}
	}

	public function calculateAndGetFrameMoveStep(dt:Float) {
		final dx = projectileEntity.projectile.speed * Math.cos(baseEntity.rotation) * dt;
		final dy = projectileEntity.projectile.speed * Math.sin(baseEntity.rotation) * dt;
		traveledDistance += (dx + dy);

		if (traveledDistance > projectileEntity.projectile.travelDistance) {
			allowMovement = false;
		}

		return {
			dx: dx,
			dy: dy,
			allowMovement: allowMovement
		}
	}

}