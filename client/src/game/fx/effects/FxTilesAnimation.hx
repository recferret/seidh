package game.fx.effects;

import h2d.Anim;

import engine.base.types.TypesBaseEntity.Side;

class FxTilesAnimation extends Anim {

    final tiles:Array<h2d.Tile>;

    public function new(tiles:Array<h2d.Tile>, scale:Float) {
        super();

        this.tiles = tiles; 

        setScale(scale);
        onAnimEnd = function callback() {
            alpha = 0;
        };
        loop = false;
    }

    public function playAnimation() {
        play(tiles);
    }

    public function setSide(side:Side) {
        if (side == LEFT) {
            for (frame in frames) {
                frame.flipX();
            }
        }
    }
        
}