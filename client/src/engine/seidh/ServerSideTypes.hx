package engine.seidh;

export interface CharacterMovementStruct {
	runSpeed: number;
	speedFactor: number;
	inputDelay: number;
  }
  
  export interface CharacterActionStruct {
	damage: number;
	inputDelay: number;
	meleeStruct: {
	  aoe: boolean;
	  shape: {
		width: number;
		height: number;
		rectOffsetX: number;
		rectOffsetY: number;
	  };
	};
  }
  
  export interface CharacterEntityShape {
	width: number;
	height: number;
	rectOffsetX: number;
	rectOffsetY: number;
	radius: number;
  }
  
  export interface CharacterParams {
	type: CharacterType;
	levelCurrent: number;
	levelMax: number;
	expCurrent: number;
	expTillNewLevel: number;
	health: number;
	entityShape: CharacterEntityShape;
	movement: CharacterMovementStruct;
	actionMain: CharacterActionStruct;
  }

typedef ServerSideCharacterStruct = {

};

//

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

	// Characters

	ragnarLoh: {},
	zombieBoy: {},
	zombieGirl: {},
};