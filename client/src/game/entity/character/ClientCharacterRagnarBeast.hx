package game.entity.character;

import game.tilemap.TilemapManager;
import engine.base.types.TypesBaseEntity.Side;
import engine.base.entity.impl.EngineCharacterEntity;
import engine.base.geometry.Rectangle;
import engine.seidh.types.TypesSeidhEntity.CharacterAnimationState;

import game.scene.impl.game.GameScene;
import game.sound.SoundManager;

class ClientCharacterRagnarBeast extends ClientCharacterEntity {
    private final bloodSpawnDelay = 50;

    public function new(s2d:h2d.Scene, engineEntity:EngineCharacterEntity) {
        super(s2d, engineEntity);

        // final bloodTrailAnimation = new h2d.Anim(this);
        // bloodTrailAnimation.setScale(1.3);
        // final animationToPlay = new Array<h2d.Tile>();

        // animationToPlay.push(TilemapManager.instance.getTile(TileType.BLOOD_3));
        // animationToPlay.push(TilemapManager.instance.getTile(TileType.BLOOD_4));
        // animationToPlay.push(TilemapManager.instance.getTile(TileType.BLOOD_5));

        // bloodTrailAnimation.play(animationToPlay);
        // bloodTrailAnimation.setPosition(0, 120);

        function fxDelay() {
            haxe.Timer.delay(function delay() {
                if (engineEntity.isAlive && animation.getAnimationState() == CharacterAnimationState.RUN) {
                    // bloodTrailAnimation.pause = true;
                    // bloodTrailAnimation.alpha = 0;
                    GameScene.FxManager.bloodTrail(getSide() == Side.RIGHT ? x - 60 : x + 60, y + 120);
                } else {
                    // bloodTrailAnimation.pause = false;
                    // bloodTrailAnimation.alpha = 1;
                }
                fxDelay();
            }, bloodSpawnDelay);
        }
        fxDelay();
    }

    // ------------------------------------------------
    // Abstract implemenation
    // ------------------------------------------------

    public function fxDeath() {
        SoundManager.instance.playVikingDeath();
        animation.setAnimationState(DEATH);
    }

    public function getRect() {
        return new Rectangle(x, y, 221, 285, 0);
    }

    public function getBottomRect() {
        return new Rectangle(x, y + 215 / 2, 221, 40, 0);
    }

    // ------------------------------------------------
    // Overload
    // ------------------------------------------------

    public override function update(dt:Float, fps:Float) {
        super.update(dt, fps);

 
    }
}