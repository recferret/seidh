package game.scene.impl.home;

import game.Res.SeidhResource;

class BgFrame extends h2d.Object {

    public function new(parent:h2d.Object) {
        super(parent);

        final header = new h2d.Bitmap(Res.instance.getTileResource(SeidhResource.UI_DIALOG_XL_HEADER));
        final footer = new h2d.Bitmap(Res.instance.getTileResource(SeidhResource.UI_DIALOG_XL_FOOTER));

        final middlePartHeight = Std.int(DeviceInfo.TargetPortraitScreenHeight - header.tile.height - footer.tile.height - (DeviceInfo.TargetPortraitScreenHeight >= 1280 ? 170 : 100));
        final middle = new h2d.Bitmap(h2d.Tile.fromColor(GameClientConfig.UiBrownColor, Std.int(header.tile.width) + 1, middlePartHeight));

        header.setPosition(DeviceInfo.TargetPortraitScreenWidth / 2, header.tile.height - 100);
        footer.setPosition(DeviceInfo.TargetPortraitScreenWidth / 2, DeviceInfo.TargetPortraitScreenHeight - footer.tile.height - (DeviceInfo.TargetPortraitScreenHeight >= 1280 ? 50 : 0));

        middle.setPosition(113, header.tile.height);

        addChild(header);
        addChild(middle);
        addChild(footer);
    }

    public function update(dt:Float) {
        // rune1.y++;
    }
}

abstract class BasicHomeContent extends h2d.Object {

    public var contentScrollY = 0.0;
    final bgFrame: BgFrame;

    public function new(addBgFrame: Bool) {
		super();

        if (addBgFrame) {
            bgFrame = new BgFrame(this);
        }
    }


    public abstract function update(dt:Float):Void;
}