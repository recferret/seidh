package game.sound;

import hxd.res.Sound;

class SoundManager {

    private final menuTheme:Sound;
    private final gameplayTheme:Sound;

    public function new() {
        if (hxd.res.Sound.supportedFormat(Mp3)){
            menuTheme = hxd.Res.sound.menu_theme_1;
            gameplayTheme = hxd.Res.sound.gameplay_theme_1;
        } else {
            trace('MP3 sound is not available');
        }
    }

    public function playMenuTheme() {
        if (menuTheme != null){
            menuTheme.play(true);
        }
        if (gameplayTheme != null){
            gameplayTheme.stop();
        }
    }

    public function playGameplayTheme() {
        if (menuTheme != null){
            menuTheme.stop();
        }
        if (gameplayTheme != null){
            gameplayTheme.play(true);
        }
    }

}