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

    private final s2d:h2d.Scene;

    private final ragnarAttackTilesRight:Array<h2d.Tile>;
    private final ragnarAttackTilesLeft:Array<h2d.Tile>;

    private final zombieAttackTilesRight:Array<h2d.Tile>;
    private final zombieAttackTilesLeft:Array<h2d.Tile>;

    private final bloodTilesRight:Array<h2d.Tile>;
    private final bloodTilesLeft:Array<h2d.Tile>;

    public function new(s2d:h2d.Scene) {
        this.s2d = s2d;

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