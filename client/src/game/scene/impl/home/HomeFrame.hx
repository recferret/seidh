package game.scene.impl.home;

import h2d.Object;

import game.Res.SeidhResource;

class HomeFrame extends h2d.Object {

	private final contentObjectOffsetX:Float;
	private final contentObjectOffsetY:Float;

    public function new(parent:h2d.Object, contentObjectOffsetX:Float, contentObjectOffsetY:Float) {
        super(parent);

		this.contentObjectOffsetX = contentObjectOffsetX;
		this.contentObjectOffsetY = contentObjectOffsetY;

        addHeader();
        addFooter();
        addSides();
    }

    private function addHeader() {
        final headerLeft = new h2d.Bitmap(Res.instance.getTileResource(SeidhResource.UI_HOME_HEADER_LEFT));
        headerLeft.setPosition(
			headerLeft.tile.width / 2 + contentObjectOffsetX,
			headerLeft.tile.height / 2 + contentObjectOffsetY,
		);
        addChild(headerLeft);

        final frameHeaderRight = new h2d.Bitmap(Res.instance.getTileResource(SeidhResource.UI_HOME_HEADER_RIGHT));
        frameHeaderRight.setPosition(
			DeviceInfo.TargetPortraitScreenWidth - frameHeaderRight.tile.width / 2 + contentObjectOffsetX,
			frameHeaderRight.tile.height / 2 + contentObjectOffsetY,
		);
        addChild(frameHeaderRight);

        final headerHorizontalTile = Res.instance.getTileResource(SeidhResource.UI_HOME_HEADER_HORIZONTAL);
        final screenWidthMinusCornerFrames = DeviceInfo.TargetPortraitScreenWidth - (headerLeft.tile.width * 2);
    
        for (i in 0...Std.int(screenWidthMinusCornerFrames / headerHorizontalTile.width)) {
			final frame = new h2d.Bitmap(headerHorizontalTile);
			frame.setPosition(
				headerLeft.tile.width + headerHorizontalTile.width / 2 + (headerHorizontalTile.width * i + contentObjectOffsetX),
				headerHorizontalTile.height / 2 + contentObjectOffsetY,
			);

			addChild(frame);
		}
    }

    private function addFooter() {
        final footerFrameLeft = new h2d.Bitmap(Res.instance.getTileResource(SeidhResource.UI_HOME_FOOTER_LEFT));
		footerFrameLeft.setPosition(
			footerFrameLeft.tile.width / 2 + contentObjectOffsetX,
			DeviceInfo.TargetPortraitScreenHeight - footerFrameLeft.tile.height / 2 + contentObjectOffsetY,
		);
		addChild(footerFrameLeft);

		final footerFrameRight = new h2d.Bitmap(Res.instance.getTileResource(SeidhResource.UI_HOME_FOOTER_RIGHT));
		footerFrameRight.setPosition(
			DeviceInfo.TargetPortraitScreenWidth - footerFrameRight.tile.width / 2 + contentObjectOffsetX,
			DeviceInfo.TargetPortraitScreenHeight - footerFrameRight.tile.height / 2 + contentObjectOffsetY,
		);
		addChild(footerFrameRight);

        final footerHorizontalTile = Res.instance.getTileResource(SeidhResource.UI_HOME_FOOTER_HORIZONTAL);
        final screenWidthMinusCornerFrames = DeviceInfo.TargetPortraitScreenWidth - (footerFrameLeft.tile.width * 2);
    
        for (i in 0...Std.int(screenWidthMinusCornerFrames / footerHorizontalTile.width) + 1) {
			final frame = new h2d.Bitmap(footerHorizontalTile);
			frame.setPosition(
				frame.tile.width + footerHorizontalTile.width / 2 + (footerHorizontalTile.width * i) + contentObjectOffsetX,
				DeviceInfo.TargetPortraitScreenHeight - footerHorizontalTile.height / 2 + contentObjectOffsetY,
			);

			addChild(frame);
		}
    }

    private function addSides() {
        final verticalTileLeft = Res.instance.getTileResource(SeidhResource.UI_HOME_FRAME_VERTICAL);
        final verticalTileRight = Res.instance.getTileResource(SeidhResource.UI_HOME_FRAME_VERTICAL);
        verticalTileRight.flipX();
        final headerHorizontalTile = Res.instance.getTileResource(SeidhResource.UI_HOME_HEADER_HORIZONTAL);
		final screenHeightMinusCornerFrames = DeviceInfo.TargetPortraitScreenHeight - (headerHorizontalTile.height * 2);

		for (i in 0...Std.int(screenHeightMinusCornerFrames / verticalTileLeft.width)) {
			final frameVerticalLeft = new h2d.Bitmap(verticalTileLeft);
			frameVerticalLeft.setPosition(
				verticalTileLeft.width / 2 + contentObjectOffsetX,
				headerHorizontalTile.height + verticalTileLeft.height / 2 + (verticalTileLeft.height * i) + contentObjectOffsetY,
			);
            addChild(frameVerticalLeft);

            final frameVerticalRight = new h2d.Bitmap(verticalTileRight);
			frameVerticalRight.setPosition(
				DeviceInfo.TargetPortraitScreenWidth - verticalTileRight.width / 2 + contentObjectOffsetX,
				headerHorizontalTile.height + verticalTileRight.height / 2 + (verticalTileRight.height * i) + contentObjectOffsetY,
			);
            addChild(frameVerticalRight);
		}
    }
}