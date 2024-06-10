package game;

import uuid.Uuid;

class Player {
	public static final instance:Player = new Player();

	public var playerId:String;
	public var playerEntityId:String;

	public var userId:String;
	public var authToken:String;
	public var tokens:Int;
	public var kills:Int;

	private var inputIndex = 0;

	private function new() {
		playerId = Uuid.short().toLowerCase();
		playerEntityId = "entity_" + playerId;
	}

	public function setUserData(userData:Dynamic) {
		userId = userData.userId;
		authToken = userData.userId;
		tokens = userData.tokens;
		kills = userData.userId;
	}

	public function incrementAndGetInputIndex() {
		return ++inputIndex;
	}

	public function getInputIndex() {
		return inputIndex;
	}
}
