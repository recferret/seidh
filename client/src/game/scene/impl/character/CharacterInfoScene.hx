package game.scene.impl.character;

import engine.base.MathUtils;
import game.Res.SeidhResource;
import h3d.Engine;
import hxd.Event;

import game.scene.base.BasicScene;

class SceneCharacterInfo extends BasicScene {

    public var graphics1:h2d.Graphics;
    public var graphics2:h2d.Graphics;

    public function new() {
		super(null);

		Main.SetBackgroundColor(GameClientConfig.DarkBgColor);

        graphics1 = new h2d.Graphics(this);
        graphics2 = new h2d.Graphics(this);

        // Frame corners
        final topLeftCorner = new h2d.Bitmap(Res.instance.getTileResource(SeidhResource.UI_CHAR_FRAME_CORNER));
        topLeftCorner.setPosition(
            topLeftCorner.tile.width / 2,
            topLeftCorner.tile.height / 2
        );

        final topRightCorner = new h2d.Bitmap(Res.instance.getTileResource(SeidhResource.UI_CHAR_FRAME_CORNER));
        topRightCorner.setPosition(
            DeviceInfo.ActualScreenWidth - topRightCorner.tile.width / 2,
            topRightCorner.tile.height / 2
        );
        topRightCorner.tile.flipX();

        final bottomLeftCorner = new h2d.Bitmap(Res.instance.getTileResource(SeidhResource.UI_CHAR_FRAME_CORNER));
        bottomLeftCorner.setPosition(
            bottomLeftCorner.tile.width / 2,
            DeviceInfo.ActualScreenHeight - bottomLeftCorner.tile.height / 2
        );
        bottomLeftCorner.tile.flipY();

        final bottomRightCorner = new h2d.Bitmap(Res.instance.getTileResource(SeidhResource.UI_CHAR_FRAME_CORNER));
        bottomRightCorner.setPosition(
            DeviceInfo.ActualScreenWidth - bottomRightCorner.tile.width / 2,
            DeviceInfo.ActualScreenHeight - bottomRightCorner.tile.height / 2
        );
        bottomRightCorner.tile.flipX();
        bottomRightCorner.tile.flipY();

        // Frame lines between corners
        final horizontalFrameTileLeft = Res.instance.getTileResource(SeidhResource.UI_CHAR_FRAME_HORIZONTAL);
        final horizontalFrameTileRight = Res.instance.getTileResource(SeidhResource.UI_CHAR_FRAME_HORIZONTAL);
        horizontalFrameTileRight.flipX();

        final frameWidth = horizontalFrameTileLeft.width;

        for (i in 0...(Std.int((DeviceInfo.ActualScreenHeight - (topLeftCorner.tile.height * 2)) / horizontalFrameTileLeft.height) + 1)) {
            final frameHorizontalLeft = new h2d.Bitmap(horizontalFrameTileLeft, this);
            final frameHorizontalRight = new h2d.Bitmap(horizontalFrameTileRight, this);

            var yPos = topLeftCorner.tile.height + horizontalFrameTileLeft.height / 2;
            yPos += i * horizontalFrameTileLeft.height;

            frameHorizontalLeft.setPosition(
                frameHorizontalLeft.tile.width / 2,
                yPos,
            );
            frameHorizontalRight.setPosition(
                DeviceInfo.ActualScreenWidth - horizontalFrameTileRight.width / 2,
                yPos,
            );
        }

        // Top and bottom
        final horizontalFrameTileTop = Res.instance.getTileResource(SeidhResource.UI_CHAR_FRAME_VERTICAL);
        final horizontalFrameTileBottom = Res.instance.getTileResource(SeidhResource.UI_CHAR_FRAME_VERTICAL);
        horizontalFrameTileBottom.flipY();

        final frameHeight = horizontalFrameTileLeft.width;

        for (i in 0...(Std.int((DeviceInfo.ActualScreenWidth - (topLeftCorner.tile.width * 2)) / horizontalFrameTileTop.width) + 1)) {
            final frameVerticalTop = new h2d.Bitmap(horizontalFrameTileTop, this);
            final frameVerticalBottom = new h2d.Bitmap(horizontalFrameTileBottom, this);
           
            var xPos = topLeftCorner.tile.width + horizontalFrameTileTop.width / 2;
            xPos += i * horizontalFrameTileTop.width;

            frameVerticalTop.setPosition(
                xPos,
                horizontalFrameTileTop.height / 2,
            );
            frameVerticalBottom.setPosition(
                xPos,
                DeviceInfo.ActualScreenHeight - horizontalFrameTileBottom.height / 2,
            );
        }

        // Character 
        graphics1.beginFill(GameClientConfig.SelectorActiveBgColor);
        graphics1.drawRect(frameWidth - 1, frameHeight, DeviceInfo.ActualScreenWidth / 2 - frameWidth, 102);
        // graphics1.endFill();
        graphics1.beginFill(GameClientConfig.SelectorInactiveBgColor);
        graphics1.drawRect(frameWidth + DeviceInfo.ActualScreenWidth / 2 - frameWidth + 1, frameHeight, DeviceInfo.ActualScreenWidth / 2 - frameWidth, 102);
        graphics1.endFill();

        addChild(topLeftCorner);
        addChild(topRightCorner);
        addChild(bottomLeftCorner);
        addChild(bottomRightCorner);

        // Exp circle
        final expCircle = new h2d.Bitmap(Res.instance.getTileResource(SeidhResource.UI_CHAR_EXP_RING));
        graphics1.lineStyle(35, GameClientConfig.XpRingColor);
        graphics1.drawPieInner(DeviceInfo.ActualScreenWidth / 2, 380, 140, 140, MathUtils.degreeToRads(-90), MathUtils.degreeToRads(45));
        graphics1.endFill();

        graphics2.beginFill(GameClientConfig.DarkBgColor);
        graphics2.drawCircle(DeviceInfo.ActualScreenWidth / 2, 380, 125);
        graphics2.endFill();

        addChild(expCircle);
        expCircle.setPosition(
            DeviceInfo.ActualScreenWidth / 2,
            380,
        );
	}

    public function absOnEvent(event:Event) {}

    public function absOnResize(w:Int, h:Int) {}

    public function absStart() {}

    public function absRender(e:Engine) {}

    public function absDestroy() {}

    public function absUpdate(dt:Float, fps:Float) {}
}