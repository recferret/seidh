package engine.seidh.types;

import engine.base.types.TypesBaseEntity.ShapeStruct;
import engine.base.types.TypesBaseEntity.EntityType;
import engine.base.types.TypesBaseEntity.CharacterMovementStruct;
import engine.base.types.TypesBaseEntity.CharacterActionStruct;

enum abstract WinCondition(Int) {
	var KILL_MOBS = 1;
	var INFINITE = 2;
	var SURVIVE = 3;
}

typedef GameConfig = {
	// Mobs spawn
	mobsMaxAtTheSameTime: Int,
	mobsMaxPerGame: Int,
	mobSpawnDelayMs: Int,

	// Exp boost
	expLevel1Multiplier: Float,
	expLevel2Multiplier: Float,
	expLevel3Multiplier: Float,

	// Stats boost
	statsLevel1Multiplier: Float,
	statsLevel2Multiplier: Float,
	statsLevel3Multiplier: Float,

	// Wealth boost
	wealthLevel1PickUpRangeMultiplier: Float,
	wealthLevel2PickUpRangeMultiplier: Float,
	wealthLevel3PickUpRangeMultiplier: Float,

	wealthLevel1CoinsMultiplier: Float,
	wealthLevel2CoinsMultiplier: Float,
	wealthLevel3CoinsMultiplier: Float,
};

typedef CharacterDefaultConfig = {
	type: EntityType,
	entityShape: ShapeStruct,
	movement: CharacterMovementStruct,
	actionMain: CharacterActionStruct,
	health:Int,
};

typedef CharacterDefaultConfigs = {
	ragnarLoh: CharacterDefaultConfig,
	zombieBoy: CharacterDefaultConfig,
	zombieGirl: CharacterDefaultConfig,
};