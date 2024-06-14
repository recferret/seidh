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
            final manager = hxd.snd.Manager.get();
            manager.masterVolume = 0.25;
            manager.masterSoundGroup.maxAudible = 5;

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
        if (menuTheme != null && GameConfig.PlayMusic) {
            menuTheme.play(true);
        }
        if (gameplayTheme != null ){
            gameplayTheme.stop();
        }
    }

    public function playGameplayTheme() {
        if (gameplayTheme != null && GameConfig.PlayMusic) {
            gameplayTheme.play(true);
        }
        if (menuTheme != null) {
            menuTheme.stop();
        }
    }

    public function playButton1() {
        if (allowPlaySound(button1)) {
            button1.play();
        }
    }

    public function playButton2() {
        if (allowPlaySound(button2)) {
            button2.play();
        }
    }

    public function playVikingDeath() {
        if (allowPlaySound(vikingDeath)) {
            vikingDeath.play();
        }
    }

    public function playVikingDmg() {
        if (allowPlaySound(vikingDmg)) {
            vikingDmg.play();
        }
    }

    public function playVikingHit() {
        if (allowPlaySound(vikingHit)) {
            vikingHit.play();
        }
    }

    public function playZombieDeath() {
        if (allowPlaySound(zombieDeath)) {
            zombieDeath.play();
        }
    }

    public function playZombieDmg() {
        if (allowPlaySound(zombieDmg)) {
            zombieDmg.play();
        }
    }

    public function playZombieHit() {
        if (allowPlaySound(zombieHit)) {
            zombieHit.play();
        }
    }

    private function allowPlaySound(sound:Sound) {
        return sound != null && GameConfig.PlaySounds && haxe.Timer.stamp() - sound.lastPlay > 0.25;
    }

}