export enum CharacterType {
  RagnarLoh = 'RagnarLoh',
  ZombieBoy = 'ZombieBoy',
  ZombieGirl = 'ZombieGirl',
  HeadBoss = 'HeadBoss',
}

export enum CharacterLevelEffectType {
  DefensiveSkill = 'DefensiveSkill',
  PassiveTrait = 'PassiveTrait',
  PassiveSkill = 'PassiveSkill',
  ActiveSkill = 'ActiveSkill',
  UltimateSkill = 'UltimateSkill',
  ConsumableSlot = 'ConsumableSlot',
}

export enum CharacterSkillPassiveTrait {
  Stats = 'Stats',
  CriticalAttack = 'CriticalAttack',
  Dodge = 'Dodge',
  Armor = 'Armor',
  Regeneration = 'Regeneration',
}

export enum CharacterSkillPassiveSkill {
  Stats = 'Stats',
  CriticalAttack = 'CriticalAttack',
  Dodge = 'Dodge',
  Armor = 'Armor',
  Regeneration = 'Regeneration',
}

export enum CharacterSkillActiveSkill {
  Roll = 'Roll',
  Fireball = 'Fireball',
  BowShot = 'BowShot',
}

export enum CharacterActionType {
  Attack = 'Attack',
  Buff = 'Buff',
  Summon = 'Summon',
}

export interface CharacterMovementStruct {
  runSpeed: number;
  speedFactor: number;
  inputDelay: number;
}

export interface CharacterActionStruct {
  damage?: number;
  inputDelay: number;
  animDurationMs: number;
  actionType: CharacterActionType;
  meleeStruct?: {
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

export interface CharacterEntityParams {
  type: CharacterType;
  levelCurrent: number;
  levelMax: number;
  expCurrent: number;
  expTillNextLevel: number;
  health: number;
  entityShape: CharacterEntityShape;
  movement: CharacterMovementStruct;
  actionMain: CharacterActionStruct;
}
