package game.effects;

class ProjectileSphere extends h2d.Object {

    public function new(s2d:h2d.Scene) {
        super(s2d);

        // final sphereTiles = [
        //     hxd.Res.mage.sphere._1.toTile(),
        //     hxd.Res.mage.sphere._2.toTile(),
        //     hxd.Res.mage.sphere._3.toTile(),
        //     hxd.Res.mage.sphere._4.toTile(),
        //     hxd.Res.mage.sphere._5.toTile(),
        // ];

        // final hitTiles = [
        //     hxd.Res.mage.sphere._6.toTile(),
        //     hxd.Res.mage.sphere._7.toTile(),
        //     hxd.Res.mage.sphere._8.toTile(),
        //     hxd.Res.mage.sphere._9.toTile(),
        // ];

        // final animation = new h2d.Anim(this);
        // animation.play(sphereTiles);
        // animation.loop = true;

        new h2d.Bitmap(hxd.Res.samurai.arrow.toTile().center(), this);
    }

}