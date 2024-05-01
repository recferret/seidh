package game;

import uuid.Uuid;

class Player {
	public static final instance:Player = new Player();

	public var playerId:String;
	public var playerEntityId:String;

	private var inputIndex = 0;

	private function new() {
		playerId = Uuid.short().toLowerCase();
		playerEntityId = "entity_" + playerId;
	}

	public function incrementAndGetInputIndex() {
		return ++inputIndex;
	}

	public function getInputIndex() {
		return inputIndex;
	}
}
