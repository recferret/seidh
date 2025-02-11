package game.scene.impl.home.play.dialog;

import game.ui.text.TextUtils;

class CharacterStatsDialog extends h2d.Object {

    public function new(levelUp:Bool) {
        super();

        final titleText = TextUtils.GetDefaultTextObject(
            DeviceInfo.TargetPortraitScreenWidth / 2,
            DeviceInfo.TargetPortraitScreenHeight / 2 - 210,
            1.5,
            Center,
            GameClientConfig.WhiteFontColor
        );
        titleText.text = 'Ragnar';
        addChild(titleText);

        // ----------------------
        // Level
        // ----------------------

        // Default
        final lvlText = TextUtils.GetDefaultTextObject(
            DeviceInfo.TargetPortraitScreenWidth / 2,
            DeviceInfo.TargetPortraitScreenHeight / 2 - 150,
            1,
            Center,
            GameClientConfig.WhiteFontColor
        );
        lvlText.text = 'Level: 1/10';
        addChild(lvlText);

        // ----------------------
        // Health
        // ----------------------

        // Default
        final healthText = TextUtils.GetDefaultTextObject(
            DeviceInfo.TargetPortraitScreenWidth / 2 - 215,
            DeviceInfo.TargetPortraitScreenHeight / 2 - 110,
            1,
            Left,
            GameClientConfig.DefaultFontColor
        );
        healthText.text = 'Health: 100';
        addChild(healthText);

        if (levelUp) {
            // Upgrade
            final healthText = TextUtils.GetDefaultTextObject(
                DeviceInfo.TargetPortraitScreenWidth / 2 - 40,
                DeviceInfo.TargetPortraitScreenHeight / 2 - 110,
                1,
                Left,
                GameClientConfig.UpgradeFontColor
            );
            healthText.text = '> 150';
            addChild(healthText);
        }

        // ----------------------
        // Damage
        // ----------------------

        // Default
        final damageText = TextUtils.GetDefaultTextObject(
            DeviceInfo.TargetPortraitScreenWidth / 2 - 215,
            DeviceInfo.TargetPortraitScreenHeight / 2 - 70,
            1,
            Left,
            GameClientConfig.DefaultFontColor
        );
        damageText.text = 'Damage: 10';
        addChild(damageText);

        if (levelUp) {
            // Upgrade
            final damageText = TextUtils.GetDefaultTextObject(
                DeviceInfo.TargetPortraitScreenWidth / 2 - 40,
                DeviceInfo.TargetPortraitScreenHeight / 2 - 70,
                1,
                Left,
                GameClientConfig.UpgradeFontColor
            );
            damageText.text = '> 15';
            addChild(damageText);
        }

        // ----------------------
        // Attack speed
        // ----------------------

        // Default
        final attackSpeedText = TextUtils.GetDefaultTextObject(
            DeviceInfo.TargetPortraitScreenWidth / 2 - 215,
            DeviceInfo.TargetPortraitScreenHeight / 2,
            1,
            Left,
            GameClientConfig.DefaultFontColor
        );
        attackSpeedText.text = 'Attack speed: 1';
        addChild(attackSpeedText);

        if (levelUp) {
            // Upgrade
            final attackSpeedText = TextUtils.GetDefaultTextObject(
                DeviceInfo.TargetPortraitScreenWidth / 2 + 20,
                DeviceInfo.TargetPortraitScreenHeight / 2,
                1,
                Left,
                GameClientConfig.UpgradeFontColor
            );
            attackSpeedText.text = '> 2';
            addChild(attackSpeedText);
        }
        
        // ----------------------
        // Movement speed
        // ----------------------

        // Default
        final movementSpeedText = TextUtils.GetDefaultTextObject(
            DeviceInfo.TargetPortraitScreenWidth / 2 - 215,
            DeviceInfo.TargetPortraitScreenHeight / 2 + 30,
            1,
            Left,
            GameClientConfig.DefaultFontColor
        );
        movementSpeedText.text = 'Movement speed: 100';
        addChild(movementSpeedText);

        if (levelUp) {
            // Upgrade
            final movementSpeedText = TextUtils.GetDefaultTextObject(
                DeviceInfo.TargetPortraitScreenWidth / 2 + 100,
                DeviceInfo.TargetPortraitScreenHeight / 2 + 30,
                1,
                Left,
                GameClientConfig.UpgradeFontColor
            );
            movementSpeedText.text = '> 110';
            addChild(movementSpeedText);
        }
    }

}