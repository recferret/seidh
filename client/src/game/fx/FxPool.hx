package game.fx;

import motion.Actuate;

import engine.base.MathUtils;
import engine.base.types.TypesBaseEntity.EntityType;
import engine.base.types.TypesBaseEntity.Side;

import game.fx.effects.FxTilesAnimation;
import game.ui.text.TextUtils;
import game.Res.SeidhResource;

enum abstract PoolItemType(Int) {
	var RAGNAR_GROUND_ATTACK = 1;
	var DAMAGE_TEXT = 2;
	var ZOMBIE_BLOOD = 3;
}

class FxPool {

    private var s2d:h2d.Scene;

    private final ragnarGroundAttackObjectsTotal = 5;
    private var ragnarGroundAttackObjectsNextIndex = 0;

    private final glamrEyeExplosionObjectsTotal = 1;
    private var glamrEyeExplosionObjectsNextIndex = 0;

    private final floatingTweenTextObjectsTotal = 30;
    private var floatingTweenTextObjectsNextIndex = 0;

    private final zombieBoyRemainsTotal = 50;
    private final zombieGirlRemainsTotal = 50;
    private var zombieBoyRemainsNextIndex = 0;
    private var zombieGirlRemainsNextIndex = 0;

    private var ragnarGroundAttackObjects = new Array<h2d.Object>();
    private var floatingTweenTextObjects = new Array<h2d.Object>();
    private var zombieBloodObjects1 = new Array<h2d.Object>();
    private var zombieBloodObjects2 = new Array<h2d.Object>();
    private var glamrEyeExplosionObjects = new Array<h2d.Object>();

    public function new(s2d:h2d.Scene) {
        final impactTile = Res.instance.getTileResource(SeidhResource.FX_IMPACT);
        final impactTiles = [
            for(x in 0 ... Std.int(impactTile.width / 332))
                impactTile.sub(x * 332, 0, 332, 332).center()
        ];
        for (i in 0...ragnarGroundAttackObjectsTotal) {
            final object = new FxTilesAnimation(impactTiles, 1.5);
            s2d.addChildAt(object, 99);

            ragnarGroundAttackObjects.push(object);
        }

        final glamrEyeExpTile = Res.instance.getTileResource(SeidhResource.FX_GLAMR_EYE_EXP);
        final glamrEyeExpTiles = [
            for(x in 0 ... Std.int(glamrEyeExpTile.width / 500))
                glamrEyeExpTile.sub(x * 500, 0, 500, 500).center()
        ];
        for (i in 0...glamrEyeExplosionObjectsTotal) {
            final object = new FxTilesAnimation(glamrEyeExpTiles, 1);
            s2d.add(object, 99);
            object.zOrder = 99;

            glamrEyeExplosionObjects.push(object);
        }

        for (i in 0...floatingTweenTextObjectsTotal) {
            final object = TextUtils.GetDefaultTextObject(0, 0, 5.5, Center, GameClientConfig.DefaultFontColor);
            object.alpha = 0;
            object.zOrder = 99;
            s2d.addChildAt(object, 99);

            floatingTweenTextObjects.push(object);
        }

        for (i in 0...zombieBoyRemainsTotal) {
            final object = new h2d.Bitmap(Res.instance.getTileResource(SeidhResource.FX_ZOMBIE_BLOOD_1).center());
            object.alpha = 0;
            s2d.addChildAt(object, 99);
            zombieBloodObjects1.push(object);
        }

        for (i in 0...zombieGirlRemainsTotal) {
            final object = new h2d.Bitmap(Res.instance.getTileResource(SeidhResource.FX_ZOMBIE_BLOOD_2).center());
            object.alpha = 0;
            s2d.addChildAt(object, 99);
            zombieBloodObjects2.push(object);
        }
	}

    public function addRagnarGroundAttack(x:Float, y:Float, side:Side) {
        if (ragnarGroundAttackObjectsNextIndex + 1 == ragnarGroundAttackObjectsTotal) {
            ragnarGroundAttackObjectsNextIndex = 0;
        }

        final object = cast (ragnarGroundAttackObjects[ragnarGroundAttackObjectsNextIndex++], FxTilesAnimation);
        object.setPosition(x, y);
        object.setSide(side);
        object.alpha = 1;
        object.playAnimation();
    }

    public function addGlamrEyeAttack(x:Float, y:Float, side:Side) {
        if (glamrEyeExplosionObjectsNextIndex + 1 >= glamrEyeExplosionObjectsTotal) {
            glamrEyeExplosionObjectsNextIndex = 0;
        }

        final object = cast (glamrEyeExplosionObjects[glamrEyeExplosionObjectsNextIndex++], FxTilesAnimation);
        object.setPosition(x, y);
        object.setSide(side);
        object.alpha = 1;
        object.playAnimation();
    }

    public function addFloaingTweenText(x:Float, y:Float, side:Side, targetScale:Float, color:Int, text:String) {
        if (floatingTweenTextObjectsNextIndex + 1 == floatingTweenTextObjectsTotal) {
            floatingTweenTextObjectsNextIndex = 0;
        }

        final object = cast (floatingTweenTextObjects[floatingTweenTextObjectsNextIndex++], h2d.Text);
        object.alpha = 1;
        object.textColor = color;
        object.text =  text;
        object.setPosition(x, y - 50);
        
        final rndX = MathUtils.randomIntInRange(70, 150);
        final rndY = MathUtils.randomIntInRange(150, 250);

        Actuate.tween(object, 1, { 
            x: object.x + (side == Side.RIGHT ? -rndX : rndX),
            y: object.y - rndY,
            scaleX: targetScale,
            scaleY: targetScale,
            alpha: 0.5,
        }).onComplete(function callback() {
            object.alpha = 0;
        });
    }

    public function addRemains(x:Float, y:Float, entityType:EntityType, side:Side) {
        var remains:h2d.Bitmap = null; 

        switch (entityType) {
            case EntityType.ZOMBIE_BOY:
                zombieBoyRemainsNextIndex++;
                if (zombieBoyRemainsNextIndex + 1 == zombieBoyRemainsTotal) {
                    zombieBoyRemainsNextIndex = 0;
                }
                remains = cast (zombieBloodObjects1[zombieBoyRemainsNextIndex], h2d.Bitmap);
            case EntityType.ZOMBIE_GIRL:
                zombieGirlRemainsNextIndex++;
                if (zombieGirlRemainsNextIndex + 1 == zombieGirlRemainsTotal) {
                    zombieGirlRemainsNextIndex = 0;
                }
                remains = cast (zombieBloodObjects2[zombieGirlRemainsNextIndex], h2d.Bitmap);
            default:
        }

        if (remains != null) {
            if (side == Side.LEFT) {
                remains.tile.flipX();
            }
            remains.alpha = 1;
            remains.setPosition(x, y);
        }
    }

    public function dispose() {
        for (value in ragnarGroundAttackObjects) {
            s2d.removeChild(value);
        }
        for (value in floatingTweenTextObjects) {
            s2d.removeChild(value);
        }
        for (value in zombieBloodObjects1) {
            s2d.removeChild(value);
        }
        for (value in zombieBloodObjects2) {
            s2d.removeChild(value);
        }
        for (value in glamrEyeExplosionObjects) {
            s2d.removeChild(value);
        }

        ragnarGroundAttackObjects = [];
        floatingTweenTextObjects = [];
        zombieBloodObjects1 = [];
        zombieBloodObjects2 = [];
        glamrEyeExplosionObjects = [];
    }

}