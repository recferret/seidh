package game.sound;

import hxd.res.Sound;

class SoundManager {

    private final menuTheme:Sound;
    private final gameplayTheme:Sound;

    private final button1:Sound;
    private final button2:Sound;

    private final vikingDeath:Sound;
    private final vikingDmg:Sound;
    private final vikingHit:Sound;

    private final zombieDeath:Sound;
    private final zombieDmg:Sound;
    private final zombieHit:Sound;

    public function new() {
        if (hxd.res.Sound.supportedFormat(Mp3)) {
            menuTheme = hxd.Res.sound.menu_theme_1;
            gameplayTheme = hxd.Res.sound.gameplay_theme_1;

            button1 = hxd.Res.sound.button_1;
            button2 = hxd.Res.sound.button_2;
        
            vikingDeath = hxd.Res.sound.viking_death;
            vikingDmg = hxd.Res.sound.viking_dmg;
            vikingHit = hxd.Res.sound.viking_hit;
        
            zombieDeath = hxd.Res.sound.zombie_death;
            zombieDmg = hxd.Res.sound.zombie_dmg;
            zombieHit = hxd.Res.sound.zombie_hit;
        } else {
            trace('MP3 sound is not available');
        }
    }

    public function playMenuTheme() {
        if (menuTheme != null) {
            menuTheme.play(true);
        }
        if (gameplayTheme != null ){
            gameplayTheme.stop();
        }
    }

    public function playGameplayTheme() {
        if (menuTheme != null) {
            menuTheme.stop();
        }
        if (gameplayTheme != null) {
            gameplayTheme.play(true);
        }
    }

    public function playButton1() {
        if (button1 != null) {
            button1.play();
        }
    }

    public function playButton2() {
        if (button2 != null) {
            button2.play();
        }
    }

    public function playVikingDeath() {
        if (vikingDeath != null) {
            vikingDeath.play();
        }
    }

    public function playVikingDmg() {
        if (vikingDmg != null) {
            vikingDmg.play();
        }
    }

    public function playVikingHit() {
        if (vikingHit != null) {
            vikingHit.play();
        }
    }

    public function playZombieDeath() {
        if (zombieDeath != null) {
            zombieDeath.play();
        }
    }

    public function playZombieDmg() {
        if (zombieDmg != null) {
            zombieDmg.play();
        }
    }

    public function playZombieHit() {
        if (zombieHit != null) {
            zombieHit.play();
        }
    }

}