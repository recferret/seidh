package game;

import game.scene.impl.home.boost.BoostContent.CurrencyType;
import game.scene.impl.home.boost.BoostContent.BoostType;
import game.js.NativeWindowJS;

typedef BoostBody = {
	order: Int,
	boostType: BoostType,
	levelZeroName: String,
	levelOneId: String,
	levelOneName: String,
	levelOneDescription1: String,
	?levelOneDescription2: String,
	levelOnePrice: Int,
	levelOneCurrencyType: CurrencyType,
	levelOneAccquired: Bool,
	levelTwoId: String,
	levelTwoName: String,
	levelTwoDescription1: String,
	?levelTwoDescription2: String,
	levelTwoPrice: Int,
	levelTwoCurrencyType: CurrencyType,
	levelTwoAccquired: Bool,
	levelThreeId: String,
	levelThreeName: String,
	levelThreeDescription1: String,
	?levelThreeDescription2: String,
	levelThreePrice: Int,
	levelThreeCurrencyType: CurrencyType,
	levelThreeAccquired: Bool
};

class Player {
	private final WalletAddressKey = 'WalletAddress';

	public static final instance:Player = new Player();

	public var userId:String;
	public var userEntityId:String;
	public var userName:String;
	public var authToken:String;
	public var coins:Int;
	public var teeth:Int;
	public var kills:Int;

	public final boosts = new Array<BoostBody>();

	private var inputIndex = 0;

	private function new() {
	}

	public function setUserData(userData:Dynamic) {
		userId = userData.userId;
		userEntityId = 'entity_' + userData.userId;
		userName = 'USER 1';
		authToken = userData.authToken;
		coins = userData.coins;
		teeth = userData.teeth;
		kills = userData.kills;
	}

	public function setBoostData(boostData:Array<Dynamic>) {
		for (boost in boostData) {
			boosts.push(boost);
		}
	}

	public function incrementAndGetInputIndex() {
		return ++inputIndex;
	}

	public function getInputIndex() {
		return inputIndex;
	}

	// ------------------------------------------------------
	// Local storage
	// ------------------------------------------------------

	public function saveWalletAddress(walletAddress:String) {
		NativeWindowJS.lsSetItem(WalletAddressKey, walletAddress);
	}

	public function getWalletAddress() {
		return NativeWindowJS.lsGetItem(WalletAddressKey);
	}
}
