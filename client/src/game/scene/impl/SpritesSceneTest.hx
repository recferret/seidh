package game.scene.impl;

import game.Res.SeidhResource;
import game.entity.terrain.ClientTerrainEntity;
import game.utils.Utils;
// import game.entity.tree.ClientTreeEntity;
import game.sound.SoundManager;
import engine.base.BaseTypesAndClasses.EntityType;
import engine.seidh.entity.factory.SeidhEntityFactory;
import game.entity.character.ClientCharacterEntity;
import game.fx.FxManager;
import h2d.Tile;
import h3d.Vector;
import hxsl.Types.Vec;
import game.terrain.TerrainManager;
import h2d.filter.Outline;
import h2d.filter.Glow;
import h2d.filter.DropShadow;
import h2d.filter.Mask;
import game.scene.base.BasicScene;

import hxd.Key in K;
import haxe.Timer;

class SceneSpritesTest extends BasicScene {

	var hue = 0.;
	var sat = -100.;
	var bright = 0.;
	var contrast = 0.;

	// final ragnar2:h2d.Bitmap;

	// final shadowFilter = new DropShadow(10, 2, 0x66000000, 0.4);

    public function new() {
		super(null);

		// new TerrainManager(this);

		// addSlider("Hue", function() return hue, function(s) hue = s, -180, 180);
		// addSlider("Saturation", function() return sat, function(s) sat = s, -100, 100);
		// addSlider("Brightness", function() return bright, function(s) bright = s, -100, 100);
		// addSlider("Contrast", function() return contrast, function(s) contrast = s, -100, 100);

		// final ragnar1 = new h2d.Bitmap(hxd.Res.ragnar.ragnar_loh.toTile(), this);
		// ragnar1.setPosition(100 , 100);

		// ragnar2 = new h2d.Bitmap(hxd.Res.ragnar.ragnar_loh.toTile(), this);
		// ragnar2.adjustColor({ saturation : 0, hue: 2 });
		// ragnar2.setPosition(300 , 100);

		// final ragnar3 = new h2d.Bitmap(hxd.Res.ragnar.ragnar_loh.toTile(), this);
		// ragnar3.filter = shadowFilter;
		// ragnar3.setPosition(500 , 100);

		// final ragnar4 = new h2d.Bitmap(hxd.Res.ragnar.ragnar_loh.toTile(), this);
		// ragnar4.filter = new Glow(0xFF0000, 0.5);
		// ragnar4.setPosition(700 , 100);

		// final ragnar4 = new h2d.Bitmap(hxd.Res.ragnar.ragnar_loh.toTile(), this);
		// ragnar4.filter = new Outline(1);
		// ragnar4.setPosition(900 , 100);

		// final ragnarPixels = hxd.Res.ragnar.ragnar_loh.toTile().getTexture().capturePixels();
		// final gradient = new hxd.BitmapData(179, 256);
		// gradient.setPixels(ragnarPixels);
		// gradient.lock();

		// // trace(StringTools.hex(-11896204, 6));

		// for(x in 0...gradient.width) {
		// 	for(y in 0...gradient.height) {

		// 		if (gradient.getPixel(x, y) == 0xffd57800) {
		// 			// gradient.setPixel(x,y, 0x878787);
		// 		}
		// 		if (gradient.getPixel(x, y) == 0xffe5ad32) {
		// 			// gradient.setPixel(x,y, 0xb2b2b2);
		// 		}
		// 		if (gradient.getPixel(x, y) == 0xFF4A7A74) {
		// 			gradient.setPixel(x,y, 0xff5e8601);
		// 			// trace('РУБАХА');
		// 		}
				
		// 		// }
		// 	//   gradient.setPixel(x,y, 0xFF000000 | ((x << 16) * red) | ((y << 8) * green) | (((x + y) >> 1) * blue));
		// 	}
		// }

		// gradient.unlock();

		// final ragnar5 = new h2d.Bitmap(h2d.Tile.fromBitmap(gradient), this);
		// ragnar5.setPosition(100 , 400);


		// FX

		ragnar = new ClientCharacterEntity(this, SeidhEntityFactory.InitiateCharacter(null, null, 200, 200, EntityType.RAGNAR_LOH));

        rock = new ClientTerrainEntity(this, TerrainType.ROCK, Res.instance.getTileResource(SeidhResource.TERRAIN_ROCK));
        rock.setPosition(300, 200);

		tree = new ClientTerrainEntity(this, TerrainType.TREE, Res.instance.getTileResource(SeidhResource.TERRAIN_TREE_1));
        tree.setPosition(600, 200);

		fence = new ClientTerrainEntity(this, TerrainType.FENCE, Res.instance.getTileResource(SeidhResource.TERRAIN_FENCE));
        fence.setPosition(900, 200);

		weed = new ClientTerrainEntity(this, TerrainType.WEED, Res.instance.getTileResource(SeidhResource.TERRAIN_WEED_1));
        weed.setPosition(1100, 200);

		// tree.blendMode = BlendMode;
		


		// final ragnarLeft = new ClientCharacterEntity(this);
		// ragnarLeft.initiateEngineEntity(SeidhEntityFactory.InitiateCharacter(null, null, 850, 600, EntityType.RAGNAR_LOH));
		// ragnarLeft.setSideDebug(LEFT);

		// final zombieBoyRight = new ClientCharacterEntity(this);
		// zombieBoyRight.initiateEngineEntity(SeidhEntityFactory.InitiateCharacter(null, null, 150, 900, EntityType.ZOMBIE_BOY));
		
		// final zombieBoyLeft = new ClientCharacterEntity(this);
		// zombieBoyLeft.initiateEngineEntity(SeidhEntityFactory.InitiateCharacter(null, null, 850, 900, EntityType.ZOMBIE_BOY));
		// zombieBoyLeft.setSideDebug(LEFT);

		// characterMainAttackAndHurt(ragnarRight);
		// characterMainAttackAndHurt(ragnarLeft);

		// characterMainAttackAndHurt(zombieBoyRight);
		// characterMainAttackAndHurt(zombieBoyLeft);
	}	

    private var ragnar:ClientCharacterEntity;
    private var rock:ClientTerrainEntity;
	private var tree:ClientTerrainEntity;
	private var weed:ClientTerrainEntity;
	private var fence:ClientTerrainEntity;

	// private function characterMainAttackAndHurt(clientCharacterEntity:ClientCharacterEntity) {
		// Timer.delay(function callback() {
			// clientCharacterEntity.fxActionMain();
			// clientCharacterEntity.fxHurt();
			// characterMainAttackAndHurt(clientCharacterEntity);
		// }, 1000);
	// }

    // --------------------------------------
	// Impl
	// --------------------------------------

	public function start() {
	}

	public function customUpdate(dt:Float, fps:Float) {
		Utils.DrawRect(debugGraphics, rock.getRect(), GameConfig.BlueColor);
		Utils.DrawRect(debugGraphics, tree.getRect(), GameConfig.BlueColor);
		Utils.DrawRect(debugGraphics, fence.getRect(), GameConfig.BlueColor);
		Utils.DrawRect(debugGraphics, weed.getRect(), GameConfig.BlueColor);

        Utils.DrawRect(debugGraphics, rock.getBottomRect(), GameConfig.GreenColor);
		Utils.DrawRect(debugGraphics, tree.getBottomRect(), GameConfig.GreenColor);
		Utils.DrawRect(debugGraphics, fence.getBottomRect(), GameConfig.GreenColor);
		Utils.DrawRect(debugGraphics, weed.getBottomRect(), GameConfig.GreenColor);

		Utils.DrawRect(debugGraphics, ragnar.getRect(), GameConfig.BlueColor);
        Utils.DrawRect(debugGraphics, ragnar.getBottomRect(), GameConfig.GreenColor);

		final ragnarBottom = ragnar.getBottomRect().getCenter();
		final ragnarRect = ragnar.getRect();

		final rockBottom = rock.getBottomRect().getCenter();
		final rockRect = rock.getRect();

		final treeBottom = tree.getBottomRect().getCenter();
		final treeRect = tree.getRect();

		final fenceBottom = fence.getBottomRect().getCenter();
		final fenceRect = fence.getRect();

		final weedBottom = weed.getBottomRect().getCenter();
		final weedRect = weed.getRect();

		// final rockBottom = rock.getBottomRect().getCenter();
		// if (rockBottom.distance(ragnarBottom) < 250) {
		// 	if (rockBottom.y < ragnarBottom.y) {
		// 		ragnar.oZrder = 3;
		// 		rock.oZrder = 2;
		// 	} else {
		// 		ragnar.oZrder = 2;
		// 		rock.oZrder = 3;
		// 	}
		// }


		// .distance(ragnarBottom) < 250

		if (rockRect.intersectsWithRect(ragnarRect)) {
			if (rockBottom.y < ragnarBottom.y) {
				ragnar.oZrder = 2;
				rock.oZrder = 1;
			} else {
				ragnar.oZrder = 1;
				rock.oZrder = 2;
			}
		}

		if (treeRect.intersectsWithRect(ragnarRect)) {
			if (treeBottom.y < ragnarBottom.y) {
				ragnar.oZrder = 2;
				tree.oZrder = 1;
			} else {
				ragnar.oZrder = 1;
				tree.oZrder = 2;
			}
		}

		if (fenceRect.intersectsWithRect(ragnarRect)) {
			if (fenceBottom.y < ragnarBottom.y) {
				ragnar.oZrder = 2;
				fence.oZrder = 1;
			} else {
				ragnar.oZrder = 1;
				fence.oZrder = 2;
			}
		}

		if (weedRect.intersectsWithRect(ragnarRect)) {
			if (weedBottom.y < ragnarBottom.y) {
				ragnar.oZrder = 2;
				weed.oZrder = 1;
			} else {
				ragnar.oZrder = 1;
				weed.oZrder = 2;
			}
		}


		// final fenceBottom = fence.getBottomRect().getCenter();
		// if (fenceBottom.distance(ragnarBottom) < 250) {
		// 	if (fenceBottom.y < ragnarBottom.y) {
		// 		ragnar.oZrder = 2;
		// 		fence.oZrder = 1;
		// 	} else {
		// 		ragnar.oZrder = 1;
		// 		fence.oZrder = 2;
		// 	}
		// }

		// final weedBottom = weed.getBottomRect().getCenter();
		// if (weedBottom.distance(ragnarBottom) < 250) {
		// 	if (weedBottom.y < ragnarBottom.y) {
		// 		ragnar.oZrder = 2;
		// 		weed.oZrder = 1;
		// 	} else {
		// 		ragnar.oZrder = 1;
		// 		weed.oZrder = 2;
		// 	}
		// }

		// TODO impl z order state
		sortObjectsByZOrder();



		// if (tree.getRect().getCenter())

		// ragnar2.adjustColor({ saturation : sat / 100, lightness : bright / 100, hue : hue * Math.PI / 180, contrast : contrast / 100 });

		// shadowFilter.angle += 0.1;

        // IMPL SIMPLE MOVEMENT

        final left = K.isDown(K.LEFT);
		final right = K.isDown(K.RIGHT);
		final up = K.isDown(K.UP);
		final down = K.isDown(K.DOWN);

        if (left) {
            ragnar.x -= 5;
        }
        if (right) {
            ragnar.x += 5;
        }
        if (up) {
            ragnar.y -= 5;
        }
        if (down) {
            ragnar.y += 5;
        }
	}

}