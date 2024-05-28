package game.scene.impl;

import game.terrain.TerrainManager;
import h2d.filter.Outline;
import h2d.filter.Glow;
import h2d.filter.DropShadow;
import game.scene.base.BasicScene;

class SceneSpritesTest extends BasicScene {

	var hue = 0.;
	var sat = -100.;
	var bright = 0.;
	var contrast = 0.;

	final ragnar2:h2d.Bitmap;

	final shadowFilter = new DropShadow(10, 2, 0x66000000, 0.4);

    public function new() {
		super(null);

		// new TerrainManager(this);

		addSlider("Hue", function() return hue, function(s) hue = s, -180, 180);
		addSlider("Saturation", function() return sat, function(s) sat = s, -100, 100);
		addSlider("Brightness", function() return bright, function(s) bright = s, -100, 100);
		addSlider("Contrast", function() return contrast, function(s) contrast = s, -100, 100);

		final ragnar1 = new h2d.Bitmap(hxd.Res.ragnar.ragnar.toTile(), this);
		ragnar1.setPosition(100 , 100);

		final ragnarPixels = hxd.Res.ragnar.ragnar.toTile().getTexture().capturePixels();
		final gradient = new hxd.BitmapData(177, 261);
		gradient.setPixels(ragnarPixels);

		// gradient.lock();


		// // trace(0x71664C);
		// trace(gradient.getPixel(115, 14));

		// for(x in 0...gradient.width) {
		// 	for(y in 0...gradient.height) {

		// 		if (gradient.getPixel(x, y) == -2787328) {
		// 			trace('Change pixel color');
		// 			gradient.setPixel(x,y, 0xFFFF0000);
		// 		}
		// 			// trace('РУБАХА');
		// 		// }
		// 	//   gradient.setPixel(x,y, 0xFF000000 | ((x << 16) * red) | ((y << 8) * green) | (((x + y) >> 1) * blue));
		// 	}
		// }

		// gradient.unlock();

		ragnar2 = new h2d.Bitmap(h2d.Tile.fromBitmap(gradient), this);
		ragnar2.adjustColor({ saturation : 0, hue: 2 });
		ragnar2.setPosition(300 , 100);


		final ragnar3 = new h2d.Bitmap(hxd.Res.ragnar.ragnar.toTile(), this);
		ragnar3.filter = shadowFilter;
		ragnar3.setPosition(500 , 100);


		final ragnar4 = new h2d.Bitmap(hxd.Res.ragnar.ragnar.toTile(), this);
		ragnar4.filter = new Glow(0xFF0000, 0.5);
		ragnar4.setPosition(700 , 100);

		final ragnar4 = new h2d.Bitmap(hxd.Res.ragnar.ragnar.toTile(), this);
		ragnar4.filter = new Outline(1);
		ragnar4.setPosition(900 , 100);
	}	

    // --------------------------------------
	// Impl
	// --------------------------------------

	public function start() {
	}

	public function customUpdate(dt:Float, fps:Float) {
		ragnar2.adjustColor({ saturation : sat / 100, lightness : bright / 100, hue : hue * Math.PI / 180, contrast : contrast / 100 });

		shadowFilter.angle += 0.1;
	}

}