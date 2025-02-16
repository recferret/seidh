package game.entity.projectile;

import game.tilemap.TilemapManager;
import game.scene.impl.game.GameScene;
import engine.base.entity.impl.EngineProjectileEntity;

class ClientProjectileEntity extends BasicClientEntity<EngineProjectileEntity> {

    public function new(s2d:h2d.Scene, engineEntity:EngineProjectileEntity) {
        super();

        s2d.add(this, GameScene.LAYER_CHARACTERS_AND_BOOSTS);

        this.engineEntity = engineEntity;
		setPosition(engineEntity.getX(), engineEntity.getY());

        final bmp = new h2d.Bitmap(TilemapManager.instance.getTile(TileType.PROJECTILE_AXE));

        addChild(bmp);
    }

    // ------------------------------------------------
    // Abstraction
    // ------------------------------------------------

    public function update(dt:Float, fps:Float) {
        final step = this.engineEntity.getFrameStep(dt);
        x += step.dx;
        y += step.dy;

        rotation = rotation + 10 * dt;
    }

	public function debugDraw(graphics:h2d.Graphics) {
    }

}