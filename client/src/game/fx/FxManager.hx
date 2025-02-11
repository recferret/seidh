package game.fx;

import engine.base.types.TypesBaseEntity;

class FxManager {

    private var s2d:h2d.Scene;

    public final fxPool:FxPool;

    public function new(s2d:h2d.Scene) {
        fxPool = new FxPool(s2d);
    }

    public function dispose() {
        fxPool.dispose();
        this.s2d = null;
    }

    public function damageText(x:Float, y:Float, targetScale:Float, side:Side, amount:Int) {
        fxPool.addFloaingTweenText(x, y, side, targetScale, GameClientConfig.RedColor, '-' + Std.string(amount));
    }

    public function healText(x:Float, y:Float, targetScale:Float, side:Side, amount:Int) {
        fxPool.addFloaingTweenText(x, y, side, targetScale, GameClientConfig.GreenColor, '+' + Std.string(amount));
    }

    public function coinText(x:Float, y:Float, targetScale:Float, side:Side, amount:Int) {
        fxPool.addFloaingTweenText(x, y, side, targetScale, GameClientConfig.DefaultFontColor, '+' + Std.string(amount));
    }

    public function ragnarAttack(x:Float, y:Float, side:Side) {
        fxPool.addRagnarGroundAttack(x, y, side);
    }

    public function glamrEyeAttack(x:Float, y:Float, side:Side) {
        fxPool.addGlamrEyeAttack(x, y, side);
    }

    public function remains(x:Float, y:Float, entityType:EntityType, side:Side) {
        fxPool.addRemains(x, y, entityType, side);
    }

}