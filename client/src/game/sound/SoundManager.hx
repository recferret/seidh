package game.sound;

import hxd.res.Sound;

class SoundManager {

    private var initiated = false;

    private var menuTheme:Sound;
    private var gameplayTheme:Sound;

    private var button1:Sound;
    private var button2:Sound;

    private var vikingDeath:Sound;
    private var vikingDmg:Sound;
    private var vikingHit:Sound;

    private var zombieDeath:Sound;
    private var zombieDmg:Sound;
    private var zombieHit:Sound;

    public static final instance:SoundManager = new SoundManager();

    private function new() {
    }

    public function initiate() {
        if (!initiated) {
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