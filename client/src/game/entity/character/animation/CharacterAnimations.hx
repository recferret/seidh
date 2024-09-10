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
    private var actionMainAnim:Array<Tile>;
    private var defendAnim:Array<Tile>;
    private var dodgeAnim:Array<Tile>;

    private var idleAnimSide = Side.RIGHT;
    private var runAnimSide = Side.RIGHT;
    private var actionMainAnimSide = Side.RIGHT;

    private var animation:Anim;
    private var characterAnimationState:CharacterAnimationState;
    private var side = Side.RIGHT;

    public var enableMoveAnimation = true;

    private var defaultAnimationSpeed = 10;
    private var runAnimationSpeed = 10;

    public function new(parent:h2d.Object) {
        animation = new h2d.Anim(parent);
        animation.speed = defaultAnimationSpeed;

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

    public function getAnimationState() {
        return characterAnimationState;
    }

    public function setAnimationSpeed(speed:Int) {
        defaultAnimationSpeed = speed;
    }

    public function setRunAnimationSpeed(speed:Int) {
        runAnimationSpeed = speed;
    }

    public function setSide(side:Side) {
        if (this.side != side) {
            this.side = side;

            function flipTilesHorizontally(animationToPlay:Array<Tile>) {
                for (index => value in animationToPlay) {
                    value.flipX();
                }
            }

            flipTilesHorizontally(idleAnim);
            flipTilesHorizontally(runAnim);
            flipTilesHorizontally(actionMainAnim);
        }
    }

    public function setAnimationState(newState:CharacterAnimationState) {
        if (newState != characterAnimationState) {
            characterAnimationState = newState;
            hideAnimations();

            var animationToPlay:Array<Tile>;

            switch (newState) {
                case IDLE:
                    enableMoveAnimation = true;
                    animation.loop = true;
                    animationToPlay = idleAnim;
                    animation.speed = defaultAnimationSpeed;
                case RUN:
                    enableMoveAnimation = true;
                    animation.loop = true;
                    animationToPlay = runAnim;
                    animation.speed = runAnimationSpeed;
                case WALK:
                    enableMoveAnimation = true;
                    animation.loop = true;
                    animationToPlay = walkAnim;
                    animation.speed = defaultAnimationSpeed;
                case DEAD:
                    enableMoveAnimation = false;
                    animation.loop = false;
                    animationToPlay = deadAnim;
                    animation.speed = defaultAnimationSpeed;
                case HURT:
                    animation.loop = false;
                    animationToPlay = hurtAnim;
                    animation.speed = defaultAnimationSpeed;
                case ACTION_MAIN:
                    enableMoveAnimation = false;
                    animation.loop = false;
                    animationToPlay = actionMainAnim;
                    animation.speed = defaultAnimationSpeed;
                case DEFEND:
                    enableMoveAnimation = false;
                    animation.loop = false;
                    animationToPlay = defendAnim;
                    animation.speed = defaultAnimationSpeed;
                case DODGE:
                    animation.loop = false;
                    animationToPlay = dodgeAnim;
                    animation.speed = defaultAnimationSpeed;
                default:
                    enableMoveAnimation = true;
                    animation.loop = true;
                    animationToPlay = idleAnim;
                    animation.speed = defaultAnimationSpeed;
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

    public function loadActionMain(tiles:Array<Tile>) {
        actionMainAnim = tiles;
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

        animation.loadActionMain(
            [
                Res.instance.getTileResource(SeidhResource.RAGNAR_ATTACK_1),
                Res.instance.getTileResource(SeidhResource.RAGNAR_ATTACK_2),
                Res.instance.getTileResource(SeidhResource.RAGNAR_ATTACK_3),
                Res.instance.getTileResource(SeidhResource.RAGNAR_ATTACK_4),
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

        animation.loadActionMain(
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
                Res.instance.getTileResource(SeidhResource.ZOMBIE_BOY_IDLE_1),
                Res.instance.getTileResource(SeidhResource.ZOMBIE_BOY_IDLE_2),
                Res.instance.getTileResource(SeidhResource.ZOMBIE_BOY_IDLE_3),
                Res.instance.getTileResource(SeidhResource.ZOMBIE_BOY_IDLE_4),
            ]
        );

        animation.loadRun(
            [
                Res.instance.getTileResource(SeidhResource.ZOMBIE_BOY_RUN_1),
                Res.instance.getTileResource(SeidhResource.ZOMBIE_BOY_RUN_2),
                Res.instance.getTileResource(SeidhResource.ZOMBIE_BOY_RUN_3),
                Res.instance.getTileResource(SeidhResource.ZOMBIE_BOY_RUN_4),
                Res.instance.getTileResource(SeidhResource.ZOMBIE_BOY_RUN_5),
                Res.instance.getTileResource(SeidhResource.ZOMBIE_BOY_RUN_6),
            ]
        );

        animation.loadWalk(
            [
                Res.instance.getTileResource(SeidhResource.ZOMBIE_BOY_IDLE_1),
            ]
        );

        animation.loadDead(
            [
                Res.instance.getTileResource(SeidhResource.ZOMBIE_BOY_IDLE_1),
            ]
        );

        animation.loadHurt(
            [
                Res.instance.getTileResource(SeidhResource.ZOMBIE_BOY_IDLE_1),
            ]
        );

        animation.loadActionMain(
            [
                Res.instance.getTileResource(SeidhResource.ZOMBIE_BOY_ATTACK_1),
                Res.instance.getTileResource(SeidhResource.ZOMBIE_BOY_ATTACK_2),
                Res.instance.getTileResource(SeidhResource.ZOMBIE_BOY_ATTACK_3),
                Res.instance.getTileResource(SeidhResource.ZOMBIE_BOY_ATTACK_4),
            ]
        );

        animation.loadDefend(
            [
                Res.instance.getTileResource(SeidhResource.ZOMBIE_BOY_IDLE_1),
            ]
        );

        return animation;
    }

    public static function LoadZombieGirlAnimation(parent:h2d.Object) {
        final animation = new CharacterAnimation(parent);

        animation.loadIdle(
            [
                Res.instance.getTileResource(SeidhResource.ZOMBIE_GIRL_IDLE_1),
            ]
        );

        animation.loadRun(
            [
                Res.instance.getTileResource(SeidhResource.ZOMBIE_GIRL_RUN_1),
                Res.instance.getTileResource(SeidhResource.ZOMBIE_GIRL_RUN_2),
                Res.instance.getTileResource(SeidhResource.ZOMBIE_GIRL_RUN_3),
                Res.instance.getTileResource(SeidhResource.ZOMBIE_GIRL_RUN_4),
                Res.instance.getTileResource(SeidhResource.ZOMBIE_GIRL_RUN_5),
                Res.instance.getTileResource(SeidhResource.ZOMBIE_GIRL_RUN_6),
            ]
        );

        animation.loadWalk(
            [
                Res.instance.getTileResource(SeidhResource.ZOMBIE_GIRL_IDLE_1),
            ]
        );

        animation.loadDead(
            [
                Res.instance.getTileResource(SeidhResource.ZOMBIE_GIRL_IDLE_1),
            ]
        );

        animation.loadHurt(
            [
                Res.instance.getTileResource(SeidhResource.ZOMBIE_GIRL_IDLE_1),
            ]
        );

        animation.loadActionMain(
            [
                Res.instance.getTileResource(SeidhResource.ZOMBIE_GIRL_ATTACK_1),
                Res.instance.getTileResource(SeidhResource.ZOMBIE_GIRL_ATTACK_2),
                Res.instance.getTileResource(SeidhResource.ZOMBIE_GIRL_ATTACK_3),
                Res.instance.getTileResource(SeidhResource.ZOMBIE_GIRL_ATTACK_4),
            ]
        );

        animation.loadDefend(
            [
                Res.instance.getTileResource(SeidhResource.ZOMBIE_GIRL_IDLE_1),
            ]
        );

        return animation;
    }

}