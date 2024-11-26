export enum CharacterType {
  RagnarLoh = 'RagnarLoh',
  ZombieBoy = 'ZombieBoy',
  ZombieGirl = 'ZombieGirl',
  HeadBoss = 'HeadBoss',
}

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
