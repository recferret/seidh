package game.entity.character.animation;

import h2d.Anim;
import h2d.Tile;
import engine.base.BaseTypesAndClasses.CharacterAnimationState;
import engine.base.BaseTypesAndClasses.Side;

class EntityAnimation {
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

class CharacterAnimations {

    public static function LoadKnightAnimation(parent:h2d.Object) {
        final animation = new EntityAnimation(parent);
        final leftOffsetX = 62;

        animation.loadIdle(
            [
                hxd.Res.knight.idle._1.toTile(),
                hxd.Res.knight.idle._2.toTile(), 
                hxd.Res.knight.idle._3.toTile(), 
                hxd.Res.knight.idle._4.toTile(),
            ],
            flipTilesLeft([
                hxd.Res.knight.idle._1.toTile(),
                hxd.Res.knight.idle._2.toTile(), 
                hxd.Res.knight.idle._3.toTile(), 
                hxd.Res.knight.idle._4.toTile(),
            ], leftOffsetX)
        );

        animation.loadRun(
            [
                hxd.Res.knight.run._1.toTile(),
                hxd.Res.knight.run._2.toTile(), 
                hxd.Res.knight.run._3.toTile(), 
                hxd.Res.knight.run._4.toTile(), 
                hxd.Res.knight.run._5.toTile(), 
                hxd.Res.knight.run._6.toTile(), 
                hxd.Res.knight.run._7.toTile(),
            ],
            flipTilesLeft([
                hxd.Res.knight.run._1.toTile(),
                hxd.Res.knight.run._2.toTile(), 
                hxd.Res.knight.run._3.toTile(), 
                hxd.Res.knight.run._4.toTile(), 
                hxd.Res.knight.run._5.toTile(), 
                hxd.Res.knight.run._6.toTile(), 
                hxd.Res.knight.run._7.toTile(),
            ], leftOffsetX)
        );

        animation.loadWalk(
            [
                hxd.Res.knight.walk._1.toTile(), 
                hxd.Res.knight.walk._2.toTile(), 
                hxd.Res.knight.walk._3.toTile(), 
                hxd.Res.knight.walk._4.toTile(), 
                hxd.Res.knight.walk._5.toTile(), 
                hxd.Res.knight.walk._6.toTile(), 
                hxd.Res.knight.walk._7.toTile(), 
                hxd.Res.knight.walk._8.toTile(),
            ],
            flipTilesLeft([
                hxd.Res.knight.walk._2.toTile(), 
                hxd.Res.knight.walk._3.toTile(), 
                hxd.Res.knight.walk._4.toTile(), 
                hxd.Res.knight.walk._5.toTile(), 
                hxd.Res.knight.walk._6.toTile(), 
                hxd.Res.knight.walk._7.toTile(), 
                hxd.Res.knight.walk._8.toTile(),
            ], leftOffsetX)
        );

        animation.loadDead(
            [
                hxd.Res.knight.dead._1.toTile(),
                hxd.Res.knight.dead._2.toTile(), 
                hxd.Res.knight.dead._3.toTile(), 
                hxd.Res.knight.dead._4.toTile(),
                hxd.Res.knight.dead._5.toTile(),
                hxd.Res.knight.dead._6.toTile(),
            ],
            flipTilesLeft([
                hxd.Res.knight.dead._1.toTile(),
                hxd.Res.knight.dead._2.toTile(), 
                hxd.Res.knight.dead._3.toTile(), 
                hxd.Res.knight.dead._4.toTile(),
                hxd.Res.knight.dead._5.toTile(),
                hxd.Res.knight.dead._6.toTile(),
            ], leftOffsetX)
        );

        animation.loadHurt(
            [
                hxd.Res.knight.hurt._1.toTile(),
                hxd.Res.knight.hurt._2.toTile(), 
            ],
            flipTilesLeft([
                hxd.Res.knight.hurt._1.toTile(),
                hxd.Res.knight.hurt._2.toTile(), 
            ], leftOffsetX)
        );

        animation.loadAttack1(
            [
                hxd.Res.knight.attack_1._1.toTile(),
                hxd.Res.knight.attack_1._2.toTile(), 
                hxd.Res.knight.attack_1._3.toTile(), 
                hxd.Res.knight.attack_1._4.toTile(),
                hxd.Res.knight.attack_1._5.toTile(),
            ],
            flipTilesLeft([
                hxd.Res.knight.attack_1._1.toTile(),
                hxd.Res.knight.attack_1._2.toTile(), 
                hxd.Res.knight.attack_1._3.toTile(), 
                hxd.Res.knight.attack_1._4.toTile(),
                hxd.Res.knight.attack_1._5.toTile(),
            ], leftOffsetX)
        );

        animation.loadAttack2(
            [
                hxd.Res.knight.attack_2._1.toTile(),
                hxd.Res.knight.attack_2._2.toTile(), 
                hxd.Res.knight.attack_2._3.toTile(), 
                hxd.Res.knight.attack_2._4.toTile(),
            ],
            flipTilesLeft([
                hxd.Res.knight.attack_2._1.toTile(),
                hxd.Res.knight.attack_2._2.toTile(), 
                hxd.Res.knight.attack_2._3.toTile(), 
                hxd.Res.knight.attack_2._4.toTile(),
            ], leftOffsetX)
        );

        animation.loadAttack3(
            [
                hxd.Res.knight.attack_3._1.toTile(),
                hxd.Res.knight.attack_3._2.toTile(), 
                hxd.Res.knight.attack_3._3.toTile(), 
                hxd.Res.knight.attack_3._4.toTile(),
            ],
            flipTilesLeft([
                hxd.Res.knight.attack_3._1.toTile(),
                hxd.Res.knight.attack_3._2.toTile(), 
                hxd.Res.knight.attack_3._3.toTile(), 
                hxd.Res.knight.attack_3._4.toTile(),
            ], leftOffsetX)
        );

        animation.loadAttackRun(
            [
                hxd.Res.knight.attack_run._1.toTile(),
                hxd.Res.knight.attack_run._2.toTile(), 
                hxd.Res.knight.attack_run._3.toTile(), 
                hxd.Res.knight.attack_run._4.toTile(), 
                hxd.Res.knight.attack_run._5.toTile(), 
                hxd.Res.knight.attack_run._6.toTile(),
            ],
            flipTilesLeft([
                hxd.Res.knight.attack_run._1.toTile(),
                hxd.Res.knight.attack_run._2.toTile(), 
                hxd.Res.knight.attack_run._3.toTile(), 
                hxd.Res.knight.attack_run._4.toTile(), 
                hxd.Res.knight.attack_run._5.toTile(), 
                hxd.Res.knight.attack_run._6.toTile(),
            ], leftOffsetX)
        );

        animation.loadDefend(
            [
                hxd.Res.knight.defend._1.toTile(),
                hxd.Res.knight.defend._2.toTile(), 
                hxd.Res.knight.defend._3.toTile(), 
                hxd.Res.knight.defend._4.toTile(), 
                hxd.Res.knight.defend._5.toTile(), 
            ],
            flipTilesLeft([
                hxd.Res.knight.defend._1.toTile(),
                hxd.Res.knight.defend._2.toTile(), 
                hxd.Res.knight.defend._3.toTile(), 
                hxd.Res.knight.defend._4.toTile(), 
                hxd.Res.knight.defend._5.toTile(), 
            ], leftOffsetX)
        );

        return animation;
    }

    public static function LoadSamuraiAnimation(parent:h2d.Object) {
        final animation = new EntityAnimation(parent);
        final leftOffsetX = 62;
        
        animation.loadIdle(
            [
                hxd.Res.samurai.idle._1.toTile(), 
                hxd.Res.samurai.idle._2.toTile(), 
                hxd.Res.samurai.idle._3.toTile(), 
                hxd.Res.samurai.idle._4.toTile(), 
                hxd.Res.samurai.idle._5.toTile(), 
                hxd.Res.samurai.idle._6.toTile(),
                hxd.Res.samurai.idle._7.toTile(),
                hxd.Res.samurai.idle._8.toTile(),
                hxd.Res.samurai.idle._9.toTile(),
            ],
            flipTilesLeft([
                hxd.Res.samurai.idle._1.toTile(), 
                hxd.Res.samurai.idle._2.toTile(), 
                hxd.Res.samurai.idle._3.toTile(), 
                hxd.Res.samurai.idle._4.toTile(), 
                hxd.Res.samurai.idle._5.toTile(), 
                hxd.Res.samurai.idle._6.toTile(),
                hxd.Res.samurai.idle._7.toTile(),
                hxd.Res.samurai.idle._8.toTile(),
                hxd.Res.samurai.idle._9.toTile(),
            ], leftOffsetX)
        );

        animation.loadRun(
            [
                hxd.Res.samurai.run._1.toTile(),
                hxd.Res.samurai.run._2.toTile(), 
                hxd.Res.samurai.run._3.toTile(), 
                hxd.Res.samurai.run._4.toTile(), 
                hxd.Res.samurai.run._5.toTile(), 
                hxd.Res.samurai.run._6.toTile(), 
                hxd.Res.samurai.run._7.toTile(), 
                hxd.Res.samurai.run._8.toTile(),
            ],
            flipTilesLeft([
                hxd.Res.samurai.run._1.toTile(),
                hxd.Res.samurai.run._2.toTile(), 
                hxd.Res.samurai.run._3.toTile(), 
                hxd.Res.samurai.run._4.toTile(), 
                hxd.Res.samurai.run._5.toTile(), 
                hxd.Res.samurai.run._6.toTile(), 
                hxd.Res.samurai.run._7.toTile(), 
                hxd.Res.samurai.run._8.toTile(),
            ], leftOffsetX)
        );

        animation.loadWalk(
            [
                hxd.Res.samurai.walk._1.toTile(), 
                hxd.Res.samurai.walk._2.toTile(), 
                hxd.Res.samurai.walk._3.toTile(), 
                hxd.Res.samurai.walk._4.toTile(), 
                hxd.Res.samurai.walk._5.toTile(), 
                hxd.Res.samurai.walk._6.toTile(), 
                hxd.Res.samurai.walk._7.toTile(), 
                hxd.Res.samurai.walk._8.toTile(),
            ],
            flipTilesLeft([
                hxd.Res.samurai.walk._1.toTile(), 
                hxd.Res.samurai.walk._2.toTile(), 
                hxd.Res.samurai.walk._3.toTile(), 
                hxd.Res.samurai.walk._4.toTile(), 
                hxd.Res.samurai.walk._5.toTile(), 
                hxd.Res.samurai.walk._6.toTile(), 
                hxd.Res.samurai.walk._7.toTile(), 
                hxd.Res.samurai.walk._8.toTile(),
            ], leftOffsetX)
        );

        animation.loadDead(
            [
                hxd.Res.samurai.dead._1.toTile(),
                hxd.Res.samurai.dead._2.toTile(), 
                hxd.Res.samurai.dead._3.toTile(), 
                hxd.Res.samurai.dead._4.toTile(),
                hxd.Res.samurai.dead._5.toTile(),
            ],
            flipTilesLeft([
                hxd.Res.samurai.dead._1.toTile(),
                hxd.Res.samurai.dead._2.toTile(), 
                hxd.Res.samurai.dead._3.toTile(), 
                hxd.Res.samurai.dead._4.toTile(),
                hxd.Res.samurai.dead._5.toTile(),
            ], leftOffsetX)
        );

        animation.loadHurt(
            [
                hxd.Res.samurai.hurt._1.toTile(),
                hxd.Res.samurai.hurt._2.toTile(), 
                hxd.Res.samurai.hurt._3.toTile(), 
            ],
            flipTilesLeft([
                hxd.Res.samurai.hurt._1.toTile(),
                hxd.Res.samurai.hurt._2.toTile(), 
                hxd.Res.samurai.hurt._3.toTile(), 
            ], leftOffsetX)
        );

        animation.loadAttack1(
            [
                hxd.Res.samurai.attack_1._1.toTile(),
                hxd.Res.samurai.attack_1._2.toTile(), 
                hxd.Res.samurai.attack_1._3.toTile(), 
                hxd.Res.samurai.attack_1._4.toTile(),
                hxd.Res.samurai.attack_1._5.toTile(),
            ],
            flipTilesLeft([
                hxd.Res.samurai.attack_1._1.toTile(),
                hxd.Res.samurai.attack_1._2.toTile(), 
                hxd.Res.samurai.attack_1._3.toTile(), 
                hxd.Res.samurai.attack_1._4.toTile(),
                hxd.Res.samurai.attack_1._5.toTile(),
            ], leftOffsetX)
        );

        animation.loadAttack2(
            [
                hxd.Res.samurai.attack_2._1.toTile(),
                hxd.Res.samurai.attack_2._2.toTile(), 
                hxd.Res.samurai.attack_2._3.toTile(), 
                hxd.Res.samurai.attack_2._4.toTile(),
                hxd.Res.samurai.attack_2._5.toTile(),
            ],
            flipTilesLeft([
                hxd.Res.samurai.attack_2._1.toTile(),
                hxd.Res.samurai.attack_2._2.toTile(), 
                hxd.Res.samurai.attack_2._3.toTile(), 
                hxd.Res.samurai.attack_2._4.toTile(),
                hxd.Res.samurai.attack_2._5.toTile(),
            ], leftOffsetX)
        );

        animation.loadAttack3(
            [
                hxd.Res.samurai.attack_3._1.toTile(),
                hxd.Res.samurai.attack_3._2.toTile(), 
                hxd.Res.samurai.attack_3._3.toTile(), 
                hxd.Res.samurai.attack_3._4.toTile(), 
                hxd.Res.samurai.attack_3._5.toTile(), 
                hxd.Res.samurai.attack_3._6.toTile(), 
            ],
            flipTilesLeft([
                hxd.Res.samurai.attack_3._1.toTile(),
                hxd.Res.samurai.attack_3._2.toTile(), 
                hxd.Res.samurai.attack_3._3.toTile(), 
                hxd.Res.samurai.attack_3._4.toTile(), 
                hxd.Res.samurai.attack_3._5.toTile(), 
                hxd.Res.samurai.attack_3._6.toTile(),
            ], leftOffsetX)
        );

        animation.loadShot1(
            [
                hxd.Res.samurai.shot_1._1.toTile(),
                hxd.Res.samurai.shot_1._2.toTile(), 
                hxd.Res.samurai.shot_1._3.toTile(), 
                hxd.Res.samurai.shot_1._4.toTile(), 
                hxd.Res.samurai.shot_1._5.toTile(),
                hxd.Res.samurai.shot_1._6.toTile(), 
                hxd.Res.samurai.shot_1._7.toTile(), 
                hxd.Res.samurai.shot_1._8.toTile(),
                hxd.Res.samurai.shot_1._9.toTile(),
                hxd.Res.samurai.shot_1._10.toTile(), 
                hxd.Res.samurai.shot_1._11.toTile(), 
                hxd.Res.samurai.shot_1._12.toTile(),
                hxd.Res.samurai.shot_1._13.toTile(), 
                hxd.Res.samurai.shot_1._14.toTile(),
            ],
            flipTilesLeft([
                hxd.Res.samurai.shot_1._1.toTile(),
                hxd.Res.samurai.shot_1._2.toTile(), 
                hxd.Res.samurai.shot_1._3.toTile(), 
                hxd.Res.samurai.shot_1._4.toTile(), 
                hxd.Res.samurai.shot_1._5.toTile(),
                hxd.Res.samurai.shot_1._6.toTile(), 
                hxd.Res.samurai.shot_1._7.toTile(), 
                hxd.Res.samurai.shot_1._8.toTile(),
                hxd.Res.samurai.shot_1._9.toTile(),
                hxd.Res.samurai.shot_1._10.toTile(), 
                hxd.Res.samurai.shot_1._11.toTile(), 
                hxd.Res.samurai.shot_1._12.toTile(),
                hxd.Res.samurai.shot_1._13.toTile(), 
                hxd.Res.samurai.shot_1._14.toTile(),
            ], leftOffsetX)
        );

        return animation;
    }

    public static function LoadSkeletonWarriorAnimation(parent:h2d.Object) {
        final animation = new EntityAnimation(parent);
        final leftOffsetX = 120;

        animation.loadIdle(
            [
                hxd.Res.skeleton.idle._1.toTile(), 
                hxd.Res.skeleton.idle._2.toTile(), 
                hxd.Res.skeleton.idle._3.toTile(), 
                hxd.Res.skeleton.idle._4.toTile(), 
                hxd.Res.skeleton.idle._5.toTile(), 
                hxd.Res.skeleton.idle._6.toTile(),
                hxd.Res.skeleton.idle._7.toTile(),
            ],
            flipTilesLeft([
                hxd.Res.skeleton.idle._1.toTile(), 
                hxd.Res.skeleton.idle._2.toTile(), 
                hxd.Res.skeleton.idle._3.toTile(), 
                hxd.Res.skeleton.idle._4.toTile(), 
                hxd.Res.skeleton.idle._5.toTile(), 
                hxd.Res.skeleton.idle._6.toTile(),
                hxd.Res.skeleton.idle._7.toTile(),
            ], leftOffsetX)
        );

        animation.loadRun(
            [
                hxd.Res.skeleton.run._1.toTile(), 
                hxd.Res.skeleton.run._2.toTile(), 
                hxd.Res.skeleton.run._3.toTile(), 
                hxd.Res.skeleton.run._4.toTile(), 
                hxd.Res.skeleton.run._5.toTile(), 
                hxd.Res.skeleton.run._6.toTile(),
                hxd.Res.skeleton.run._7.toTile(),
                hxd.Res.skeleton.run._8.toTile(),
            ],
            flipTilesLeft([
                hxd.Res.skeleton.run._1.toTile(), 
                hxd.Res.skeleton.run._2.toTile(), 
                hxd.Res.skeleton.run._3.toTile(), 
                hxd.Res.skeleton.run._4.toTile(), 
                hxd.Res.skeleton.run._5.toTile(), 
                hxd.Res.skeleton.run._6.toTile(),
                hxd.Res.skeleton.run._7.toTile(),
                hxd.Res.skeleton.run._8.toTile(),
            ], leftOffsetX)
        );

        animation.loadWalk(
            [
                hxd.Res.skeleton.walk._1.toTile(), 
                hxd.Res.skeleton.walk._2.toTile(), 
                hxd.Res.skeleton.walk._3.toTile(), 
                hxd.Res.skeleton.walk._4.toTile(), 
                hxd.Res.skeleton.walk._5.toTile(), 
                hxd.Res.skeleton.walk._6.toTile(),
                hxd.Res.skeleton.walk._7.toTile(),
            ],
            flipTilesLeft([
                hxd.Res.skeleton.walk._1.toTile(), 
                hxd.Res.skeleton.walk._2.toTile(), 
                hxd.Res.skeleton.walk._3.toTile(), 
                hxd.Res.skeleton.walk._4.toTile(), 
                hxd.Res.skeleton.walk._5.toTile(), 
                hxd.Res.skeleton.walk._6.toTile(),
                hxd.Res.skeleton.walk._7.toTile(),
            ], leftOffsetX)
        );

        animation.loadDead(
            [
                hxd.Res.skeleton.dead._1.toTile(),
                hxd.Res.skeleton.dead._2.toTile(), 
                hxd.Res.skeleton.dead._3.toTile(), 
                hxd.Res.skeleton.dead._4.toTile(), 
            ],
            flipTilesLeft([
                hxd.Res.skeleton.dead._1.toTile(),
                hxd.Res.skeleton.dead._2.toTile(), 
                hxd.Res.skeleton.dead._3.toTile(), 
                hxd.Res.skeleton.dead._4.toTile(), 
            ], leftOffsetX)
        );

        animation.loadHurt(
            [
                hxd.Res.skeleton.hurt._1.toTile(),
                hxd.Res.skeleton.hurt._2.toTile(), 
            ],
            flipTilesLeft([
                hxd.Res.skeleton.hurt._1.toTile(),
                hxd.Res.skeleton.hurt._2.toTile(), 
            ], leftOffsetX)
        );

        animation.loadAttack1(
            [
                hxd.Res.skeleton.attack_1._1.toTile(),
                hxd.Res.skeleton.attack_1._2.toTile(),
                hxd.Res.skeleton.attack_1._3.toTile(),
                hxd.Res.skeleton.attack_1._4.toTile(),
            ],
            flipTilesLeft([
                hxd.Res.skeleton.attack_1._1.toTile(),
                hxd.Res.skeleton.attack_1._2.toTile(),
                hxd.Res.skeleton.attack_1._3.toTile(),
                hxd.Res.skeleton.attack_1._4.toTile(),
            ], leftOffsetX)
        );

        animation.loadAttack2(
            [
                hxd.Res.skeleton.attack_2._1.toTile(),
                hxd.Res.skeleton.attack_2._2.toTile(),
                hxd.Res.skeleton.attack_2._3.toTile(),
                hxd.Res.skeleton.attack_2._4.toTile(),
                hxd.Res.skeleton.attack_2._5.toTile(),
                hxd.Res.skeleton.attack_2._6.toTile(),
            ],
            flipTilesLeft([
                hxd.Res.skeleton.attack_2._1.toTile(),
                hxd.Res.skeleton.attack_2._2.toTile(),
                hxd.Res.skeleton.attack_2._3.toTile(),
                hxd.Res.skeleton.attack_2._4.toTile(),
                hxd.Res.skeleton.attack_2._5.toTile(),
                hxd.Res.skeleton.attack_2._6.toTile(),
            ], leftOffsetX)
        );

        animation.loadAttack3(
            [
                hxd.Res.skeleton.attack_3._1.toTile(),
                hxd.Res.skeleton.attack_3._2.toTile(),
                hxd.Res.skeleton.attack_3._3.toTile(),
                hxd.Res.skeleton.attack_3._4.toTile(),
            ],
            flipTilesLeft([
                hxd.Res.skeleton.attack_3._1.toTile(),
                hxd.Res.skeleton.attack_3._2.toTile(),
                hxd.Res.skeleton.attack_3._3.toTile(),
                hxd.Res.skeleton.attack_3._4.toTile(),
            ], leftOffsetX)
        );

        animation.loadAttackRun(
            [
                hxd.Res.skeleton.attack_run._1.toTile(),
                hxd.Res.skeleton.attack_run._2.toTile(),
                hxd.Res.skeleton.attack_run._3.toTile(),
                hxd.Res.skeleton.attack_run._4.toTile(),
                hxd.Res.skeleton.attack_run._5.toTile(),
                hxd.Res.skeleton.attack_run._6.toTile(),
                hxd.Res.skeleton.attack_run._7.toTile(),
            ],
            flipTilesLeft([
                hxd.Res.skeleton.attack_run._1.toTile(),
                hxd.Res.skeleton.attack_run._2.toTile(),
                hxd.Res.skeleton.attack_run._3.toTile(),
                hxd.Res.skeleton.attack_run._4.toTile(),
                hxd.Res.skeleton.attack_run._5.toTile(),
                hxd.Res.skeleton.attack_run._6.toTile(),
                hxd.Res.skeleton.attack_run._7.toTile(),
            ], leftOffsetX)
        );

        return animation;
    }

    public static function LoadSkeletonArcherAnimation(parent:h2d.Object) {
        final animation = new EntityAnimation(parent);

        animation.loadIdle(
            [
                hxd.Res.skeleton_archer.idle._1.toTile(), 
                hxd.Res.skeleton_archer.idle._2.toTile(), 
                hxd.Res.skeleton_archer.idle._3.toTile(), 
                hxd.Res.skeleton_archer.idle._4.toTile(), 
                hxd.Res.skeleton_archer.idle._5.toTile(), 
                hxd.Res.skeleton_archer.idle._6.toTile(),
                hxd.Res.skeleton_archer.idle._7.toTile(),
            ],
            [
                hxd.Res.skeleton_archer.idle._1.toTile(), 
                hxd.Res.skeleton_archer.idle._2.toTile(), 
                hxd.Res.skeleton_archer.idle._3.toTile(), 
                hxd.Res.skeleton_archer.idle._4.toTile(), 
                hxd.Res.skeleton_archer.idle._5.toTile(), 
                hxd.Res.skeleton_archer.idle._6.toTile(),
                hxd.Res.skeleton_archer.idle._7.toTile(),
            ]
        );

        animation.loadWalk(
            [
                hxd.Res.skeleton_archer.walk._1.toTile(), 
                hxd.Res.skeleton_archer.walk._2.toTile(), 
                hxd.Res.skeleton_archer.walk._3.toTile(), 
                hxd.Res.skeleton_archer.walk._4.toTile(), 
                hxd.Res.skeleton_archer.walk._5.toTile(), 
                hxd.Res.skeleton_archer.walk._6.toTile(),
                hxd.Res.skeleton_archer.walk._7.toTile(),
                hxd.Res.skeleton_archer.walk._8.toTile(),
            ],
            [
                hxd.Res.skeleton_archer.walk._1.toTile(), 
                hxd.Res.skeleton_archer.walk._2.toTile(), 
                hxd.Res.skeleton_archer.walk._3.toTile(), 
                hxd.Res.skeleton_archer.walk._4.toTile(), 
                hxd.Res.skeleton_archer.walk._5.toTile(), 
                hxd.Res.skeleton_archer.walk._6.toTile(),
                hxd.Res.skeleton_archer.walk._7.toTile(),
                hxd.Res.skeleton_archer.walk._8.toTile(),
            ]
        );

        animation.loadDead(
            [
                hxd.Res.skeleton_archer.dead._1.toTile(),
                hxd.Res.skeleton_archer.dead._2.toTile(), 
                hxd.Res.skeleton_archer.dead._3.toTile(), 
                hxd.Res.skeleton_archer.dead._4.toTile(), 
                hxd.Res.skeleton_archer.dead._5.toTile(),
            ],
            [
                hxd.Res.skeleton_archer.dead._1.toTile(),
                hxd.Res.skeleton_archer.dead._2.toTile(), 
                hxd.Res.skeleton_archer.dead._3.toTile(), 
                hxd.Res.skeleton_archer.dead._4.toTile(), 
                hxd.Res.skeleton_archer.dead._5.toTile(),
            ]
        );

        animation.loadHurt(
            [
                hxd.Res.skeleton_archer.hurt._1.toTile(),
                hxd.Res.skeleton_archer.hurt._2.toTile(), 
            ],
            [
                hxd.Res.skeleton_archer.hurt._1.toTile(),
                hxd.Res.skeleton_archer.hurt._2.toTile(), 
            ]
        );

        animation.loadAttack1(
            [
                hxd.Res.skeleton_archer.attack_1._1.toTile(),
                hxd.Res.skeleton_archer.attack_1._2.toTile(),
                hxd.Res.skeleton_archer.attack_1._3.toTile(),
                hxd.Res.skeleton_archer.attack_1._4.toTile(),
                hxd.Res.skeleton_archer.attack_1._4.toTile(),
            ],
            [
                hxd.Res.skeleton_archer.attack_1._1.toTile(),
                hxd.Res.skeleton_archer.attack_1._2.toTile(),
                hxd.Res.skeleton_archer.attack_1._3.toTile(),
                hxd.Res.skeleton_archer.attack_1._4.toTile(),
                hxd.Res.skeleton_archer.attack_1._4.toTile(),
            ]
        );

        animation.loadAttack2(
            [
                hxd.Res.skeleton_archer.attack_2._1.toTile(),
                hxd.Res.skeleton_archer.attack_2._2.toTile(),
                hxd.Res.skeleton_archer.attack_2._3.toTile(),
                hxd.Res.skeleton_archer.attack_2._4.toTile(),
            ],
            [
                hxd.Res.skeleton_archer.attack_2._1.toTile(),
                hxd.Res.skeleton_archer.attack_2._2.toTile(),
                hxd.Res.skeleton_archer.attack_2._3.toTile(),
                hxd.Res.skeleton_archer.attack_2._4.toTile(),
            ]
        );

        animation.loadAttack3(
            [
                hxd.Res.skeleton_archer.attack_3._1.toTile(),
                hxd.Res.skeleton_archer.attack_3._2.toTile(),
                hxd.Res.skeleton_archer.attack_3._3.toTile(),
            ],
            [
                hxd.Res.skeleton_archer.attack_3._1.toTile(),
                hxd.Res.skeleton_archer.attack_3._2.toTile(),
                hxd.Res.skeleton_archer.attack_3._3.toTile(),
            ]
        );

        animation.loadDodge(
            [
                hxd.Res.skeleton_archer.dodge._1.toTile(),
                hxd.Res.skeleton_archer.dodge._2.toTile(),
                hxd.Res.skeleton_archer.dodge._3.toTile(),
                hxd.Res.skeleton_archer.dodge._4.toTile(),
                hxd.Res.skeleton_archer.dodge._5.toTile(),
                hxd.Res.skeleton_archer.dodge._6.toTile(),
            ],
            [
                hxd.Res.skeleton_archer.dodge._1.toTile(),
                hxd.Res.skeleton_archer.dodge._2.toTile(),
                hxd.Res.skeleton_archer.dodge._3.toTile(),
                hxd.Res.skeleton_archer.dodge._4.toTile(),
                hxd.Res.skeleton_archer.dodge._5.toTile(),
                hxd.Res.skeleton_archer.dodge._6.toTile(),
            ]
        );

        animation.loadShot1(
            [
                hxd.Res.skeleton_archer.shot_1._1.toTile(),
                hxd.Res.skeleton_archer.shot_1._2.toTile(),
                hxd.Res.skeleton_archer.shot_1._3.toTile(),
                hxd.Res.skeleton_archer.shot_1._4.toTile(),
                hxd.Res.skeleton_archer.shot_1._5.toTile(),
                hxd.Res.skeleton_archer.shot_1._6.toTile(),
                hxd.Res.skeleton_archer.shot_1._7.toTile(),
                hxd.Res.skeleton_archer.shot_1._8.toTile(),
                hxd.Res.skeleton_archer.shot_1._9.toTile(),
                hxd.Res.skeleton_archer.shot_1._10.toTile(),
                hxd.Res.skeleton_archer.shot_1._11.toTile(),
                hxd.Res.skeleton_archer.shot_1._12.toTile(),
                hxd.Res.skeleton_archer.shot_1._13.toTile(),
                hxd.Res.skeleton_archer.shot_1._14.toTile(),
                hxd.Res.skeleton_archer.shot_1._15.toTile(),
            ],
            [
                hxd.Res.skeleton_archer.shot_1._1.toTile(),
                hxd.Res.skeleton_archer.shot_1._2.toTile(),
                hxd.Res.skeleton_archer.shot_1._3.toTile(),
                hxd.Res.skeleton_archer.shot_1._4.toTile(),
                hxd.Res.skeleton_archer.shot_1._5.toTile(),
                hxd.Res.skeleton_archer.shot_1._6.toTile(),
                hxd.Res.skeleton_archer.shot_1._7.toTile(),
                hxd.Res.skeleton_archer.shot_1._8.toTile(),
                hxd.Res.skeleton_archer.shot_1._9.toTile(),
                hxd.Res.skeleton_archer.shot_1._10.toTile(),
                hxd.Res.skeleton_archer.shot_1._11.toTile(),
                hxd.Res.skeleton_archer.shot_1._12.toTile(),
                hxd.Res.skeleton_archer.shot_1._13.toTile(),
                hxd.Res.skeleton_archer.shot_1._14.toTile(),
                hxd.Res.skeleton_archer.shot_1._15.toTile(),
            ]
        );

        animation.loadShot2(
            [
                hxd.Res.skeleton_archer.shot_2._1.toTile(),
                hxd.Res.skeleton_archer.shot_2._2.toTile(),
                hxd.Res.skeleton_archer.shot_2._3.toTile(),
                hxd.Res.skeleton_archer.shot_2._4.toTile(),
                hxd.Res.skeleton_archer.shot_2._5.toTile(),
                hxd.Res.skeleton_archer.shot_2._6.toTile(),
                hxd.Res.skeleton_archer.shot_2._7.toTile(),
                hxd.Res.skeleton_archer.shot_2._8.toTile(),
                hxd.Res.skeleton_archer.shot_2._9.toTile(),
                hxd.Res.skeleton_archer.shot_2._10.toTile(),
                hxd.Res.skeleton_archer.shot_2._11.toTile(),
                hxd.Res.skeleton_archer.shot_2._12.toTile(),
                hxd.Res.skeleton_archer.shot_2._13.toTile(),
                hxd.Res.skeleton_archer.shot_2._14.toTile(),
                hxd.Res.skeleton_archer.shot_2._15.toTile(),
            ],
            [
                hxd.Res.skeleton_archer.shot_2._1.toTile(),
                hxd.Res.skeleton_archer.shot_2._2.toTile(),
                hxd.Res.skeleton_archer.shot_2._3.toTile(),
                hxd.Res.skeleton_archer.shot_2._4.toTile(),
                hxd.Res.skeleton_archer.shot_2._5.toTile(),
                hxd.Res.skeleton_archer.shot_2._6.toTile(),
                hxd.Res.skeleton_archer.shot_2._7.toTile(),
                hxd.Res.skeleton_archer.shot_2._8.toTile(),
                hxd.Res.skeleton_archer.shot_2._9.toTile(),
                hxd.Res.skeleton_archer.shot_2._10.toTile(),
                hxd.Res.skeleton_archer.shot_2._11.toTile(),
                hxd.Res.skeleton_archer.shot_2._12.toTile(),
                hxd.Res.skeleton_archer.shot_2._13.toTile(),
                hxd.Res.skeleton_archer.shot_2._14.toTile(),
                hxd.Res.skeleton_archer.shot_2._15.toTile(),
            ]
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