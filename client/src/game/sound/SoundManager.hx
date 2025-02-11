package game.sound;

import game.Res.SeidhResource;
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

    public function init() {
        if (!initiated) {
            if (hxd.res.Sound.supportedFormat(Mp3)) {
                final manager = hxd.snd.Manager.get();
                manager.masterVolume = 0.25;
                manager.masterSoundGroup.maxAudible = 10;
    
                menuTheme = Res.instance.getSoundResource(SeidhResource.SOUND_MENU_THEME);
                gameplayTheme = Res.instance.getSoundResource(SeidhResource.SOUND_GAMEPLAY_THEME);
    
                button1 = Res.instance.getSoundResource(SeidhResource.SOUND_BUTTON_1);
                button2 = Res.instance.getSoundResource(SeidhResource.SOUND_BUTTON_2);
            
                vikingDeath = Res.instance.getSoundResource(SeidhResource.SOUND_VIKING_DEATH);
                vikingDmg = Res.instance.getSoundResource(SeidhResource.SOUND_VIKING_DMG);
                vikingHit = Res.instance.getSoundResource(SeidhResource.SOUND_VIKING_HIT);
            
                zombieDeath = Res.instance.getSoundResource(SeidhResource.SOUND_ZOMBIE_DEATH);
                zombieDmg = Res.instance.getSoundResource(SeidhResource.SOUND_ZOMBIE_DMG);
                zombieHit = Res.instance.getSoundResource(SeidhResource.SOUND_ZOMBIE_HIT);
            } else {
                trace('MP3 sound is not available');
            }
        }
    }

    public function playMenuTheme() {
        if (menuTheme != null && GameClientConfig.instance.PlayMusic) {
            menuTheme.play(true);
        }
        if (gameplayTheme != null ){
            gameplayTheme.stop();
        }
    }

    public function playGameplayTheme() {
        if (gameplayTheme != null && GameClientConfig.instance.PlayMusic) {
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
        return sound != null && GameClientConfig.instance.PlaySounds && haxe.Timer.stamp() - sound.lastPlay > 0.1;
    }

}