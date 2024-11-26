import {
  CharacterMovementStruct,
  CharacterActionStruct,
} from './types.character';

export enum Side {
  LEFT = 1,
  RIGHT = 2,
}

export enum EngineMode {
  CLIENT_SINGLEPLAYER = 1,
  CLIENT_MULTIPLAYER = 2,
  SERVER = 3,
}

export enum WinCondition {
  KILL_MOBS = 1,
  INFINITE = 2,
}

export enum CharacterActionType {
  MOVE = 1,
  ACTION_MAIN = 2,
  ACTION_1 = 3,
  ACTION_2 = 4,
  ACTION_3 = 5,
  ACTION_ULTIMATE = 6,
}

// -------------------------------------
// JS engine callback types
// -------------------------------------

export interface DeleteConsumableCallback {
  entityId: string;
  takenByCharacterId: string;
}

export interface CharacterActionCallbackParams {
  entityId: string;
  actionType: CharacterActionType;
  shape: EntityShape;
  hurtEntities: string[];
  deadEntities: string[];
}

// -------------------------------------
// JS engine object types
// -------------------------------------

export enum EntityType {
  RAGNAR_LOH = 1,
  ZOMBIE_BOY = 2,
  ZOMBIE_GIRL = 3,

  SMALL_COIN = 99,
}

export interface CharacterEntityMinStruct {
  id: string;
  x: number;
  y: number;
  health: number;
  side: Side;
}

export interface EntityShape {
  width: number;
  height: number;
  rectOffsetX: number;
  rectOffsetY: number;
}

export interface BaseEntityStruct {
  x: number;
  y: number;
  entityType: EntityType;
  entityShape: EntityShape;
  id: string;
  ownerId: string;
  rotation: number;
}

export interface ConsumableEntityStruct {
  baseEntityStruct: BaseEntityStruct;
  amount: number;
}

export interface CharacterMinStruct {
  id: string;
  ownerId: string;
  x: number;
  y: number;
  entityType: EntityType;
}

export interface CharacterEntityFullStruct {
  base: BaseEntityStruct;
  health: number;
  movement: CharacterMovementStruct;
  actionMain: CharacterActionStruct;
  action1: CharacterActionStruct;
  action2: CharacterActionStruct;
  action3: CharacterActionStruct;
  actionUltimate: CharacterActionStruct;
}

export interface EngineCharacterEntity {
  getEntityFullStruct(): CharacterEntityFullStruct;
  getEntityMinStruct(): CharacterEntityMinStruct;
  getId(): string;
  getOwnerId(): string;
  isPlayer(): boolean;
  isBot(): boolean;
}

export interface EngineConsumableEntity {
  getEntityBaseStruct(): BaseEntityStruct;
  amount: number;
}

export interface PlayerInputCommand {
  index?: number;
  actionType: CharacterActionType;
  movAngle: number;
  userId: string;
}
