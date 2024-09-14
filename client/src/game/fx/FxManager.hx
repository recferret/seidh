package game.fx;

import h2d.Anim;

import engine.base.BaseTypesAndClasses;

import game.Res.SeidhResource;

// TODO rmk and use objects pool
class FrameAnimationFx {
    private var animation:Anim;

    public function new(s2d:h2d.Scene, x:Float, y:Float, tiles:Array<h2d.Tile>, side:Side) {
        if (side == LEFT) {
            for (tile in tiles) {
                tile.flipX();
            }
        }

        animation = new h2d.Anim(s2d);
        animation.setScale(1.5);
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

    private var impactTiles:Array<h2d.Tile>;
    private var zombieBloodTiles:Array<h2d.Tile>;

    public static final instance:FxManager = new FxManager();

    private function new() {
    }

    public function initiate() {
        if (!initiated) {
            final th = 332;
            final tw = 332;

            final impactTile = Res.instance.getTileResource(SeidhResource.FX_IMPACT);

            impactTiles = [
                for(x in 0 ... Std.int(impactTile.width / tw))
                    impactTile.sub(x * tw, 0, tw, th).center()
            ];

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
        new FrameAnimationFx(s2d, x, y, impactTiles, side);
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
        // new FrameAnimationFx(s2d, x, y, side == Side.RIGHT ? bloodTilesRight : bloodTilesLeft);
    }

}