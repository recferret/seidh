package game.fx;

import engine.base.MathUtils;
import h2d.Anim;

import engine.base.BaseTypesAndClasses;

import game.Res.SeidhResource;

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

    private var zombieBloodTiles:Array<h2d.Tile>;

    public static final instance:FxManager = new FxManager();

    private function new() {
    }

    public function initiate() {
        if (!initiated) {
            ragnarAttackTilesRight = [
                Res.instance.getTileResource(SeidhResource.FX_RAGNAR_ATTACK_1),
                Res.instance.getTileResource(SeidhResource.FX_RAGNAR_ATTACK_2),
                Res.instance.getTileResource(SeidhResource.FX_RAGNAR_ATTACK_3),
            ];
            ragnarAttackTilesLeft = [
                Res.instance.getTileResource(SeidhResource.FX_RAGNAR_ATTACK_1),
                Res.instance.getTileResource(SeidhResource.FX_RAGNAR_ATTACK_2),
                Res.instance.getTileResource(SeidhResource.FX_RAGNAR_ATTACK_3),
            ];
            ragnarAttackTilesLeft[0].flipX();
            ragnarAttackTilesLeft[1].flipX();
            ragnarAttackTilesLeft[2].flipX();
    
            zombieAttackTilesRight = [
                Res.instance.getTileResource(SeidhResource.FX_ZOMBIE_ATTACK_1),
                Res.instance.getTileResource(SeidhResource.FX_ZOMBIE_ATTACK_2),
                Res.instance.getTileResource(SeidhResource.FX_ZOMBIE_ATTACK_3),
            ];
            zombieAttackTilesLeft = [
                Res.instance.getTileResource(SeidhResource.FX_ZOMBIE_ATTACK_1),
                Res.instance.getTileResource(SeidhResource.FX_ZOMBIE_ATTACK_2),
                Res.instance.getTileResource(SeidhResource.FX_ZOMBIE_ATTACK_3),
            ];
            zombieAttackTilesLeft[0].flipX();
            zombieAttackTilesLeft[1].flipX();
            zombieAttackTilesLeft[2].flipX();
    
            bloodTilesRight = [
                Res.instance.getTileResource(SeidhResource.FX_BLOOD_1),
                Res.instance.getTileResource(SeidhResource.FX_BLOOD_2),
                Res.instance.getTileResource(SeidhResource.FX_BLOOD_3),
            ];
            bloodTilesLeft = [
                Res.instance.getTileResource(SeidhResource.FX_BLOOD_1),
                Res.instance.getTileResource(SeidhResource.FX_BLOOD_2),
                Res.instance.getTileResource(SeidhResource.FX_BLOOD_3),
            ];
            bloodTilesLeft[0].flipX();
            bloodTilesLeft[1].flipX();
            bloodTilesLeft[2].flipX();

            zombieBloodTiles = [
                Res.instance.getTileResource(SeidhResource.FX_ZOMBIE_BLOOD_1).center(),
                Res.instance.getTileResource(SeidhResource.FX_ZOMBIE_BLOOD_2).center(),
            ];
        }
    }

    public function setScene(s2d:h2d.Scene) {
        this.s2d = s2d;
    }

    public function ragnarAttack(x:Float, y:Float, side:Side) {
        // new FrameAnimationFx(s2d, x, y, side == Side.RIGHT ? ragnarAttackTilesRight : ragnarAttackTilesLeft);
    }

    public function zombieAttack(x:Float, y:Float, side:Side) {
        // new FrameAnimationFx(s2d, x, y, side == Side.RIGHT ? zombieAttackTilesRight : zombieAttackTilesLeft);
    }

    public function zombieBlood(x:Float, y:Float, side:Side, entityType:EntityType) {
        final tile = entityType == EntityType.ZOMBIE_BOY ? zombieBloodTiles[1] : zombieBloodTiles[0];
        if (side == Side.LEFT) {
            tile.flipX();
        }

        final bmp = new h2d.Bitmap(tile, s2d);
        bmp.setPosition(x, y);
    }

    public function blood(x:Float, y:Float, side:Side) {
        new FrameAnimationFx(s2d, x, y, side == Side.RIGHT ? bloodTilesRight : bloodTilesLeft);
    }

}