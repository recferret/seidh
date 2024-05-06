package game.entity.projectile.animation;

import h2d.Anim;
import h2d.Tile;

class ProjectileAnimation {
    private var commonAnim:Array<Tile>;
    private var hitAnim:Array<Tile>;

    private var animation:Anim;

    public function new(parent:h2d.Object) {
        animation = new h2d.Anim(parent);
    }

    public function playCommon() {
        animation.loop = true;
        animation.play(commonAnim);
    }

    public function playHit() {
        animation.loop = false;
        animation.play(hitAnim);
    }

    public function loadCommon(common:Array<Tile>) {
        commonAnim = common;
    }

    public function loadHit(hit:Array<Tile>) {
        hitAnim = hit;
    }
                    
}

class ProjectileAnimations {

    public static function LoadMagicArrowAnimation(parent:h2d.Object) {
        final animation = new ProjectileAnimation(parent);

        animation.loadCommon(
            [
                // hxd.Res.mage.arrow._2.toTile(),
                // hxd.Res.mage.arrow._3.toTile(),
                // hxd.Res.mage.arrow._4.toTile(),
                // hxd.Res.mage.arrow._5.toTile(),
                // hxd.Res.mage.arrow._6.toTile(),
                hxd.Res.samurai.arrow.toTile(),
            ]
        );
        animation.loadHit(
            [
                hxd.Res.samurai.arrow.toTile(),
            ]
        );

        return animation;
    }

    public static function LoadMagicSphereAnimation(parent:h2d.Object) {
        final animation = new ProjectileAnimation(parent);

        animation.loadCommon(
            [
                hxd.Res.mage.sphere._1.toTile(),
                hxd.Res.mage.sphere._2.toTile(),
                hxd.Res.mage.sphere._3.toTile(),
                hxd.Res.mage.sphere._4.toTile(),
                hxd.Res.mage.sphere._5.toTile(),
            ]
        );
        animation.loadHit(
            [
                hxd.Res.mage.sphere._6.toTile(),
                hxd.Res.mage.sphere._7.toTile(),
                hxd.Res.mage.sphere._8.toTile(),
                hxd.Res.mage.sphere._9.toTile(),
            ]
        );

        return animation;
    }

}