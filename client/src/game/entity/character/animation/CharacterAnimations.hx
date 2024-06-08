package game.entity.character.animation;

import h2d.Anim;
import h2d.Tile;
import engine.base.BaseTypesAndClasses.CharacterAnimationState;
import engine.base.BaseTypesAndClasses.Side;

class CharacterAnimation {
    private var idleAnimRight:Array<Tile>;
    private var runAnimRight:Array<Tile>;
	private var walkAnimRight:Array<Tile>;
    private var deadAnimRight:Array<Tile>;
    private var hurtAnimRight:Array<Tile>;
    private var attack1AnimRight:Array<Tile>;
    private var attack2AnimRight:Array<Tile>;
    private var attack3AnimRight:Array<Tile>;
    private var attackRunAnimRight:Array<Tile>;
    private var shot1AnimRight:Array<Tile>;
    private var shot2AnimRight:Array<Tile>;
    private var defendAnimRight:Array<Tile>;
    private var dodgeAnimRight:Array<Tile>;

    private var idleAnimLeft:Array<Tile>;
    private var runAnimLeft:Array<Tile>;
	private var walkAnimLeft:Array<Tile>;
    private var deadAnimLeft:Array<Tile>;
    private var hurtAnimLeft:Array<Tile>;
    private var attack1AnimLeft:Array<Tile>;
    private var attack2AnimLeft:Array<Tile>;
    private var attack3AnimLeft:Array<Tile>;
    private var attackRunAnimLeft:Array<Tile>;
    private var shot1AnimLeft:Array<Tile>;
    private var shot2AnimLeft:Array<Tile>;
    private var defendAnimLeft:Array<Tile>;
    private var dodgeAnimLeft:Array<Tile>;
    
    private var animation:Anim;
    private var characterAnimationState:CharacterAnimationState;
    private var side = Side.RIGHT;
    private var sideChanged = false;

    public var enableMoveAnimation = true;

    public function new(parent:h2d.Object) {
        animation = new h2d.Anim(parent);

        animation.onAnimEnd = function callback() {
            if (characterAnimationState != DEAD) {
                if (characterAnimationState != RUN && characterAnimationState != WALK) {
                    enableMoveAnimation = true;
                    setAnimationState(CharacterAnimationState.IDLE);
                }
            }
        }
    }

    public function hideAnimations() {
        animation.pause = true;
    }

    public function setSide(side:Side) {
        if (this.side != side) {
            this.side = side;
            sideChanged = true;
        }
    }

    public function setAnimationState(newState:CharacterAnimationState) {
        if (newState != characterAnimationState || sideChanged) {
            sideChanged = false;
            characterAnimationState = newState;
            hideAnimations();

            switch (newState) {
                case IDLE:
                    enableMoveAnimation = true;
                    animation.loop = true;
                    animation.play(side == Side.RIGHT ? idleAnimRight : idleAnimLeft);
                case RUN:
                    enableMoveAnimation = true;
                    animation.loop = true;
                    animation.play(side == Side.RIGHT ? runAnimRight : runAnimLeft);
                case WALK:
                    enableMoveAnimation = true;
                    animation.loop = true;
                    animation.play(side == Side.RIGHT ? walkAnimRight : walkAnimLeft);
                case DEAD:
                    enableMoveAnimation = false;
                    animation.loop = false;
                    animation.play(side == Side.RIGHT ? deadAnimRight : deadAnimLeft);
                case HURT:
                    animation.loop = false;
                    animation.play(side == Side.RIGHT ? hurtAnimRight : hurtAnimLeft);
                case ATTACK_1:
                    enableMoveAnimation = false;
                    animation.loop = false;
                    animation.play(side == Side.RIGHT ? attack1AnimRight : attack1AnimLeft);
                case ATTACK_2:
                    enableMoveAnimation = false;
                    animation.loop = false;
                    animation.play(side == Side.RIGHT ? attack2AnimRight : attack2AnimLeft);
                case ATTACK_3:
                    enableMoveAnimation = false;
                    animation.loop = false;
                    animation.play(side == Side.RIGHT ? attack3AnimRight : attack3AnimLeft);
                case ATTACK_RUN:
                    enableMoveAnimation = false;
                    animation.loop = false;    
                    animation.play(side == Side.RIGHT ? attackRunAnimRight : attackRunAnimLeft);
                case SHOT_1:
                    enableMoveAnimation = false;
                    animation.loop = false;
                    animation.play(side == Side.RIGHT ? shot1AnimRight : shot1AnimLeft);
                case SHOT_2:
                    enableMoveAnimation = false;
                    animation.loop = false;
                    animation.play(side == Side.RIGHT ? shot2AnimRight : shot2AnimLeft); 
                case DEFEND:
                    enableMoveAnimation = false;
                    animation.loop = false;
                    animation.play(side == Side.RIGHT ? defendAnimRight : deadAnimLeft); 
                case DODGE:
                    animation.loop = false;
                    animation.play(side == Side.RIGHT ? dodgeAnimRight : dodgeAnimLeft); 
                default:
                    animation.loop = true;
                    animation.play(side == Side.RIGHT ? idleAnimRight : idleAnimLeft);
            }
        }
    }

    // Load tiles

    public function loadIdle(right:Array<Tile>, left:Array<Tile>) {
        idleAnimRight = right;
        idleAnimLeft = left;
    }

    public function loadRun(right:Array<Tile>, left:Array<Tile>) {
        runAnimRight = right;
        runAnimLeft = left;
    }

    public function loadWalk(right:Array<Tile>, left:Array<Tile>) {
        walkAnimRight = right;
        walkAnimLeft = left;
    }

    public function loadDead(right:Array<Tile>, left:Array<Tile>) {
        deadAnimRight = right;
        deadAnimLeft = left;
    }

    public function loadHurt(right:Array<Tile>, left:Array<Tile>) {
        hurtAnimRight = right;
        hurtAnimLeft = left;
    }

    public function loadAttack1(right:Array<Tile>, left:Array<Tile>) {
        attack1AnimRight = right;
        attack1AnimLeft = left;
    }

    public function loadAttack2(right:Array<Tile>, left:Array<Tile>) {
        attack2AnimRight = right;
        attack2AnimLeft = left;
    }

    public function loadAttack3(right:Array<Tile>, left:Array<Tile>) {
        attack3AnimRight = right;
        attack3AnimLeft = left;
    }

    public function loadAttackRun(right:Array<Tile>, left:Array<Tile>) {
        attackRunAnimRight = right;
        attackRunAnimLeft = left;
    }

    public function loadShot1(right:Array<Tile>, left:Array<Tile>) {
        shot1AnimRight = right;
        shot1AnimLeft = left;
    }

    public function loadShot2(right:Array<Tile>, left:Array<Tile>) {
        shot2AnimRight = right;
        shot2AnimLeft = left;
    }

    public function loadDefend(right:Array<Tile>, left:Array<Tile>) {
        defendAnimRight = right;
        defendAnimLeft = left;
    }

    public function loadDodge(right:Array<Tile>, left:Array<Tile>) {
        dodgeAnimRight = right;
        dodgeAnimLeft = left;
    }
}

// TODO rmk, no need to flip x that way any more
class CharacterAnimations {

    public static function LoadRagnarLohAnimation(parent:h2d.Object) {
        final animation = new CharacterAnimation(parent);
        final leftOffsetX = 0;

        animation.loadIdle(
            [
                hxd.Res.ragnar.ragnar_loh.toTile().center(),
            ],
            flipTilesLeft([
                hxd.Res.ragnar.ragnar_loh.toTile().center(),
            ], leftOffsetX)
        );

        animation.loadRun(
            [
                hxd.Res.ragnar.ragnar_loh.toTile().center(),
            ],
            flipTilesLeft([
                hxd.Res.ragnar.ragnar_loh.toTile().center(),
            ], leftOffsetX)
        );

        animation.loadWalk(
            [
                hxd.Res.ragnar.ragnar_loh.toTile().center(),
            ],
            flipTilesLeft([
                hxd.Res.ragnar.ragnar_loh.toTile().center(),
            ], leftOffsetX)
        );

        animation.loadDead(
            [
                hxd.Res.ragnar.ragnar_loh.toTile().center(),
            ],
            flipTilesLeft([
                hxd.Res.ragnar.ragnar_loh.toTile().center(),
            ], leftOffsetX)
        );

        animation.loadHurt(
            [
                hxd.Res.ragnar.ragnar_loh.toTile().center(),
            ],
            flipTilesLeft([
                hxd.Res.ragnar.ragnar_loh.toTile().center(),
            ], leftOffsetX)
        );

        animation.loadAttack1(
            [
                hxd.Res.ragnar.ragnar_loh.toTile().center(),
            ],
            flipTilesLeft([
                hxd.Res.ragnar.ragnar_loh.toTile().center(),
            ], leftOffsetX)
        );

        animation.loadAttack2(
            [
                hxd.Res.ragnar.ragnar_loh.toTile().center(),
            ],
            flipTilesLeft([
                hxd.Res.ragnar.ragnar_loh.toTile().center(),
            ], leftOffsetX)
        );

        animation.loadAttack3(
            [
                hxd.Res.ragnar.ragnar_loh.toTile().center(),
            ],
            flipTilesLeft([
                hxd.Res.ragnar.ragnar_loh.toTile().center(),
            ], leftOffsetX)
        );

        animation.loadAttackRun(
            [
                hxd.Res.ragnar.ragnar_loh.toTile().center(),
            ],
            flipTilesLeft([
                hxd.Res.ragnar.ragnar_loh.toTile().center(),
            ], leftOffsetX)
        );

        animation.loadDefend(
            [
                hxd.Res.ragnar.ragnar_loh.toTile().center(),
            ],
            flipTilesLeft([
                hxd.Res.ragnar.ragnar_loh.toTile().center(),
            ], leftOffsetX)
        );

        return animation;
    }

    public static function LoadRagnarNormAnimation(parent:h2d.Object) {
        final animation = new CharacterAnimation(parent);
        final leftOffsetX = 0;

        animation.loadIdle(
            [
                hxd.Res.ragnar.ragnar_norm.toTile().center(),
            ],
            flipTilesLeft([
                hxd.Res.ragnar.ragnar_norm.toTile().center(),
            ], leftOffsetX)
        );

        animation.loadRun(
            [
                hxd.Res.ragnar.ragnar_norm.toTile().center(),
            ],
            flipTilesLeft([
                hxd.Res.ragnar.ragnar_norm.toTile().center(),
            ], leftOffsetX)
        );

        animation.loadWalk(
            [
                hxd.Res.ragnar.ragnar_norm.toTile().center(),
            ],
            flipTilesLeft([
                hxd.Res.ragnar.ragnar_norm.toTile().center(),
            ], leftOffsetX)
        );

        animation.loadDead(
            [
                hxd.Res.ragnar.ragnar_norm.toTile().center(),
            ],
            flipTilesLeft([
                hxd.Res.ragnar.ragnar_norm.toTile().center(),
            ], leftOffsetX)
        );

        animation.loadHurt(
            [
                hxd.Res.ragnar.ragnar_norm.toTile().center(),
            ],
            flipTilesLeft([
                hxd.Res.ragnar.ragnar_norm.toTile().center(),
            ], leftOffsetX)
        );

        animation.loadAttack1(
            [
                hxd.Res.ragnar.ragnar_norm.toTile().center(),
            ],
            flipTilesLeft([
                hxd.Res.ragnar.ragnar_norm.toTile().center(),
            ], leftOffsetX)
        );

        animation.loadAttack2(
            [
                hxd.Res.ragnar.ragnar_norm.toTile().center(),
            ],
            flipTilesLeft([
                hxd.Res.ragnar.ragnar_norm.toTile().center(),
            ], leftOffsetX)
        );

        animation.loadAttack3(
            [
                hxd.Res.ragnar.ragnar_norm.toTile().center(),
            ],
            flipTilesLeft([
                hxd.Res.ragnar.ragnar_norm.toTile().center(),
            ], leftOffsetX)
        );

        animation.loadAttackRun(
            [
                hxd.Res.ragnar.ragnar_norm.toTile().center(),
            ],
            flipTilesLeft([
                hxd.Res.ragnar.ragnar_norm.toTile().center(),
            ], leftOffsetX)
        );

        animation.loadDefend(
            [
                hxd.Res.ragnar.ragnar_norm.toTile().center(),
            ],
            flipTilesLeft([
                hxd.Res.ragnar.ragnar_norm.toTile().center(),
            ], leftOffsetX)
        );

        return animation;
    }
    
    public static function LoadZombieBoyAnimation(parent:h2d.Object) {
        final animation = new CharacterAnimation(parent);
        final leftOffsetX = 0;

        animation.loadIdle(
            [
                hxd.Res.zombie_boy.zombie_boy.toTile().center(),
            ],
            flipTilesLeft([
                hxd.Res.zombie_boy.zombie_boy.toTile().center(),
            ], leftOffsetX)
        );

        animation.loadRun(
            [
                hxd.Res.zombie_boy.zombie_boy.toTile().center(),
            ],
            flipTilesLeft([
                hxd.Res.zombie_boy.zombie_boy.toTile().center(),
            ], leftOffsetX)
        );

        animation.loadWalk(
            [
                hxd.Res.zombie_boy.zombie_boy.toTile().center(),
            ],
            flipTilesLeft([
                hxd.Res.zombie_boy.zombie_boy.toTile().center(),
            ], leftOffsetX)
        );

        animation.loadDead(
            [
                hxd.Res.zombie_boy.zombie_boy.toTile().center(),
            ],
            flipTilesLeft([
                hxd.Res.zombie_boy.zombie_boy.toTile().center(),
            ], leftOffsetX)
        );

        animation.loadHurt(
            [
                hxd.Res.zombie_boy.zombie_boy.toTile().center(),
            ],
            flipTilesLeft([
                hxd.Res.zombie_boy.zombie_boy.toTile().center(),
            ], leftOffsetX)
        );

        animation.loadAttack1(
            [
                hxd.Res.zombie_boy.zombie_boy.toTile().center(),
            ],
            flipTilesLeft([
                hxd.Res.zombie_boy.zombie_boy.toTile().center(),
            ], leftOffsetX)
        );

        animation.loadAttack2(
            [
                hxd.Res.zombie_boy.zombie_boy.toTile().center(),
            ],
            flipTilesLeft([
                hxd.Res.zombie_boy.zombie_boy.toTile().center(),
            ], leftOffsetX)
        );

        animation.loadAttack3(
            [
                hxd.Res.zombie_boy.zombie_boy.toTile().center(),
            ],
            flipTilesLeft([
                hxd.Res.zombie_boy.zombie_boy.toTile().center(),
            ], leftOffsetX)
        );

        animation.loadAttackRun(
            [
                hxd.Res.zombie_boy.zombie_boy.toTile().center(),
            ],
            flipTilesLeft([
                hxd.Res.zombie_boy.zombie_boy.toTile().center(),
            ], leftOffsetX)
        );

        animation.loadDefend(
            [
                hxd.Res.zombie_boy.zombie_boy.toTile().center(),
            ],
            flipTilesLeft([
                hxd.Res.zombie_boy.zombie_boy.toTile().center(),
            ], leftOffsetX)
        );

        return animation;
    }

    public static function LoadZombieGirlAnimation(parent:h2d.Object) {
        final animation = new CharacterAnimation(parent);
        final leftOffsetX = 0;

        animation.loadIdle(
            [
                hxd.Res.zombie_girl.zombie_girl.toTile().center(),
            ],
            flipTilesLeft([
                hxd.Res.zombie_girl.zombie_girl.toTile().center(),
            ], leftOffsetX)
        );

        animation.loadRun(
            [
                hxd.Res.zombie_girl.zombie_girl.toTile().center(),
            ],
            flipTilesLeft([
                hxd.Res.zombie_girl.zombie_girl.toTile().center(),
            ], leftOffsetX)
        );

        animation.loadWalk(
            [
                hxd.Res.zombie_girl.zombie_girl.toTile().center(),
            ],
            flipTilesLeft([
                hxd.Res.zombie_girl.zombie_girl.toTile().center(),
            ], leftOffsetX)
        );

        animation.loadDead(
            [
                hxd.Res.zombie_girl.zombie_girl.toTile().center(),
            ],
            flipTilesLeft([
                hxd.Res.zombie_girl.zombie_girl.toTile().center(),
            ], leftOffsetX)
        );

        animation.loadHurt(
            [
                hxd.Res.zombie_girl.zombie_girl.toTile().center(),
            ],
            flipTilesLeft([
                hxd.Res.zombie_girl.zombie_girl.toTile().center(),
            ], leftOffsetX)
        );

        animation.loadAttack1(
            [
                hxd.Res.zombie_girl.zombie_girl.toTile().center(),
            ],
            flipTilesLeft([
                hxd.Res.zombie_girl.zombie_girl.toTile().center(),
            ], leftOffsetX)
        );

        animation.loadAttack2(
            [
                hxd.Res.zombie_girl.zombie_girl.toTile().center(),
            ],
            flipTilesLeft([
                hxd.Res.zombie_girl.zombie_girl.toTile().center(),
            ], leftOffsetX)
        );

        animation.loadAttack3(
            [
                hxd.Res.zombie_girl.zombie_girl.toTile().center(),
            ],
            flipTilesLeft([
                hxd.Res.zombie_girl.zombie_girl.toTile().center(),
            ], leftOffsetX)
        );

        animation.loadAttackRun(
            [
                hxd.Res.zombie_girl.zombie_girl.toTile().center(),
            ],
            flipTilesLeft([
                hxd.Res.zombie_girl.zombie_girl.toTile().center(),
            ], leftOffsetX)
        );

        animation.loadDefend(
            [
                hxd.Res.zombie_girl.zombie_girl.toTile().center(),
            ],
            flipTilesLeft([
                hxd.Res.zombie_girl.zombie_girl.toTile().center(),
            ], leftOffsetX)
        );

        return animation;
    }

    private static function flipTilesLeft(tiles:Array<Tile>, offsetX:Int) {
        for (index => value in tiles) {
            value.flipX();
            value.dx += offsetX;
        }
        return tiles;
    }

}