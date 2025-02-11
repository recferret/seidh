package game;

import game.js.NativeWindowJS;

class GameClientConfig {
	public static final RedColor = 0xF00F00;
	public static final GreenColor = 0x00FF00;
	public static final BlueColor = 0x0000FF;
	public static final YellowColor = 0xFFFF00;
	public static final HpBarColor = 0xc22a2a;
	public static final BossHpBarColor = 0x831c1c;
	public static final XpBarColor = 0x322C19;
	public static final XpRingColor = 0xC99859;
	public static final DefaultFontColor = 0xD1B15C;
	public static final WhiteFontColor = 0xDBD1B8;
	public static final UpgradeFontColor = 0x54A227;
	public static final ErrorFontColor = 0xA23E27;
	public static final UiBrownColor = 0x332D1A;
	public static final DarkBgColor = 0x15161A;
	public static final SelectorActiveBgColor = 0x121417;
	public static final SelectorInactiveBgColor = 0x44504C;

	// --------------------------------------
	// Ragnar adjustments
	// --------------------------------------

	public final adjustRagnar = false;

	public var CharacterMovementSpeed = 0;
	public var CharacterMovementInputDelay = 0.0;

	public var CharacterActionMainWidth = 0;
	public var CharacterActionMainHeight = 0;
	public var CharacterActionMainOffsetX = 0;
	public var CharacterActionMainOffsetY = 0;
	public var CharacterActionMainInputDelay = 1.0;
	public var CharacterActionMainDamage = 0;
	// --------------------------------------

	// TODO strings to enum
	public final DebugDraw:Bool;
	public final PlayMusic:Bool;
	public final PlaySounds:Bool;
	// public final TelegramAuth:Bool;
	// public final TelegramTestAuth:Bool;
	// public final TelegramInitData:String;
	public final Analytics:Bool;
	public final TestLogin:String;
	public final TestReferrerId:String;
	public final JoinGameType:String;
	public final Platform:String;

	public static final instance:GameClientConfig = new GameClientConfig();

	private function new() {
		final appConfig = NativeWindowJS.getAppConfig();

		DebugDraw = appConfig.DebugDraw;
		PlayMusic = appConfig.PlayMusic;
		PlaySounds = appConfig.PlaySounds;
		// TelegramAuth = appConfig.TelegramAuth;
		// TelegramTestAuth = appConfig.TelegramTestAuth;
		// TelegramInitData = appConfig.TelegramInitData;
		Analytics = appConfig.Analytics;
		TestLogin = appConfig.TestLogin;
		TestReferrerId = appConfig.TestReferrerId;
		JoinGameType = appConfig.JoinGameType;

		Platform = NativeWindowJS.getPlatform();
	}

}
