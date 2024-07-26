package game.entity.consumable;

import engine.base.entity.impl.EngineConsumableEntity;

import game.scene.impl.GameScene;
import game.utils.Utils;
import game.Res.SeidhResource;

class ClientConsumableEntity extends BasicClientEntity<EngineConsumableEntity> {

    private var bmp:h2d.Bitmap;

    public function new(s2d:h2d.Scene, engineEntity:EngineConsumableEntity) {
        super();

        s2d.add(this, 1, GameScene.ITEM_LAYER);

        this.engineEntity = engineEntity;
		setPosition(engineEntity.getX(), engineEntity.getY());

        switch (engineEntity.getEntityType()) {
            case COIN:
                bmp = new h2d.Bitmap(Res.instance.getTileResource(SeidhResource.CONSUMABLE_COIN), this);
                bmp.setScale(2);
            case HEALTH_POTION:
                bmp = new h2d.Bitmap(Res.instance.getTileResource(SeidhResource.CONSUMABLE_HEALTH_POTION), this);
            case LOSOS:
                bmp = new h2d.Bitmap(Res.instance.getTileResource(SeidhResource.CONSUMABLE_LOSOS), this);
            default:
        }
    }

    public function getEntityType() {
        return engineEntity.getEntityType();
    }

    // ------------------------------------------------------------
    // Abstraction
    // ------------------------------------------------------------

    public function update(dt:Float, fps:Float) {
    }

    public function debugDraw(graphics:h2d.Graphics) {
        Utils.DrawRect(graphics, engineEntity.getBodyRectangle(), GameConfig.GreenColor);
    }

}