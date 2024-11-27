package engine.base.types;

import engine.base.types.TypesBaseEntity;

// -------------------------------
// Multiplayer
// -------------------------------

class PlayerInputCommand {
	public var index:Int;
	public var actionType:CharacterActionType;
	public var movAngle:Float;
	public var userId:String;

	public function new(actionType:CharacterActionType, movAngle:Float, userId:String, ?index:Int) {
		this.actionType = actionType;
		this.movAngle = movAngle;
		this.userId = userId;
		this.index = index;
	}
}

class InputCommandEngineWrapped {
	public var playerInputCommand:PlayerInputCommand;
	public var tick:Int;

	public function new(playerInputCommand:PlayerInputCommand, tick:Int) {
		this.playerInputCommand = playerInputCommand;
		this.tick = tick;
	}
}