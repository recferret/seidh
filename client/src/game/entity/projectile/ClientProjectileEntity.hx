package game.entity.projectile;

import game.entity.projectile.animation.ProjectileAnimations;
import engine.base.BaseTypesAndClasses;
import engine.base.entity.impl.EngineProjectileEntity;

class ClientProjectileEntity extends h2d.Object {

    public var animation:ProjectileAnimation;
    var engineEntity:EngineProjectileEntity;

    public function new(s2d:h2d.Scene) {
        super(s2d);
    }

    public function initiateEngineEntity(engineEntity:EngineProjectileEntity) {
		this.engineEntity = engineEntity;
		setPosition(engineEntity.getX(), engineEntity.getY());

        switch (engineEntity.getEntityType()) {
            case EntityType.PROJECTILE_MAGIC_ARROW:
                trace('ClientProjectileEntity 1');
                animation = ProjectileAnimations.LoadMagicArrowAnimation(this);
            case EntityType.PROJECTILE_MAGIC_SPHERE:
                trace('ClientProjectileEntity 2');
                animation = ProjectileAnimations.LoadMagicSphereAnimation(this);
            default:
        }

        animation.playCommon();
	}

}