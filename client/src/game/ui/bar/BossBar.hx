package game.ui.bar;

import game.ui.text.TextUtils;
import game.utils.Utils;
import game.Res.SeidhResource;

import motion.Actuate;

class BossBar extends h2d.Object {

    private final customGraphics:h2d.Graphics;
    private final bossNameText:h2d.Text;
    private var targetY = 200.0;

    public function new() {
        super();
        
        alpha = 0.1;
        setScale(0.7);
        setPosition(DeviceInfo.ActualScreenWidth / 2, DeviceInfo.ActualScreenHeight / 2);

        new h2d.Bitmap(Res.instance.getTileResource(SeidhResource.UI_GAME_BOSS_BAR), this);
        customGraphics = new h2d.Graphics(this);

        bossNameText = TextUtils.GetDefaultTextObject(0, -100, 2, Center, GameClientConfig.DefaultFontColor);
        bossNameText.text = 'GLAMR';
        addChild(bossNameText);
    }

    public function setBossName(bossName:String) {
        bossNameText.text = bossName;
    }

    public function updateBossHealth(currentValue:Int, maxValue:Int) {
        customGraphics.clear();

        final maxBarWidthPx = 498;
        final currentBarWidthPx = maxBarWidthPx / 100 * (currentValue / maxValue * 100);

        Utils.DrawRectFilled(customGraphics, new engine.base.geometry.Rectangle(-248, -13, currentBarWidthPx, 26, 0), GameClientConfig.BossHpBarColor);
    }

    public function setTargetY(y:Float) {
        targetY = y;
    }

    public function appearAnimation() {
        Actuate.tween(this, 1, { 
            y: targetY,
            alpha: 1,
            scaleX: 1,
            scaleY: 1,
        })
        .delay(0.3);
    }

    public function pulseAnim() {
        Actuate.tween(this, 0.1, { 
            scaleX: 1.1,
            scaleY: 1.1
        })
        .delay(0.3)
        .onComplete(function callback() {
            Actuate.tween(this, 0.1, { 
                scaleX: 1,
                scaleY: 1
            });
        });
    }

}