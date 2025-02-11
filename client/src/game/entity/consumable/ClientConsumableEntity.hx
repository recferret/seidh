package game.entity.consumable;

import motion.Actuate;
import motion.actuators.GenericActuator;
import motion.easing.Quad;

import engine.base.entity.impl.EngineConsumableEntity;

import game.scene.impl.game.GameScene;
import game.tilemap.TilemapManager;
import game.utils.Utils;

class ClientConsumableEntity extends BasicClientEntity<EngineConsumableEntity> {

    private var bmp:h2d.Bitmap;
    private var currentTween:GenericActuator<ClientConsumableEntity>;
    private final startY:Float;

    public function new(s2d:h2d.Scene, engineEntity:EngineConsumableEntity) {
        super();

        s2d.add(this);

        startY = engineEntity.getY();
        this.engineEntity = engineEntity;

		setPosition(engineEntity.getX(), startY);

        switch (engineEntity.getEntityType()) {
            case COIN:
                bmp = new h2d.Bitmap(TilemapManager.instance.getTile(TileType.COIN), this);
                bmp.setScale(2);
            case HEALTH_POTION:
                bmp = new h2d.Bitmap(TilemapManager.instance.getTile(TileType.POTION_RED), this);
            case SALMON:
                bmp = new h2d.Bitmap(TilemapManager.instance.getTile(TileType.SALMON), this);
            default:
        }

        startTween();
    }

    public function getEntityType() {
        return engineEntity.getEntityType();
    }

    public function getConsumableAmount() {
        return engineEntity.amount;
    }

    public function clearTween() {
        Actuate.stop(currentTween);
        currentTween = null;
    }

    private function startTween() {
        currentTween = Actuate.tween(this, 0.3, { 
            y: engineEntity.getY() + 30
        })
        .ease(Quad.easeInOut)
        .onComplete(function callback() {
            currentTween = Actuate.tween(this, 0.3, { 
                y: engineEntity.getY(),
            })
            .ease(Quad.easeInOut)
            .onComplete(function callback() {
                startTween();
            });
        });
    }

    // ------------------------------------------------------------
    // Abstraction
    // ------------------------------------------------------------

    public function update(dt:Float, fps:Float) {
    }

    public function debugDraw(graphics:h2d.Graphics) {
        Utils.DrawRect(graphics, engineEntity.getBodyRectangle(), GameClientConfig.GreenColor);
    }

}