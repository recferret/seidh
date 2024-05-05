package game.scene.impl;

import game.effects.SlashEffect;
import game.effects.SlashEffect.SlashEffectType;
import h2d.Tile;
import engine.base.BaseTypesAndClasses.EntityAnimationState;
// import engine.seidh.SeidhGameEngine;
import game.scene.base.BasicScene;

class SceneSpritesTest extends BasicScene {

    public function new() {
		super(null);

		// var knightX = 0;
		// for (anim in [IDLE, WALK, RUN, ATTACK_1, ATTACK_2, ATTACK_3, ATTACK_RUN, HURT, DEAD, DEFEND]) {
		// 	final knight = new KnightEntity(this);
		// 	knight.setAnimationState(anim);
		// 	knight.setPosition(knightX, 0);
		// 	addChild(knight);

		// 	knightX += 100;
		// }

		// var samuraiX = 0;
		// for (anim in [IDLE, WALK, RUN, ATTACK_1, ATTACK_2, ATTACK_3, SHOT_1, HURT, DEAD]) {
		// 	final samurai = new SamuraiEntity(this);
		// 	samurai.setAnimationState(anim);
		// 	samurai.setPosition(samuraiX, 100);
		// 	addChild(samurai);

		// 	samuraiX += 100;
		// }

		// var skeletonWarriorX = 0;
		// for (anim in [IDLE, WALK, RUN, ATTACK_1, ATTACK_2, ATTACK_3, ATTACK_RUN, HURT, DEAD]) {
		// 	final skeletonWarrior = new SkeletonWarriorEntity(this);
		// 	skeletonWarrior.setAnimationState(anim);
		// 	skeletonWarrior.setPosition(skeletonWarriorX, 200);
		// 	addChild(skeletonWarrior);

		// 	skeletonWarriorX += 100;
		// }

		// var skeletonArcherX = 0;
		// for (anim in [IDLE, WALK, ATTACK_1, ATTACK_2, ATTACK_3, SHOT_1, SHOT_2, HURT, DEAD, DODGE]) {
		// 	final skeletonArcher = new SkeletonArcherEntity(this);
		// 	skeletonArcher.setAnimationState(anim);
		// 	skeletonArcher.setPosition(skeletonArcherX, 300);
		// 	addChild(skeletonArcher);

		// 	skeletonArcherX += 100;
		// }

		// var mageX = 0;
		// for (anim in [IDLE, WALK, RUN, ATTACK_1, ATTACK_2, SHOT_1, SHOT_2, HURT, DEAD]) {
		// 	final mage = new MageEntity(this);
		// 	mage.setAnimationState(anim);
		// 	mage.setPosition(mageX, 400);
		// 	addChild(mage);

		// 	mageX += 100;
		// }

		// final skeletonRunEntity = new SkeletonEntity(this);
		// skeletonRunEntity.setAnimationState(CharacterAnimationState.Run);
		// skeletonRunEntity.setPosition(100, 100);
		// addChild(skeletonRunEntity);

		// final skeletonWalkEntity = new SkeletonEntity(this);
		// warrior1WalkEntity.setAnimationState(CharacterAnimationState.Walk);
		// warrior1WalkEntity.setPosition(200, 100);
		// addChild(warrior1WalkEntity);

		// final skeletonDeadEntity = new SkeletonEntity(this);
		// skeletonDeadEntity.setAnimationState(CharacterAnimationState.Dead);
		// skeletonDeadEntity.setPosition(300, 100);
		// addChild(skeletonDeadEntity);

		// final skeletonHurtEntity = new SkeletonEntity(this);
		// skeletonHurtEntity.setAnimationState(CharacterAnimationState.Hurt);
		// skeletonHurtEntity.setPosition(400, 100);
		// addChild(skeletonHurtEntity);

		// final skeletonAttack1Entity = new SkeletonEntity(this);
		// skeletonAttack1Entity.setAnimationState(CharacterAnimationState.Attack1);
		// skeletonAttack1Entity.setPosition(500, 100);
		// addChild(skeletonAttack1Entity);

		// final skeletonAttack2Entity = new SkeletonEntity(this);
		// skeletonAttack2Entity.setAnimationState(CharacterAnimationState.Attack2);
		// skeletonAttack2Entity.setPosition(600, 100);
		// addChild(skeletonAttack2Entity);

		// final skeletonAttack3Entity = new SkeletonEntity(this);
		// skeletonAttack3Entity.setAnimationState(CharacterAnimationState.Attack3);
		// skeletonAttack3Entity.setPosition(700, 100);
		// addChild(skeletonAttack3Entity);

		// final skeletonSpecialAttackEntity = new SkeletonEntity(this);
		// skeletonSpecialAttackEntity.setAnimationState(CharacterAnimationState.RunAttack);
		// skeletonSpecialAttackEntity.setPosition(800, 100);
		// addChild(skeletonSpecialAttackEntity);
    }

    // --------------------------------------
	// Impl
	// --------------------------------------

	public function start() {
	}

	public function customUpdate(dt:Float, fps:Float) {
	}

}