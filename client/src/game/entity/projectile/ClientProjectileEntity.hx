package game.entity.projectile;

import game.utils.Utils;
import game.entity.projectile.animation.ProjectileAnimations;
import engine.base.BaseTypesAndClasses;
import engine.base.entity.impl.EngineProjectileEntity;

class ClientProjectileEntity extends h2d.Object {

    public var animation:ProjectileAnimation;
    var projectileEntity:EngineProjectileEntity;

    public function new(s2d:h2d.Scene) {
        super(s2d);
    }

    public function update(dt:Float) {
        // Simulate projectile movement on the client side
        final step = projectileEntity.calculateAndGetFrameMoveStep(dt);

        if (step.allowMovement) {
            x += step.dx;
            y += step.dy;
        }
    }


	public function debugDraw(graphics:h2d.Graphics) {
        // final debugActionShape =
        //  getDebugActionShape();
        // if (debugActionShape != null) {
        //     Utils.DrawRect(graphics, debugActionShape.toRect(x, y, engineEntity.currentDirectionSide), GameConfig.GreenColor);
        // }

        Utils.DrawRect(graphics, projectileEntity.getBodyRectangle(), GameConfig.GreenColor);
    }

    public function initiateEngineEntity(projectileEntity:EngineProjectileEntity) {
		this.projectileEntity = projectileEntity;
		setPosition(projectileEntity.getX(), projectileEntity.getY());

        trace('PROJECTILE POSITION:');
        trace(projectileEntity.getX(), projectileEntity.getY());

        switch (projectileEntity.getEntityType()) {
            case EntityType.PROJECTILE_MAGIC_ARROW:
                animation = ProjectileAnimations.LoadMagicArrowAnimation(this);
            case EntityType.PROJECTILE_MAGIC_SPHERE:
                animation = ProjectileAnimations.LoadMagicSphereAnimation(this);
            default:
        }

        animation.playCommon();
	}

}