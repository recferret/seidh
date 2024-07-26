package game.entity.character.animation;

import h2d.Anim;
import h2d.Tile;

import engine.base.BaseTypesAndClasses.CharacterAnimationState;
import engine.base.BaseTypesAndClasses.Side;

import game.Res.SeidhResource;

class CharacterAnimation {
    private var idleAnim:Array<Tile>;
    private var runAnim:Array<Tile>;
	private var walkAnim:Array<Tile>;
    private var deadAnim:Array<Tile>;
    private var hurtAnim:Array<Tile>;
    private var attack1Anim:Array<Tile>;
    private var attack2Anim:Array<Tile>;
    private var attack3Anim:Array<Tile>;
    private var attackRunAnim:Array<Tile>;
    private var shot1Anim:Array<Tile>;
    private var shot2Anim:Array<Tile>;
    private var defendAnim:Array<Tile>;
    private var dodgeAnim:Array<Tile>;

    private var idleAnimSide = Side.RIGHT;

    private var animation:Anim;
    private var characterAnimationState:CharacterAnimationState;
    private var side = Side.RIGHT;
    private var sideChanged = false;

    public var enableMoveAnimation = true;

    public function new(parent:h2d.Object) {
        animation = new h2d.Anim(parent);
        animation.speed = 10;

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
            characterAnimationState = newState;
            hideAnimations();

            var animationToPlay:Array<Tile>;

            function flipTilesHorizontally(animationToPlay:Array<Tile>) {
                sideChanged = false;
                for (index => value in animationToPlay) {
                    value.flipX();
                }
            }

            switch (newState) {
                case IDLE:
                    if (side != idleAnimSide) {
                        flipTilesHorizontally(idleAnim);
                        idleAnimSide = side;
                    }
                    enableMoveAnimation = true;
                    animation.loop = true;
                    animationToPlay = idleAnim;
                case RUN:
                    if (sideChanged) {
                        flipTilesHorizontally(runAnim);
                    }
                    enableMoveAnimation = true;
                    animation.loop = true;
                    animationToPlay = runAnim;
                case WALK:
                    if (sideChanged) {
                        flipTilesHorizontally(walkAnim);
                    }
                    enableMoveAnimation = true;
                    animation.loop = true;
                    animationToPlay = walkAnim;
                case DEAD:
                    if (sideChanged) {
                        flipTilesHorizontally(deadAnim);
                    }
                    enableMoveAnimation = false;
                    animation.loop = false;
                    animationToPlay = deadAnim;
                case HURT:
                    if (sideChanged) {
                        flipTilesHorizontally(hurtAnim);
                    }
                    animation.loop = false;
                    animationToPlay = hurtAnim;
                case ATTACK_1:
                    if (sideChanged) {
                        flipTilesHorizontally(attack1Anim);
                    }
                    enableMoveAnimation = false;
                    animation.loop = false;
                    animationToPlay = attack1Anim;
                case ATTACK_2:
                    if (sideChanged) {
                        flipTilesHorizontally(attack2Anim);
                    }
                    enableMoveAnimation = false;
                    animation.loop = false;
                    animationToPlay = attack2Anim;
                case ATTACK_3:
                    if (sideChanged) {
                        flipTilesHorizontally(attack3Anim);
                    }
                    enableMoveAnimation = false;
                    animation.loop = false;
                    animationToPlay = attack3Anim;
                case ATTACK_RUN:
                    if (sideChanged) {
                        flipTilesHorizontally(attackRunAnim);
                    }
                    enableMoveAnimation = false;
                    animation.loop = false;    
                    animationToPlay = attackRunAnim;
                case SHOT_1:
                    if (sideChanged) {
                        flipTilesHorizontally(shot1Anim);
                    }
                    enableMoveAnimation = false;
                    animation.loop = false;
                    animationToPlay = shot1Anim;
                case SHOT_2:
                    if (sideChanged) {
                        flipTilesHorizontally(shot2Anim);
                    }
                    enableMoveAnimation = false;
                    animation.loop = false;
                    animationToPlay = shot2Anim; 
                case DEFEND:
                    if (sideChanged) {
                        flipTilesHorizontally(defendAnim);
                    }
                    enableMoveAnimation = false;
                    animation.loop = false;
                    animationToPlay = defendAnim; 
                case DODGE:
                    if (sideChanged) {
                        flipTilesHorizontally(dodgeAnim);
                    }
                    animation.loop = false;
                    animationToPlay = dodgeAnim; 
                default:
                    if (side != idleAnimSide) {
                        flipTilesHorizontally(idleAnim);
                        idleAnimSide = side;
                    }
                    enableMoveAnimation = true;
                    animation.loop = true;
                    animationToPlay = idleAnim;
            }

            animation.play(animationToPlay);
        }
    }

    // Load tiles

    public function loadIdle(tiles:Array<Tile>) {
        idleAnim = tiles;
    }

    public function loadRun(tiles:Array<Tile>) {
        runAnim = tiles;
    }

    public function loadWalk(tiles:Array<Tile>) {
        walkAnim = tiles;
    }

    public function loadDead(tiles:Array<Tile>) {
        deadAnim = tiles;
    }

    public function loadHurt(tiles:Array<Tile>) {
        hurtAnim = tiles;
    }

    public function loadAttack1(tiles:Array<Tile>) {
        attack1Anim = tiles;
    }

    public function loadAttack2(tiles:Array<Tile>) {
        attack2Anim = tiles;
    }

    public function loadAttack3(tiles:Array<Tile>) {
        attack3Anim = tiles;
    }

    public function loadAttackRun(tiles:Array<Tile>) {
        attackRunAnim = tiles;
    }

    public function loadShot1(tiles:Array<Tile>) {
        shot1Anim = tiles;
    }

    public function loadShot2(tiles:Array<Tile>) {
        shot2Anim = tiles;
    }

    public function loadDefend(tiles:Array<Tile>) {
        defendAnim = tiles;
    }

    public function loadDodge(tiles:Array<Tile>) {
        dodgeAnim = tiles;
    }
}

class CharacterAnimations {

    public static function LoadRagnarLohAnimation(parent:h2d.Object) {
        final animation = new CharacterAnimation(parent);

        animation.loadIdle(
            [
                Res.instance.getTileResource(SeidhResource.RAGNAR_IDLE_1),
                Res.instance.getTileResource(SeidhResource.RAGNAR_IDLE_2),
                Res.instance.getTileResource(SeidhResource.RAGNAR_IDLE_3),
                Res.instance.getTileResource(SeidhResource.RAGNAR_IDLE_4),
            ],
        );

        animation.loadRun(
            [
                Res.instance.getTileResource(SeidhResource.RAGNAR_RUN_1),
                Res.instance.getTileResource(SeidhResource.RAGNAR_RUN_2),
                Res.instance.getTileResource(SeidhResource.RAGNAR_RUN_3),
                Res.instance.getTileResource(SeidhResource.RAGNAR_RUN_4),
                Res.instance.getTileResource(SeidhResource.RAGNAR_RUN_5),
                Res.instance.getTileResource(SeidhResource.RAGNAR_RUN_6),
            ],
        );

        animation.loadWalk(
            [
                Res.instance.getTileResource(SeidhResource.RAGNAR_BASE),
            ],
        );

        animation.loadDead(
            [
                Res.instance.getTileResource(SeidhResource.RAGNAR_BASE),
            ],
        );

        animation.loadHurt(
            [
                Res.instance.getTileResource(SeidhResource.RAGNAR_BASE),
            ],
        );

        animation.loadAttack1(
            [
                Res.instance.getTileResource(SeidhResource.RAGNAR_BASE),
            ],
        );

        animation.loadAttack2(
            [
                Res.instance.getTileResource(SeidhResource.RAGNAR_BASE),
            ],
        );

        animation.loadAttack3(
            [
                Res.instance.getTileResource(SeidhResource.RAGNAR_BASE),
            ],
        );

        animation.loadAttackRun(
            [
                Res.instance.getTileResource(SeidhResource.RAGNAR_BASE),
            ],
        );

        animation.loadDefend(
            [
                Res.instance.getTileResource(SeidhResource.RAGNAR_BASE),
            ],
        );

        return animation;
    }

    public static function LoadRagnarNormAnimation(parent:h2d.Object) {
        final animation = new CharacterAnimation(parent);

        animation.loadIdle(
            [
                Res.instance.getTileResource(SeidhResource.RAGNAR_BASE),
            ]
        );

        animation.loadRun(
            [
                Res.instance.getTileResource(SeidhResource.RAGNAR_BASE),
            ]
        );

        animation.loadWalk(
            [
                Res.instance.getTileResource(SeidhResource.RAGNAR_BASE),
            ]
        );

        animation.loadDead(
            [
                Res.instance.getTileResource(SeidhResource.RAGNAR_BASE),
            ]
        );

        animation.loadHurt(
            [
                Res.instance.getTileResource(SeidhResource.RAGNAR_BASE),
            ]
        );

        animation.loadAttack1(
            [
                Res.instance.getTileResource(SeidhResource.RAGNAR_BASE),
            ]
        );

        animation.loadAttack2(
            [
                Res.instance.getTileResource(SeidhResource.RAGNAR_BASE),
            ]
        );

        animation.loadAttack3(
            [
                Res.instance.getTileResource(SeidhResource.RAGNAR_BASE),
            ]
        );

        animation.loadAttackRun(
            [
                Res.instance.getTileResource(SeidhResource.RAGNAR_BASE),
            ]
        );

        animation.loadDefend(
            [
                Res.instance.getTileResource(SeidhResource.RAGNAR_BASE),
            ]
        );

        return animation;
    }
    
    public static function LoadZombieBoyAnimation(parent:h2d.Object) {
        final animation = new CharacterAnimation(parent);

        animation.loadIdle(
            [
                Res.instance.getTileResource(SeidhResource.ZOMBIE_BOY),
            ]
        );

        animation.loadRun(
            [
                Res.instance.getTileResource(SeidhResource.ZOMBIE_BOY),
            ]
        );

        animation.loadWalk(
            [
                Res.instance.getTileResource(SeidhResource.ZOMBIE_BOY),
            ]
        );

        animation.loadDead(
            [
                Res.instance.getTileResource(SeidhResource.ZOMBIE_BOY),
            ]
        );

        animation.loadHurt(
            [
                Res.instance.getTileResource(SeidhResource.ZOMBIE_BOY),
            ]
        );

        animation.loadAttack1(
            [
                Res.instance.getTileResource(SeidhResource.ZOMBIE_BOY),
            ]
        );

        animation.loadAttack2(
            [
                Res.instance.getTileResource(SeidhResource.ZOMBIE_BOY),
            ]
        );

        animation.loadAttack3(
            [
                Res.instance.getTileResource(SeidhResource.ZOMBIE_BOY),
            ]
        );

        animation.loadAttackRun(
            [
                Res.instance.getTileResource(SeidhResource.ZOMBIE_BOY),
            ]
        );

        animation.loadDefend(
            [
                Res.instance.getTileResource(SeidhResource.ZOMBIE_BOY),
            ]
        );

        return animation;
    }

    public static function LoadZombieGirlAnimation(parent:h2d.Object) {
        final animation = new CharacterAnimation(parent);

        animation.loadIdle(
            [
                Res.instance.getTileResource(SeidhResource.ZOMBIE_GIRL),
            ]
        );

        animation.loadRun(
            [
                Res.instance.getTileResource(SeidhResource.ZOMBIE_GIRL),
            ]
        );

        animation.loadWalk(
            [
                Res.instance.getTileResource(SeidhResource.ZOMBIE_GIRL),
            ]
        );

        animation.loadDead(
            [
                Res.instance.getTileResource(SeidhResource.ZOMBIE_GIRL),
            ]
        );

        animation.loadHurt(
            [
                Res.instance.getTileResource(SeidhResource.ZOMBIE_GIRL),
            ]
        );

        animation.loadAttack1(
            [
                Res.instance.getTileResource(SeidhResource.ZOMBIE_GIRL),
            ]
        );

        animation.loadAttack2(
            [
                Res.instance.getTileResource(SeidhResource.ZOMBIE_GIRL),
            ]
        );

        animation.loadAttack3(
            [
                Res.instance.getTileResource(SeidhResource.ZOMBIE_GIRL),
            ]
        );

        animation.loadAttackRun(
            [
                Res.instance.getTileResource(SeidhResource.ZOMBIE_GIRL),
            ]
        );

        animation.loadDefend(
            [
                Res.instance.getTileResource(SeidhResource.ZOMBIE_GIRL),
            ]
        );

        return animation;
    }

}