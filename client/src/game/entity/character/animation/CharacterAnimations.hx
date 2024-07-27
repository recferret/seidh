package game.entity.character.animation;

import h2d.Anim;
import h2d.Tile;

import engine.base.BaseTypesAndClasses.CharacterAnimationState;
import engine.base.BaseTypesAndClasses.Side;

import game.Res.SeidhResource;

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
                Res.instance.getTileResource(SeidhResource.RAGNAR_BASE),
            ],
            flipTilesLeft([
                Res.instance.getTileResource(SeidhResource.RAGNAR_BASE),
            ], leftOffsetX)
        );

        // Flip on the fly ?
        animation.loadRun(
            [
                Res.instance.getTileResource(SeidhResource.RAGNAR_RUN_1),
                Res.instance.getTileResource(SeidhResource.RAGNAR_RUN_2),
                Res.instance.getTileResource(SeidhResource.RAGNAR_RUN_3),
                Res.instance.getTileResource(SeidhResource.RAGNAR_RUN_4),
                Res.instance.getTileResource(SeidhResource.RAGNAR_RUN_5),
                Res.instance.getTileResource(SeidhResource.RAGNAR_RUN_6),
            ],
            flipTilesLeft([
                Res.instance.getTileResource(SeidhResource.RAGNAR_RUN_1),
                Res.instance.getTileResource(SeidhResource.RAGNAR_RUN_2),
                Res.instance.getTileResource(SeidhResource.RAGNAR_RUN_3),
                Res.instance.getTileResource(SeidhResource.RAGNAR_RUN_4),
                Res.instance.getTileResource(SeidhResource.RAGNAR_RUN_5),
                Res.instance.getTileResource(SeidhResource.RAGNAR_RUN_6),
            ], leftOffsetX)
        );

        animation.loadWalk(
            [
                Res.instance.getTileResource(SeidhResource.RAGNAR_BASE),
            ],
            flipTilesLeft([
                Res.instance.getTileResource(SeidhResource.RAGNAR_BASE),
            ], leftOffsetX)
        );

        animation.loadDead(
            [
                Res.instance.getTileResource(SeidhResource.RAGNAR_BASE),
            ],
            flipTilesLeft([
                Res.instance.getTileResource(SeidhResource.RAGNAR_BASE),
            ], leftOffsetX)
        );

        animation.loadHurt(
            [
                Res.instance.getTileResource(SeidhResource.RAGNAR_BASE),
            ],
            flipTilesLeft([
                Res.instance.getTileResource(SeidhResource.RAGNAR_BASE),
            ], leftOffsetX)
        );

        animation.loadAttack1(
            [
                Res.instance.getTileResource(SeidhResource.RAGNAR_BASE),
            ],
            flipTilesLeft([
                Res.instance.getTileResource(SeidhResource.RAGNAR_BASE),
            ], leftOffsetX)
        );

        animation.loadAttack2(
            [
                Res.instance.getTileResource(SeidhResource.RAGNAR_BASE),
            ],
            flipTilesLeft([
                Res.instance.getTileResource(SeidhResource.RAGNAR_BASE),
            ], leftOffsetX)
        );

        animation.loadAttack3(
            [
                Res.instance.getTileResource(SeidhResource.RAGNAR_BASE),
            ],
            flipTilesLeft([
                Res.instance.getTileResource(SeidhResource.RAGNAR_BASE),
            ], leftOffsetX)
        );

        animation.loadAttackRun(
            [
                Res.instance.getTileResource(SeidhResource.RAGNAR_BASE),
            ],
            flipTilesLeft([
                Res.instance.getTileResource(SeidhResource.RAGNAR_BASE),
            ], leftOffsetX)
        );

        animation.loadDefend(
            [
                Res.instance.getTileResource(SeidhResource.RAGNAR_BASE),
            ],
            flipTilesLeft([
                Res.instance.getTileResource(SeidhResource.RAGNAR_BASE),
            ], leftOffsetX)
        );

        return animation;
    }

    public static function LoadRagnarNormAnimation(parent:h2d.Object) {
        final animation = new CharacterAnimation(parent);
        final leftOffsetX = 0;

        animation.loadIdle(
            [
                Res.instance.getTileResource(SeidhResource.RAGNAR_BASE),
            ],
            flipTilesLeft([
                Res.instance.getTileResource(SeidhResource.RAGNAR_BASE),
            ], leftOffsetX)
        );

        animation.loadRun(
            [
                Res.instance.getTileResource(SeidhResource.RAGNAR_BASE),
            ],
            flipTilesLeft([
                Res.instance.getTileResource(SeidhResource.RAGNAR_BASE),
            ], leftOffsetX)
        );

        animation.loadWalk(
            [
                Res.instance.getTileResource(SeidhResource.RAGNAR_BASE),
            ],
            flipTilesLeft([
                Res.instance.getTileResource(SeidhResource.RAGNAR_BASE),
            ], leftOffsetX)
        );

        animation.loadDead(
            [
                Res.instance.getTileResource(SeidhResource.RAGNAR_BASE),
            ],
            flipTilesLeft([
                Res.instance.getTileResource(SeidhResource.RAGNAR_BASE),
            ], leftOffsetX)
        );

        animation.loadHurt(
            [
                Res.instance.getTileResource(SeidhResource.RAGNAR_BASE),
            ],
            flipTilesLeft([
                Res.instance.getTileResource(SeidhResource.RAGNAR_BASE),
            ], leftOffsetX)
        );

        animation.loadAttack1(
            [
                Res.instance.getTileResource(SeidhResource.RAGNAR_BASE),
            ],
            flipTilesLeft([
                Res.instance.getTileResource(SeidhResource.RAGNAR_BASE),
            ], leftOffsetX)
        );

        animation.loadAttack2(
            [
                Res.instance.getTileResource(SeidhResource.RAGNAR_BASE),
            ],
            flipTilesLeft([
                Res.instance.getTileResource(SeidhResource.RAGNAR_BASE),
            ], leftOffsetX)
        );

        animation.loadAttack3(
            [
                Res.instance.getTileResource(SeidhResource.RAGNAR_BASE),
            ],
            flipTilesLeft([
                Res.instance.getTileResource(SeidhResource.RAGNAR_BASE),
            ], leftOffsetX)
        );

        animation.loadAttackRun(
            [
                Res.instance.getTileResource(SeidhResource.RAGNAR_BASE),
            ],
            flipTilesLeft([
                Res.instance.getTileResource(SeidhResource.RAGNAR_BASE),
            ], leftOffsetX)
        );

        animation.loadDefend(
            [
                Res.instance.getTileResource(SeidhResource.RAGNAR_BASE),
            ],
            flipTilesLeft([
                Res.instance.getTileResource(SeidhResource.RAGNAR_BASE),
            ], leftOffsetX)
        );

        return animation;
    }
    
    public static function LoadZombieBoyAnimation(parent:h2d.Object) {
        final animation = new CharacterAnimation(parent);
        final leftOffsetX = 0;

        animation.loadIdle(
            [
                Res.instance.getTileResource(SeidhResource.ZOMBIE_BOY),
            ],
            flipTilesLeft([
                Res.instance.getTileResource(SeidhResource.ZOMBIE_BOY),
            ], leftOffsetX)
        );

        animation.loadRun(
            [
                Res.instance.getTileResource(SeidhResource.ZOMBIE_BOY),
            ],
            flipTilesLeft([
                Res.instance.getTileResource(SeidhResource.ZOMBIE_BOY),
            ], leftOffsetX)
        );

        animation.loadWalk(
            [
                Res.instance.getTileResource(SeidhResource.ZOMBIE_BOY),
            ],
            flipTilesLeft([
                Res.instance.getTileResource(SeidhResource.ZOMBIE_BOY),
            ], leftOffsetX)
        );

        animation.loadDead(
            [
                Res.instance.getTileResource(SeidhResource.ZOMBIE_BOY),
            ],
            flipTilesLeft([
                Res.instance.getTileResource(SeidhResource.ZOMBIE_BOY),
            ], leftOffsetX)
        );

        animation.loadHurt(
            [
                Res.instance.getTileResource(SeidhResource.ZOMBIE_BOY),
            ],
            flipTilesLeft([
                Res.instance.getTileResource(SeidhResource.ZOMBIE_BOY),
            ], leftOffsetX)
        );

        animation.loadAttack1(
            [
                Res.instance.getTileResource(SeidhResource.ZOMBIE_BOY),
            ],
            flipTilesLeft([
                Res.instance.getTileResource(SeidhResource.ZOMBIE_BOY),
            ], leftOffsetX)
        );

        animation.loadAttack2(
            [
                Res.instance.getTileResource(SeidhResource.ZOMBIE_BOY),
            ],
            flipTilesLeft([
                Res.instance.getTileResource(SeidhResource.ZOMBIE_BOY),
            ], leftOffsetX)
        );

        animation.loadAttack3(
            [
                Res.instance.getTileResource(SeidhResource.ZOMBIE_BOY),
            ],
            flipTilesLeft([
                Res.instance.getTileResource(SeidhResource.ZOMBIE_BOY),
            ], leftOffsetX)
        );

        animation.loadAttackRun(
            [
                Res.instance.getTileResource(SeidhResource.ZOMBIE_BOY),
            ],
            flipTilesLeft([
                Res.instance.getTileResource(SeidhResource.ZOMBIE_BOY),
            ], leftOffsetX)
        );

        animation.loadDefend(
            [
                Res.instance.getTileResource(SeidhResource.ZOMBIE_BOY),
            ],
            flipTilesLeft([
                Res.instance.getTileResource(SeidhResource.ZOMBIE_BOY),
            ], leftOffsetX)
        );

        return animation;
    }

    public static function LoadZombieGirlAnimation(parent:h2d.Object) {
        final animation = new CharacterAnimation(parent);
        final leftOffsetX = 0;

        animation.loadIdle(
            [
                Res.instance.getTileResource(SeidhResource.ZOMBIE_GIRL),
            ],
            flipTilesLeft([
                Res.instance.getTileResource(SeidhResource.ZOMBIE_GIRL),
            ], leftOffsetX)
        );

        animation.loadRun(
            [
                Res.instance.getTileResource(SeidhResource.ZOMBIE_GIRL),
            ],
            flipTilesLeft([
                Res.instance.getTileResource(SeidhResource.ZOMBIE_GIRL),
            ], leftOffsetX)
        );

        animation.loadWalk(
            [
                Res.instance.getTileResource(SeidhResource.ZOMBIE_GIRL),
            ],
            flipTilesLeft([
                Res.instance.getTileResource(SeidhResource.ZOMBIE_GIRL),
            ], leftOffsetX)
        );

        animation.loadDead(
            [
                Res.instance.getTileResource(SeidhResource.ZOMBIE_GIRL),
            ],
            flipTilesLeft([
                Res.instance.getTileResource(SeidhResource.ZOMBIE_GIRL),
            ], leftOffsetX)
        );

        animation.loadHurt(
            [
                Res.instance.getTileResource(SeidhResource.ZOMBIE_GIRL),
            ],
            flipTilesLeft([
                Res.instance.getTileResource(SeidhResource.ZOMBIE_GIRL),
            ], leftOffsetX)
        );

        animation.loadAttack1(
            [
                Res.instance.getTileResource(SeidhResource.ZOMBIE_GIRL),
            ],
            flipTilesLeft([
                Res.instance.getTileResource(SeidhResource.ZOMBIE_GIRL),
            ], leftOffsetX)
        );

        animation.loadAttack2(
            [
                Res.instance.getTileResource(SeidhResource.ZOMBIE_GIRL),
            ],
            flipTilesLeft([
                Res.instance.getTileResource(SeidhResource.ZOMBIE_GIRL),
            ], leftOffsetX)
        );

        animation.loadAttack3(
            [
                Res.instance.getTileResource(SeidhResource.ZOMBIE_GIRL),
            ],
            flipTilesLeft([
                Res.instance.getTileResource(SeidhResource.ZOMBIE_GIRL),
            ], leftOffsetX)
        );

        animation.loadAttackRun(
            [
                Res.instance.getTileResource(SeidhResource.ZOMBIE_GIRL),
            ],
            flipTilesLeft([
                Res.instance.getTileResource(SeidhResource.ZOMBIE_GIRL),
            ], leftOffsetX)
        );

        animation.loadDefend(
            [
                Res.instance.getTileResource(SeidhResource.ZOMBIE_GIRL),
            ],
            flipTilesLeft([
                Res.instance.getTileResource(SeidhResource.ZOMBIE_GIRL),
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