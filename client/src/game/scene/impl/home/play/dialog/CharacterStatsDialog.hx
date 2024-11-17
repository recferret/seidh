package game.scene.impl.home.play.dialog;

import game.Res.SeidhResource;

class CharacterStatsDialog extends h2d.Object {

    public function new(parent:h2d.Object) {
        super(parent);

        // Shadow background
        final backgroundTile = h2d.Tile.fromColor(0x000000, Main.ActualScreenWidth, Main.ActualScreenHeight, 0.7);
        addChild(new h2d.Bitmap(backgroundTile));
        
        final dialogBmp = new h2d.Bitmap(Res.instance.getTileResource(SeidhResource.UI_DIALOG_WINDOW_MEDIUM));
        dialogBmp.setPosition(Main.ActualScreenWidth / 2, Main.ActualScreenHeight / 2);
        addChild(dialogBmp);
        
        alpha = 0;
    }

    public function show() {
        alpha = 1;
    }

}