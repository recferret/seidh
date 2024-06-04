export enum Side {
	LEFT = 1,
	RIGHT = 2
}

export enum CharacterActionType {
	MOVE = 1,
	ACTION_MAIN = 2,
	ACTION_1 = 3,
	ACTION_2 = 4,
	ACTION_3 = 5,
	ACTION_ULTIMATE = 6
}

export enum EntityType {
	KNIGHT = 1,
	SAMURAI = 2,
	MAGE = 3,
	SKELETON_WARRIOR = 4,
	SKELETON_ARCHER = 5,
	PROJECTILE_MAGIC_ARROW = 6,
	PROJECTILE_MAGIC_SPHERE = 7,

	RAGNAR = 8,
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
	entityType:EntityType;
	entityShape:EntityShape;
	id: string;
	ownerId: string;
	rotation: number;
}

export interface CharacterMovementStruct {
	canWalk: boolean,
	canRun: boolean,
	walkSpeed: number,
	runSpeed: number,
	movementDelay: number,
	vitality: number,
	vitalityConsumptionPerSec: number,
	vitalityRegenPerSec: number,
}

export interface MeleeStruct {
	aoe: boolean,
	shape: EntityShape,
}

export interface ProjectileStruct {
	aoe: boolean,
	penetration: boolean,
	speed: number,
	travelDistance: number,
	projectiles:number ,
	shape: EntityShape,
	aoeShape?: EntityShape,
}

export interface CharacterActionStruct {
	actionType:CharacterActionType,
	damage:number,
	inputDelay:number,
	meleeStruct?:MeleeStruct,
	projectileStruct?:ProjectileStruct,
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

export interface CharacterEntityMinStruct {
	id: string,
	x: number,
	y: number,
	side: Side
}

export interface EngineCharacterEntity {
	getEntityFullStruct(): CharacterEntityFullStruct;
	getEntityMinStruct(): CharacterEntityMinStruct;
}

export interface EngineProjectileEntity {

}

export interface CharacterActionCallbackParams {
    entityId: string;
    actionType: CharacterActionType; 
    shape: EntityShape;
    hurtEntities: string[];
    deadEntities: string[];
}

export interface CreateCharacterMinStruct {
    id: string;
    ownerId: string;
    x: number;
    y: number;
    entityType: EntityType;
}

export interface PlayerInputCommand {
	index?: number;
	actionType: CharacterActionType;
	movAngle: number;
	playerId: string;
}