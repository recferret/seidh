package game;

import game.scene.impl.home.boost.BoostContent;
import game.scene.impl.home.boost.BoostContent.CurrencyType;
import game.scene.impl.home.boost.BoostContent.BoostType;
import game.js.NativeWindowJS;

typedef UserBody = {
	userId: String,
	coins: Int,
	teeth: Int,
};

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

	public static final instance: Player = new Player();

	public var userId: String;
	public var userEntityId: String;
	public var userName: String;
	public var coins: Int;
	public var teeth: Int;

	public final boosts = new Array<BoostBody>();
	public final boostsOwned = new Array<String>();

	private var inputIndex = 0;

	private function new() {
	}

	public function setUserData(userData:Dynamic) {
		userId = userData.userId;
		userEntityId = 'entity_' + userData.userId;
		userName = 'USER 1';
		coins = userData.coins;
		teeth = userData.teeth;
	}

	public function setBoostData(boostData:Array<BoostBody>) {
		boostsOwned.resize(0);

		for (boost in boostData) {
			boosts.push(boost);

			if (boost.levelOneAccquired) {
				boostsOwned.push(boost.levelOneId);
			}
			if (boost.levelTwoAccquired) {
				boostsOwned.push(boost.levelTwoId);
			}
			if (boost.levelThreeAccquired) {
				boostsOwned.push(boost.levelThreeId);
			}
		}
	}

	public function getExpLevel() {
		if (boostsOwned.contains(BoostContent.EXP_3))
			return 3;
		if (boostsOwned.contains(BoostContent.EXP_2))
			return 2;
		if (boostsOwned.contains(BoostContent.EXP_1))
			return 1;
		return 0;
	}

	public function getWealthLevel() {
		if (boostsOwned.contains(BoostContent.WEALTH_3))
			return 3;
		if (boostsOwned.contains(BoostContent.WEALTH_2))
			return 2;
		if (boostsOwned.contains(BoostContent.WEALTH_1))
			return 1;
		return 0;
	}

	public function getAttackLevel() {
		if (boostsOwned.contains(BoostContent.ATTACK_3))
			return 3;
		if (boostsOwned.contains(BoostContent.ATTACK_2))
			return 2;
		if (boostsOwned.contains(BoostContent.ATTACK_1))
			return 1;
		return 0;
	}

	public function getMonstersLevel() {
		if (boostsOwned.contains(BoostContent.MONSTERS_3))
			return 3;
		if (boostsOwned.contains(BoostContent.MONSTERS_2))
			return 2;
		if (boostsOwned.contains(BoostContent.MONSTERS_1))
			return 1;
		return 0;
	}

	public function getItemsLevel() {
		if (boostsOwned.contains(BoostContent.ITEMS_DROP_3))
			return 3;
		if (boostsOwned.contains(BoostContent.ITEMS_DROP_2))
			return 2;
		if (boostsOwned.contains(BoostContent.ITEMS_DROP_1))
			return 1;
		return 0;
	}

	public function getStatsLevel() {
		if (boostsOwned.contains(BoostContent.STATS_3))
			return 3;
		if (boostsOwned.contains(BoostContent.STATS_2))
			return 2;
		if (boostsOwned.contains(BoostContent.STATS_1))
			return 1;
		return 0;
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
