package game.scene.impl.home.play.dialog;

import game.ui.text.TextUtils;

class CharacterStatsDialog extends h2d.Object {

    public function new(levelUp:Bool) {
        super();

        final titleText = TextUtils.GetDefaultTextObject(
            Main.ActualScreenWidth / 2,
            Main.ActualScreenHeight / 2 - 210,
            3,
            Center,
            GameConfig.WhiteFontColor
        );
        titleText.text = 'Ragnar';
        addChild(titleText);

        // ----------------------
        // Level
        // ----------------------

        // Default
        final lvlText = TextUtils.GetDefaultTextObject(
            Main.ActualScreenWidth / 2,
            Main.ActualScreenHeight / 2 - 160,
            2.5,
            Center,
            GameConfig.WhiteFontColor
        );
        lvlText.text = 'Level: 1/10';
        addChild(lvlText);

        // ----------------------
        // Health
        // ----------------------

        // Default
        final healthText = TextUtils.GetDefaultTextObject(
            Main.ActualScreenWidth / 2 - 215,
            Main.ActualScreenHeight / 2 - 110,
            2.5,
            Left,
            GameConfig.DefaultFontColor
        );
        healthText.text = 'Health: 100';
        addChild(healthText);

        if (levelUp) {
            // Upgrade
            final healthText = TextUtils.GetDefaultTextObject(
                Main.ActualScreenWidth / 2 - 40,
                Main.ActualScreenHeight / 2 - 110,
                2.5,
                Left,
                GameConfig.UpgradeFontColor
            );
            healthText.text = '> 150';
            addChild(healthText);
        }

        // ----------------------
        // Damage
        // ----------------------

        // Default
        final damageText = TextUtils.GetDefaultTextObject(
            Main.ActualScreenWidth / 2 - 215,
            Main.ActualScreenHeight / 2 - 60,
            2.5,
            Left,
            GameConfig.DefaultFontColor
        );
        damageText.text = 'Damage: 10';
        addChild(damageText);

        if (levelUp) {
            // Upgrade
            final damageText = TextUtils.GetDefaultTextObject(
                Main.ActualScreenWidth / 2 - 40,
                Main.ActualScreenHeight / 2 - 60,
                2.5,
                Left,
                GameConfig.UpgradeFontColor
            );
            damageText.text = '> 15';
            addChild(damageText);
        }

        // ----------------------
        // Attack speed
        // ----------------------

        // Default
        final attackSpeedText = TextUtils.GetDefaultTextObject(
            Main.ActualScreenWidth / 2 - 215,
            Main.ActualScreenHeight / 2 - 10,
            2.5,
            Left,
            GameConfig.DefaultFontColor
        );
        attackSpeedText.text = 'Attack speed: 1';
        addChild(attackSpeedText);

        if (levelUp) {
            // Upgrade
            final attackSpeedText = TextUtils.GetDefaultTextObject(
                Main.ActualScreenWidth / 2 + 30,
                Main.ActualScreenHeight / 2 - 10,
                2.5,
                Left,
                GameConfig.UpgradeFontColor
            );
            attackSpeedText.text = '> 2';
            addChild(attackSpeedText);
        }
        
        // ----------------------
        // Movement speed
        // ----------------------

        // Default
        final movementSpeedText = TextUtils.GetDefaultTextObject(
            Main.ActualScreenWidth / 2 - 215,
            Main.ActualScreenHeight / 2 + 40,
            2.5,
            Left,
            GameConfig.DefaultFontColor
        );
        movementSpeedText.text = 'Movement speed: 100';
        addChild(movementSpeedText);

        if (levelUp) {
            // Upgrade
            final movementSpeedText = TextUtils.GetDefaultTextObject(
                Main.ActualScreenWidth / 2 + 110,
                Main.ActualScreenHeight / 2 + 40,
                2.5,
                Left,
                GameConfig.UpgradeFontColor
            );
            movementSpeedText.text = '> 110';
            addChild(movementSpeedText);
        }
    }

}