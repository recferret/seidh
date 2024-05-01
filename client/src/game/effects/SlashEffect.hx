package game.effects;

import h2d.Anim;
import h2d.Tile;

enum SlashEffectType {
	One;
    Two;
	Three;
    Four;
    Five;
    Six;
    Seven;
    Eight;
    Nine;
    Ten;
}

class SlashEffect extends h2d.Object {

    private var animation:Anim;

    private var slash1:Array<Tile>;
    private var slash2:Array<Tile>;
	private var slash3:Array<Tile>;
    private var slash4:Array<Tile>;
    private var slash5:Array<Tile>;
    private var slash6:Array<Tile>;
    private var slash7:Array<Tile>;
    private var slash8:Array<Tile>;
    private var slash9:Array<Tile>;
    private var slash10:Array<Tile>;

    public function new(s2d:h2d.Scene, slashEffectType:SlashEffectType) {
        super(s2d);

        slash1 = [
            hxd.Res.slash._1._1.toTile(),
            hxd.Res.slash._1._2.toTile(),
            hxd.Res.slash._1._3.toTile(),
            hxd.Res.slash._1._4.toTile(),
            hxd.Res.slash._1._5.toTile(),
            hxd.Res.slash._1._6.toTile(),
            hxd.Res.slash._1._7.toTile(),
            hxd.Res.slash._1._8.toTile(),
            hxd.Res.slash._1._9.toTile(),
            hxd.Res.slash._1._10.toTile(),
        ];

        slash2 = [
            hxd.Res.slash._2._1.toTile(),
            hxd.Res.slash._2._2.toTile(),
            hxd.Res.slash._2._3.toTile(),
            hxd.Res.slash._2._4.toTile(),
            hxd.Res.slash._2._5.toTile(),
        ];

        slash3 = [
            hxd.Res.slash._3._1.toTile(),
            hxd.Res.slash._3._2.toTile(),
            hxd.Res.slash._3._3.toTile(),
            hxd.Res.slash._3._4.toTile(),
            hxd.Res.slash._3._5.toTile(),
            hxd.Res.slash._3._6.toTile(),
            hxd.Res.slash._3._7.toTile(),
            hxd.Res.slash._3._8.toTile(),
            hxd.Res.slash._3._9.toTile(),
            hxd.Res.slash._3._10.toTile(),
        ];

        slash4 = [
            hxd.Res.slash._4._1.toTile(),
            hxd.Res.slash._4._2.toTile(),
            hxd.Res.slash._4._3.toTile(),
            hxd.Res.slash._4._4.toTile(),
            hxd.Res.slash._4._5.toTile(),
            hxd.Res.slash._4._6.toTile(),
            hxd.Res.slash._4._7.toTile(),
            hxd.Res.slash._4._8.toTile(),
        ];

        slash5 = [
            hxd.Res.slash._5._1.toTile(),
            hxd.Res.slash._5._2.toTile(),
            hxd.Res.slash._5._3.toTile(),
            hxd.Res.slash._5._4.toTile(),
            hxd.Res.slash._5._5.toTile(),
            hxd.Res.slash._5._6.toTile(),
            hxd.Res.slash._5._7.toTile(),
            hxd.Res.slash._5._8.toTile(),
        ];

        slash6 = [
            hxd.Res.slash._6._1.toTile(),
            hxd.Res.slash._6._2.toTile(),
            hxd.Res.slash._6._3.toTile(),
            hxd.Res.slash._6._4.toTile(),
            hxd.Res.slash._6._5.toTile(),
            hxd.Res.slash._6._6.toTile(),
            hxd.Res.slash._6._7.toTile(),
            hxd.Res.slash._6._8.toTile(),
            hxd.Res.slash._6._9.toTile(),
            hxd.Res.slash._6._10.toTile(),
        ];

        slash7 = [
            hxd.Res.slash._7._1.toTile(),
            hxd.Res.slash._7._2.toTile(),
            hxd.Res.slash._7._3.toTile(),
            hxd.Res.slash._7._4.toTile(),
            hxd.Res.slash._7._5.toTile(),
            hxd.Res.slash._7._6.toTile(),
            hxd.Res.slash._7._7.toTile(),
            hxd.Res.slash._7._8.toTile(),
            hxd.Res.slash._7._9.toTile(),
            hxd.Res.slash._7._10.toTile(),
        ];

        slash8 = [
            hxd.Res.slash._8._1.toTile(),
            hxd.Res.slash._8._2.toTile(),
            hxd.Res.slash._8._3.toTile(),
            hxd.Res.slash._8._4.toTile(),
            hxd.Res.slash._8._5.toTile(),
            hxd.Res.slash._8._6.toTile(),
            hxd.Res.slash._8._7.toTile(),
            hxd.Res.slash._8._8.toTile(),
            hxd.Res.slash._8._9.toTile(),
            hxd.Res.slash._8._10.toTile(),
        ];

        slash9 = [
            hxd.Res.slash._9._1.toTile(),
            hxd.Res.slash._9._2.toTile(),
            hxd.Res.slash._9._3.toTile(),
            hxd.Res.slash._9._4.toTile(),
            hxd.Res.slash._9._5.toTile(),
            hxd.Res.slash._9._6.toTile(),
            hxd.Res.slash._9._7.toTile(),
            hxd.Res.slash._9._8.toTile(),
        ];

        slash10 = [
            hxd.Res.slash._10._1.toTile(),
            hxd.Res.slash._10._2.toTile(),
            hxd.Res.slash._10._3.toTile(),
            hxd.Res.slash._10._4.toTile(),
            hxd.Res.slash._10._5.toTile(),
            hxd.Res.slash._10._6.toTile(),
            hxd.Res.slash._10._7.toTile(),
            hxd.Res.slash._10._8.toTile(),
        ];

        animation = new h2d.Anim(this);

        setScale(0.2);

        switch (slashEffectType) {
            case One:
                animation.play(slash1);
            case Two:
                animation.play(slash2);
            case Three:
                animation.play(slash3);
            case Four:
                animation.play(slash4);
            case Five:
                animation.play(slash5);
            case Six:
                animation.play(slash6);
            case Seven:
                animation.play(slash7);
            case Eight:
                animation.play(slash8);
            case Nine:
                animation.play(slash9);
            case Ten:
                animation.play(slash10);
        }
    }

}