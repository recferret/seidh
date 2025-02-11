package engine.seidh.entity;

import engine.base.types.TypesBaseEntity;
import engine.seidh.types.TypesSeidhGame;

class CharacterEntityConfig {

    public static final CHARACTERS_CONFIG:CharacterDefaultConfigs = {
        ragnarLoh: {
            type: EntityType.RAGNAR_LOH,
            movement: {
                canRun: false,
                runSpeed: 40,
                speedFactor: 10,
                inputDelay: 0.100,
            },
            entityShape: {
                width: 180,
                height: 260,
                rectOffsetX: 0,
                rectOffsetY: 0,
                radius: 150,
            },
            actionMain: {
                actionType: CharacterActionType.ACTION_MAIN,
                actionEffect: CharacterActionEffect.ATTACK,
                damage: 5,
                inputDelay: 1,
                performDelayMs: 100,
                postDelayMs: 0,
                meleeStruct: {
                    aoe: true,
                    shape: {
                        width: 350, 
                        height: 260, 
                        rectOffsetX: 85, // shape.width / 2 - entityShape.width / 2 
                        rectOffsetY: 0,
                        radius: 0,
                    },
                }
            },
            health: 100,
        },
        zombieBoy: {
            type: EntityType.ZOMBIE_BOY,
            movement: {
                canRun: false,
                runSpeed: 10,
                speedFactor: 10,
                inputDelay: 0.100,
            },
            entityShape: {
                width: 200,
                height: 260,
                rectOffsetX: 0,
                rectOffsetY: 0,
                radius: 0,
            },
            actionMain: {
                actionType: CharacterActionType.ACTION_MAIN,
                actionEffect: CharacterActionEffect.ATTACK,
                damage: 1,
                inputDelay: 1,
                performDelayMs: 100,
                postDelayMs: 0,
                meleeStruct: {
                    aoe: false,
                    shape: {
                        width: 260,
                        height: 260,
                        rectOffsetX: 30, // shape.width / 2 - entityShape.width / 2 
                        rectOffsetY: 0,
                        radius: 0,
                    },
                }
            },
            health: 10,
        },
        zombieGirl: {
            type: EntityType.ZOMBIE_GIRL,
            movement: {
                canRun: false,
                runSpeed: 10,
                speedFactor: 10,
                inputDelay: 0.100,
            },
            entityShape: {
                width: 200,
                height: 260,
                rectOffsetX: 0,
                rectOffsetY: 0,
                radius: 0,
            },
            actionMain: {
                actionType: CharacterActionType.ACTION_MAIN,
                actionEffect: CharacterActionEffect.ATTACK,
                damage: 1,
                inputDelay: 1,
                performDelayMs: 100,
                postDelayMs: 0,
                meleeStruct: {
                    aoe: false,
                    shape: {
                        width: 260,
                        height: 260,
                        rectOffsetX: 30,
                        rectOffsetY: 0,
                        radius: 0,
                    },
                }
            },
            health: 10,
        },
        glamr: {
            type: EntityType.GLAMR,
            movement: {
                canRun: false,
                runSpeed: 20,
                speedFactor: 10,
                inputDelay: 0.100,
            },
            entityShape: {
                width: 200,
                height: 260,
                rectOffsetX: 0,
                rectOffsetY: 0,
                radius: 0,
            },
            actionMain: {
                actionType: CharacterActionType.ACTION_MAIN,
                actionEffect: CharacterActionEffect.ATTACK,
                damage: 8,
                inputDelay: 3,
                performDelayMs: 500,
                postDelayMs: 0,
                meleeStruct: {
                    aoe: true,
                    shape: {
                        width: 450,
                        height: 400,
                        rectOffsetX: 125, // shape.width / 2 - entityShape.width / 2 
                        rectOffsetY: 0,
                        radius: 0,
                    },
                }
            },
            action1: {
                actionType: CharacterActionType.ACTION_1,
                actionEffect: CharacterActionEffect.SUMMON,
                inputDelay: 10,
                performDelayMs: 1000,
                postDelayMs: 1000,
            },
            action2: {
                actionType: CharacterActionType.ACTION_2,
                actionEffect: CharacterActionEffect.TELEPORT,
                inputDelay: 10,
                performDelayMs: 350,
                postDelayMs: 0,
            },
            health: 150,
        },
    };

}