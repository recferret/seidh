package game;

import game.js.NativeWindowJS;

typedef BoostBody = {
	id:String,
	name:String,
	description:String,
	price:Int,
	accquired:Bool,
};

class Player {
	private final WalletAddressKey = 'WalletAddress';

	public static final instance:Player = new Player();

	public var userId:String;
	public var userEntityId:String;
	public var userName:String;
	public var authToken:String;
	public var tokens:Int;
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
		tokens = userData.virtualTokenBalance;
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
