package game;

import game.js.NativeWindowJS;

enum ResourceProvider {
    LOCAL;
	YANDEX_S3;
}

class GameClientConfig {
	public static final RedColor = 0xF00F00;
	public static final GreenColor = 0x00FF00;
	public static final BlueColor = 0x0000FF;
	public static final YellowColor = 0xFFFF00;
	public static final HpBarColor = 0xc22a2a;
	public static final XpBarColor = 0xfcff76;
	public static final DefaultFontColor = 0xD1B15C;
	public static final WhiteFontColor = 0xDBD1B8;
	public static final UpgradeFontColor = 0x54A227;
	public static final ErrorFontColor = 0xA23E27;
	public static final UiBrownColor = 0x332D1A;

	public final Production:Bool;
	public final DebugDraw:Bool;
	public final PlayMusic:Bool;
	public final PlaySounds:Bool;
	public final TelegramAuth:Bool;
	public final TelegramTestAuth:Bool;
	public final TelegramInitData:String;
	public final Analytics:Bool;
	public final Serverless:Bool;
	public final TestLogin:String;
	public final TestReferrerId:String;
	public final JoinGameType:String;
	public final ResProvider = ResourceProvider.LOCAL;

	public static final instance:GameClientConfig = new GameClientConfig();

	private function new() {
		final appConfig = NativeWindowJS.getAppConfig();

		Production = appConfig.Production;
		DebugDraw = appConfig.DebugDraw;
		PlayMusic = appConfig.PlayMusic;
		PlaySounds = appConfig.PlaySounds;
		TelegramAuth = appConfig.TelegramAuth;
		TelegramTestAuth = appConfig.TelegramTestAuth;
		TelegramInitData = appConfig.TelegramInitData;
		Analytics = appConfig.Analytics;
		Serverless = appConfig.Serverless;
		TestLogin = appConfig.TestLogin;
		TestReferrerId = appConfig.TestReferrerId;
		JoinGameType = appConfig.JoinGameType;
	}

}
