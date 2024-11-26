// export enum EntityType {
//   RAGNAR_LOH = 1,
//   RAGNAR_NORM = 2,
//   ZOMBIE_BOY = 3,
//   ZOMBIE_GIRL = 4,

//   SMALL_COIN = 99,
// }

// export interface EntityShape {
//   width: number;
//   height: number;
//   rectOffsetX: number;
//   rectOffsetY: number;
// }

// export interface BaseEntityStruct {
//   x: number;
//   y: number;
//   entityType: EntityType;
//   entityShape: EntityShape;
//   id: string;
//   ownerId: string;
//   rotation: number;
// }

// export interface MeleeStruct {
//   aoe: boolean;
//   shape: EntityShape;
// }

// export interface ProjectileStruct {
//   aoe: boolean;
//   penetration: boolean;
//   speed: number;
//   travelDistance: number;
//   projectiles: number;
//   shape: EntityShape;
//   aoeShape?: EntityShape;
// }

// export interface BaseEntityStruct {
//   x: number;
//   y: number;
//   entityType: EntityType;
//   entityShape: EntityShape;
//   id: string;
//   ownerId: string;
//   rotation: number;
// }

// export interface EngineCharacterEntity {
//   getEntityFullStruct(): CharacterEntityFullStruct;
//   getEntityMinStruct(): CharacterEntityMinStruct;
//   getId(): string;
//   getOwnerId(): string;
//   isPlayer(): boolean;
//   isBot(): boolean;
// }

// export interface EngineProjectileEntity {}

// export interface EngineConsumableEntity {
//   getEntityBaseStruct(): BaseEntityStruct;
//   amount: number;
// }

// export interface DeleteConsumableEntityTask {
//   entityId: string;
//   takenByCharacterId: string;
// }

// export enum GameState {
//   PLAYING = 1,
//   WIN = 2,
// }
