package game;

import game.js.NativeWindowJS;

enum ResourceProvider {
    LOCAL;
	YANDEX_S3;
}

class GameConfig {
	public static final RedColor = 0xF00F00;
	public static final GreenColor = 0x00FF00;
	public static final BlueColor = 0x0000FF;
	public static final YellowColor = 0xFFFF00;
	public static final HpBarColor = 0xc22a2a;
	public static final XpBarColor = 0xfcff76;
	public static final FontColor = 0xebddae;

	public final Production:Bool;
	public final DebugDraw:Bool;
	public final PlayMusic:Bool;
	public final PlaySounds:Bool;
	public final TelegramAuth:Bool;
	public final Analytics:Bool;
	public final ResProvider = ResourceProvider.LOCAL;

	public static final instance:GameConfig = new GameConfig();

	private function new() {
		final gameConfig = NativeWindowJS.getGameConfig();

		Production = gameConfig.Production;
		DebugDraw = gameConfig.DebugDraw;
		PlayMusic = gameConfig.PlayMusic;
		PlaySounds = gameConfig.PlaySounds;
		TelegramAuth = gameConfig.TelegramAuth;
		Analytics = gameConfig.Analytics;
	}

}
