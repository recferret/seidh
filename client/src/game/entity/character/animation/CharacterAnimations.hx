package game.entity.character.animation;

import engine.base.MathUtils;
import h2d.Anim;
import h2d.Tile;

import engine.base.types.TypesBaseEntity;
import engine.seidh.types.TypesSeidhEntity;

import game.event.EventManager;
import game.Res.SeidhResource;

class CharacterAnimation {
    private var idleAnim:Array<Tile> = [];
    private var runAnim:Array<Tile> = [];
    private var deathAnim:Array<Tile> = [];
    private var spawnAnim:Array<Tile> = [];
    private var spawn2Anim:Array<Tile> = [];
    private var actionMainAnim:Array<Tile> = [];
    private var action1Anim:Array<Tile> = [];
    private var action2Anim:Array<Tile> = [];

    private var reversedAnimation:CharacterAnimationState;

    private var idleAnimSide = Side.RIGHT;
    private var runAnimSide = Side.RIGHT;
    private var actionMainAnimSide = Side.RIGHT;

    private var animation:Anim;
    private var characterAnimationState:CharacterAnimationState;
    private var side = Side.RIGHT;

    public var enableMoveAnimation = true;

    private var defaultAnimationSpeed = 10;
    private var runAnimationSpeed = 10;

    public function new(parent:h2d.Object, characterId:String) {
        animation = new h2d.Anim(parent);
        animation.speed = defaultAnimationSpeed;

        animation.onAnimEnd = function callback() {
            if (reversedAnimation != null) {
                switch (reversedAnimation) {
                    case ACTION_2:
                        action2Anim.reverse();
                    default:
                }

                reversedAnimation = null;
            }

            if (characterAnimationState != DEATH && characterAnimationState != RUN && characterAnimationState != IDLE) {
                if (characterAnimationState != RUN) {
                    enableMoveAnimation = true;
                    setAnimationState(CharacterAnimationState.IDLE, false);
                }
            } else {
                EventManager.instance.notify(EventManager.EVENT_CHARACTER_DEATH_ANIM_END, characterId);
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
                for (value in animationToPlay) {
                    value.flipX();
                }
            }

            flipTilesHorizontally(idleAnim);
            flipTilesHorizontally(runAnim);
            flipTilesHorizontally(deathAnim);
            flipTilesHorizontally(spawnAnim);
            flipTilesHorizontally(actionMainAnim);
            flipTilesHorizontally(action1Anim);
            flipTilesHorizontally(action2Anim);
        }
    }

    public function setAnimationState(newState:CharacterAnimationState, reverse:Bool = false) {
        if (newState != characterAnimationState) {
            characterAnimationState = newState;
            hideAnimations();

            var animationToPlay:Array<Tile>;
            var atFrame = 0;

            switch (newState) {
                case IDLE:
                    enableMoveAnimation = true;
                    animationToPlay = idleAnim;
                    animation.loop = true;
                    animation.speed = defaultAnimationSpeed;
                case RUN:
                    enableMoveAnimation = true;
                    animationToPlay = runAnim;
                    atFrame = MathUtils.randomIntInRange(0, animation.frames.length);

                    animation.loop = true;
                    animation.speed = runAnimationSpeed;
                case DEATH:
                    enableMoveAnimation = false;
                    animationToPlay = deathAnim;
                    animation.loop = false;
                    animation.speed = defaultAnimationSpeed;
                case SPAWN:
                    enableMoveAnimation = false;
                    animationToPlay = spawnAnim;
                    animation.loop = false;
                    animation.speed = defaultAnimationSpeed;
                case SPAWN_2:
                    enableMoveAnimation = false;
                    animationToPlay = spawn2Anim;
                    animation.loop = false;
                    animation.speed = defaultAnimationSpeed;
                case ACTION_MAIN:
                    enableMoveAnimation = false;
                    animationToPlay = actionMainAnim;
                    animation.loop = false;
                    animation.speed = defaultAnimationSpeed;
                case ACTION_1:
                    enableMoveAnimation = false;
                    animationToPlay = action1Anim;
                    animation.loop = false;
                    animation.speed = defaultAnimationSpeed;
                case ACTION_2:
                    if (reverse) {
                        reversedAnimation = ACTION_2;
                        action2Anim.reverse();
                    }

                    enableMoveAnimation = false;
                    animationToPlay = action2Anim;
                    animation.loop = false;
                    animation.speed = defaultAnimationSpeed;
                default:
                    enableMoveAnimation = true;
                    animationToPlay = idleAnim;
                    animation.loop = true;
                    animation.speed = defaultAnimationSpeed;
            }

            animation.play(animationToPlay, atFrame);
        }
    }

    // Load tiles

    public function loadIdle(tiles:Array<Tile>) {
        idleAnim = tiles;
    }

    public function loadRun(tiles:Array<Tile>) {
        runAnim = tiles;
    }

    public function loadDeath(tiles:Array<Tile>) {
        deathAnim = tiles;
    }

    public function loadSpawn(tiles:Array<Tile>) {
        spawnAnim = tiles;
    }

    public function loadSpawn2(tiles:Array<Tile>) {
        spawn2Anim = tiles;
    }

    public function loadActionMain(tiles:Array<Tile>) {
        actionMainAnim = tiles;
    }

    public function loadAction1(tiles:Array<Tile>) {
        action1Anim = tiles;
    }

    public function loadAction2(tiles:Array<Tile>) {
        action2Anim = tiles;
    }

}

class CharacterAnimations {

    public static function LoadCharacterAnimation(parent:h2d.Object, characterId:String, entrityType:EntityType) {
        final animation = new CharacterAnimation(parent, characterId);

        var th = 332;
        var tw = 332;

        var idleTile:h2d.Tile = null;
        var runTile:h2d.Tile = null;
        var deathTile:h2d.Tile = null;
        var spawnTile:h2d.Tile = null;
        var actionMainTile:h2d.Tile = null;
        var action1Tile:h2d.Tile = null;
        var action2Tile:h2d.Tile = null;

        switch (entrityType) {
            case EntityType.RAGNAR_LOH:
                idleTile = Res.instance.getTileResource(SeidhResource.RAGNAR_IDLE);
                runTile = Res.instance.getTileResource(SeidhResource.RAGNAR_RUN);
                deathTile = Res.instance.getTileResource(SeidhResource.RAGNAR_DEATH);
                actionMainTile = Res.instance.getTileResource(SeidhResource.RAGNAR_ATTACK);
            case EntityType.ZOMBIE_BOY:
                idleTile = Res.instance.getTileResource(SeidhResource.ZOMBIE_BOY_IDLE);
                runTile = Res.instance.getTileResource(SeidhResource.ZOMBIE_BOY_RUN);
                deathTile = Res.instance.getTileResource(SeidhResource.ZOMBIE_BOY_DEATH);
                spawnTile = Res.instance.getTileResource(SeidhResource.ZOMBIE_BOY_SPAWN);
                actionMainTile = Res.instance.getTileResource(SeidhResource.ZOMBIE_BOY_ATTACK);
            case EntityType.ZOMBIE_GIRL:
                idleTile = Res.instance.getTileResource(SeidhResource.ZOMBIE_GIRL_IDLE);
                runTile = Res.instance.getTileResource(SeidhResource.ZOMBIE_GIRL_RUN);
                deathTile = Res.instance.getTileResource(SeidhResource.ZOMBIE_GIRL_DEATH);
                spawnTile = Res.instance.getTileResource(SeidhResource.ZOMBIE_GIRL_SPAWN);
                actionMainTile = Res.instance.getTileResource(SeidhResource.ZOMBIE_GIRL_ATTACK);
            case EntityType.GLAMR:
                th = 500;
                tw = 500;
                idleTile = Res.instance.getTileResource(SeidhResource.GLAMR_IDLE);
                runTile = Res.instance.getTileResource(SeidhResource.GLAMR_FLY);
                deathTile = Res.instance.getTileResource(SeidhResource.GLAMR_DEATH);
                spawnTile = Res.instance.getTileResource(SeidhResource.GLAMR_SPAWN);
                actionMainTile = Res.instance.getTileResource(SeidhResource.GLAMR_EYE_ATTACK);
                action1Tile = Res.instance.getTileResource(SeidhResource.GLAMR_HAIL);
                action2Tile = Res.instance.getTileResource(SeidhResource.GLAMR_SPAWN_2);
            default:
        }

        final idleTiles = [];
        for(x in 0 ... Std.int(idleTile.width / tw)) {
            final tile = idleTile.sub(x * tw, 0, tw, th).center();
            if (entrityType == EntityType.RAGNAR_LOH) {
                tile.dx += 30;
            }
            idleTiles.push(tile);
        }
        animation.loadIdle(idleTiles);

        final runTiles = [
            for(x in 0 ... Std.int(runTile.width / tw))
                runTile.sub(x * tw, 0, tw, th).center()
        ];
        animation.loadRun(runTiles);

        if (spawnTile != null) {
            final spawnTiles = [
                for(x in 0 ... Std.int(spawnTile.width / tw))
                    spawnTile.sub(x * tw, 0, tw, th).center()
            ];
            animation.loadSpawn(spawnTiles);
        }

        final deathTiles = [
            for(x in 0 ... Std.int(deathTile.width / tw))
                deathTile.sub(x * tw, 0, tw, th).center()
        ];
        animation.loadDeath(deathTiles);

        final actionMainTiles = [
            for(x in 0 ... Std.int(actionMainTile.width / tw))
                actionMainTile.sub(x * tw, 0, tw, th).center()
        ];
        animation.loadActionMain(actionMainTiles);

        if (action1Tile != null) {
            final actionTiles = [
                for(x in 0 ... Std.int(action1Tile.width / tw))
                    action1Tile.sub(x * tw, 0, tw, th).center()
            ];
            animation.loadAction1(actionTiles);
        }

        if (action2Tile != null) {
            final action2Tiles = [
                for(x in 0 ... Std.int(action2Tile.width / tw))
                    action2Tile.sub(x * tw, 0, tw, th).center()
            ];
            animation.loadAction2(action2Tiles);
        }

        return animation;
    }

}