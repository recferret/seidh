package engine.seidh.types;

enum abstract CharacterAnimationState(Int) {
	var IDLE = 1;
	var RUN = 2;
	var DEATH = 3;
	var ACTION_MAIN = 4;
	var ACTION_1 = 5;
	var ACTION_2 = 6;
	var ACTION_3 = 7;
	var SPAWN = 8;
	var SPAWN_2 = 9;
}
