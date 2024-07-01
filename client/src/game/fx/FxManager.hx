package game.fx;

import h2d.Anim;

import engine.base.BaseTypesAndClasses;

// TODO rmk and use objects pool
class FrameAnimationFx {
    private var animation:Anim;

    public function new(s2d:h2d.Scene, x:Float, y:Float, tiles:Array<h2d.Tile>) {
        animation = new h2d.Anim(s2d);
        animation.setPosition(x, y);
        animation.onAnimEnd = function callback() {
            s2d.removeChild(animation);
        };
        animation.play(tiles);
        animation.loop = false;
        s2d.addChild(animation);
    }
        
}

class FxManager {

    private var initiated = false;

    private var s2d:h2d.Scene;

    private var ragnarAttackTilesRight:Array<h2d.Tile>;
    private var ragnarAttackTilesLeft:Array<h2d.Tile>;

    private var zombieAttackTilesRight:Array<h2d.Tile>;
    private var zombieAttackTilesLeft:Array<h2d.Tile>;

    private var bloodTilesRight:Array<h2d.Tile>;
    private var bloodTilesLeft:Array<h2d.Tile>;

    public static final instance:FxManager = new FxManager();

    private function new() {
    }

    public function initiate() {
        if (!initiated) {
            ragnarAttackTilesRight = [
                hxd.Res.fx.ragnar.attack_1.toTile().center(),
                hxd.Res.fx.ragnar.attack_2.toTile().center(),
                hxd.Res.fx.ragnar.attack_3.toTile().center(),
            ];
            ragnarAttackTilesLeft = [
                hxd.Res.fx.ragnar.attack_1.toTile().center(),
                hxd.Res.fx.ragnar.attack_2.toTile().center(),
                hxd.Res.fx.ragnar.attack_3.toTile().center(),
            ];
            ragnarAttackTilesLeft[0].flipX();
            ragnarAttackTilesLeft[1].flipX();
            ragnarAttackTilesLeft[2].flipX();
    
            zombieAttackTilesRight = [
                hxd.Res.fx.zombie.attack_1.toTile().center(),
                hxd.Res.fx.zombie.attack_2.toTile().center(),
                hxd.Res.fx.zombie.attack_3.toTile().center(),
            ];
            zombieAttackTilesLeft = [
                hxd.Res.fx.zombie.attack_1.toTile().center(),
                hxd.Res.fx.zombie.attack_2.toTile().center(),
                hxd.Res.fx.zombie.attack_3.toTile().center(),
            ];
            zombieAttackTilesLeft[0].flipX();
            zombieAttackTilesLeft[1].flipX();
            zombieAttackTilesLeft[2].flipX();
    
            bloodTilesRight = [
                hxd.Res.fx.blood.blood_1.toTile().center(),
                hxd.Res.fx.blood.blood_2.toTile().center(),
                hxd.Res.fx.blood.blood_3.toTile().center(),
            ];
            bloodTilesLeft = [
                hxd.Res.fx.blood.blood_1.toTile().center(),
                hxd.Res.fx.blood.blood_2.toTile().center(),
                hxd.Res.fx.blood.blood_3.toTile().center(),
            ];
            bloodTilesLeft[0].flipX();
            bloodTilesLeft[1].flipX();
            bloodTilesLeft[2].flipX();
        }
    }

    public function setScene(s2d:h2d.Scene) {
        this.s2d = s2d;
    }

    public function ragnarAttack(x:Float, y:Float, side:Side) {
        new FrameAnimationFx(s2d, x, y, side == Side.RIGHT ? ragnarAttackTilesRight : ragnarAttackTilesLeft);
    }

    public function zombieAttack(x:Float, y:Float, side:Side) {
        new FrameAnimationFx(s2d, x, y, side == Side.RIGHT ? zombieAttackTilesRight : zombieAttackTilesLeft);
    }

    public function blood(x:Float, y:Float, side:Side) {
        new FrameAnimationFx(s2d, x, y, side == Side.RIGHT ? bloodTilesRight : bloodTilesLeft);
    }

}