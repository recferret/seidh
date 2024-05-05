package game.entity.projectile.animation;

class ProjectileAnimation {
    private var commonAnim:Array<Tile>;
    private var hitAnim:Array<Tile>;

    private var animation:Anim;

    public function new(parent:h2d.Object) {
        animation = new h2d.Anim(parent);

        animation.loop = true;
        animation.play(commonAnim);
    }

    public function hit() {
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
                hxd.Res.mage.arrow._2.toTile(),
                hxd.Res.mage.arrow._3.toTile(),
                hxd.Res.mage.arrow._4.toTile(),
                hxd.Res.mage.arrow._5.toTile(),
                hxd.Res.mage.arrow._6.toTile(),
            ]
        );
        animation.loadHit(
            [
                hxd.Res.mage.arrow._1.toTile(),
            ]
        );
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
    }

}