package game.entity.projectile;

import game.utils.Utils;
import engine.base.entity.impl.EngineProjectileEntity;

import game.Res.SeidhResource;
import game.scene.impl.game.GameScene;

class ClientProjectileEntity extends BasicClientEntity<EngineProjectileEntity> {

    private final animation:h2d.Anim;
    private final bloodyAxeTilesMovement:Array<h2d.Tile>;
    private final bloodyAxeTilesDisappear:Array<h2d.Tile>;

    public function new(s2d:h2d.Scene, engineEntity:EngineProjectileEntity) {
        super();

        s2d.add(this, GameScene.LAYER_CHARACTERS_AND_BOOSTS);

        this.engineEntity = engineEntity;
		setPosition(engineEntity.getX(), engineEntity.getY());

        // final bmp = new h2d.Bitmap(TilemapManager.instance.getTile(TileType.PROJECTILE_AXE));
        // addChild(bmp);

        animation = new h2d.Anim(this);

        final bloodyAxeTileMovement = Res.instance.getTileResource(SeidhResource.FX_BLOODY_AXE_MOVEMENT);
        bloodyAxeTilesMovement = [];
        for(x in 0 ... Std.int(bloodyAxeTileMovement.width / 332)) {
            final tile = bloodyAxeTileMovement.sub(x * 332, 0, 332, 332).center();
            bloodyAxeTilesMovement.push(tile);
        }

        final bloodyAxeTileDisappear = Res.instance.getTileResource(SeidhResource.FX_BLOODY_AXE_DISAPPEAR);
        bloodyAxeTilesDisappear = [];
        for(x in 0 ... Std.int(bloodyAxeTileDisappear.width / 332)) {
            final tile = bloodyAxeTileDisappear.sub(x * 332, 0, 332, 332).center();
            bloodyAxeTilesDisappear.push(tile);
        }

        animation.play(bloodyAxeTilesMovement);
        animation.onAnimEnd = function callback() {
            if (this.engineEntity.state == 'START_DISAPPEARING') {
                this.engineEntity.state = 'DISAPPEARING';
    
                animation.play(bloodyAxeTilesDisappear);
                animation.onAnimEnd = function callback() {
                    this.engineEntity.state = 'DISAPPEARED';
                };
                animation.loop = false;
            } else if (this.engineEntity.state == 'MOVEMENT') {
                animation.play(bloodyAxeTilesMovement);
            }
        };
        animation.loop = false;
    }

    // ------------------------------------------------
    // Abstraction
    // ------------------------------------------------

    public function update(dt:Float, fps:Float) {
        final step = this.engineEntity.getFrameStep(dt);
        x += step.dx;
        y += step.dy;

        // rotation = rotation + 10 * dt;
    }

	public function debugDraw(graphics:h2d.Graphics) {
        Utils.DrawRect(graphics, engineEntity.getBodyRectangle(), GameClientConfig.GreenColor);
    }

}