package game.entity.coin;

import game.utils.Utils;
import engine.base.entity.impl.EngineCoinEntity;

class ClientCoinEntity extends BasicClientEntity<EngineCoinEntity> {

    private var coinBmp:h2d.Bitmap;

    public function new(s2d:h2d.Scene) {
        super(s2d);
    }

    // ------------------------------------------------------------
    // Abstraction
    // ------------------------------------------------------------

    public function update(dt:Float) {
    }

    public function debugDraw(graphics:h2d.Graphics) {
        Utils.DrawRect(graphics, engineEntity.getBodyRectangle(), GameConfig.GreenColor);
    }

    public function initiateEngineEntity(engineEntity:EngineCoinEntity) {
		this.engineEntity = engineEntity;
		setPosition(engineEntity.getX(), engineEntity.getY());

        coinBmp = new h2d.Bitmap(hxd.Res.icons.icon_gold.toTile().center(), this);
        coinBmp.setScale(0.8);
	}

}