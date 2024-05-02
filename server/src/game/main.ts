import * as Engine from "./HolyGameEngine.cjs";
import { DisconnectedEvent, EventType, Events, InputEvent, JoinEvent } from "./events.js";
import { ServerTransport } from "./transport.js";

enum EntityType {
	KNIGHT = 1,
	SAMURAI = 2,
	MAGE = 3,
	SKELETON_WARRIOR = 4,
	SKELETON_ARCHER = 5,
}

enum EntityActionType {
	MELEE_ATTACK_1 = 1,
	MELEE_ATTACK_2 = 2,
	MELEE_ATTACK_3 = 3,
	RUN_ATTACK = 4,
	RANGED_ATTACK1 = 5,
	RANGED_ATTACK2 = 6,
	DEFEND = 7,
}

type EntityActionCallbackParams = { 
    entityId:string, 
    actionType:EntityActionType, 
    hurtEntities: string[],
    deadEntities: string[], 
};

class NodeServer {
    
    private transport = new ServerTransport()
    private readonly gameEngineInstance:any;

    // private readonly maxBots = 50;
    // private botIdIndex = 0;
    private currentBotsCount = 0;

    constructor() {
        const GameEngine: any = Engine.default;

        // ---------------------------------------------------------------------
        //  Эвенты от сокетов или Wt
        // ---------------------------------------------------------------------

        Events.eventEmitter.on(EventType.DISCONNECT, (data: DisconnectedEvent) => {
            this.gameEngineInstance.removeMainEntity(this.gameEngineInstance.getMainEntityIdByOwnerId(data.playerId));
        });

        Events.eventEmitter.on(EventType.JOIN, (data: JoinEvent) => {
            this.gameEngineInstance.buildEngineEntityFromMinimalStruct({
                id: 'entity_' + data.playerId,
                ownerId: data.playerId,
                x: 200,
                y: 200,
                entityType: EntityType.KNIGHT,
            });
        });

        Events.eventEmitter.on(EventType.INPUT, (data: InputEvent) => {
            this.gameEngineInstance.addInputCommandServer(data);
        });

        this.gameEngineInstance = new GameEngine.engine.holy.HolyGameEngine();

        this.gameEngineInstance.createMainEntityCallback = async (entity) => {
            if (entity.isPlayer) {
                const ownerId = entity.getOwnerId();

                if (!ServerTransport.PlayerInitiated(ownerId)) {
                    ServerTransport.InitiatePlayer(ownerId);
                    await this.transport.notifyPlayer(ownerId, 'reliable', this.joinGameMessage(this.gameEngineInstance.getMainEntities()));
                }
                await this.transport.notifyAll(this.createEntityMessage(entity), 'reliable', ownerId);
            } else {
                await this.transport.notifyAll(this.createEntityMessage(entity), 'reliable');
            }
        };
        this.gameEngineInstance.deleteMainEntityCallback = async (entity) => {
            await this.transport.notifyAll(this.deleteEntityMessage(entity.getId()), 'reliable');

            if (entity.baseObjectEntity.entityType == EntityType.SKELETON_WARRIOR) {
                this.currentBotsCount--;
            }
        };
        this.gameEngineInstance.postLoopCallback = async () => {
            await this.transport.notifyAll(this.gameStateMessage(this.gameEngineInstance.getMainEntitiesChanged()), 'unreliable');
        };
        this.gameEngineInstance.entityActionCallback = async (callbackParams: EntityActionCallbackParams[]) => {
            await this.transport.notifyAll(this.performActionMessage(callbackParams), 'reliable');
        };

        // setInterval(() => {
        //     let skeletonPosX = 400;
        //     let skeletonPosY = 400;

        //     for (let i = 0; i < 5; i++) {
        //         if (this.currentBotsCount < this.maxBots) {
        //             this.gameEngineInstance.buildEngineEntityFromMinimalStruct({
        //                 id: 'entity_' + this.botIdIndex++,
        //                 ownerId: 1,
        //                 x: skeletonPosX,
        //                 y: skeletonPosY,
        //                 entityType: EntityType.SKELETON_WARRIOR,
        //             });
                
        //             skeletonPosX += 80;
                
        //             if (i == 4) {
        //                 skeletonPosY += 80;
        //                 skeletonPosX = 400;
        //             }
    
        //             this.currentBotsCount++;
        //         }
        //     }
        // }, 10000);
    }

    joinGameMessage(entitiesMap:any) {
        const entitiesInfo = [];

        for (const entity of entitiesMap.values()){
            entitiesInfo.push(entity.getFullEntity());
        }

        return JSON.stringify({
            msg: 'joinGame',
            entities: entitiesInfo
        });
    }

    gameStateMessage(entitiesMap:any) {
        const entitiesInfo = [];

        for (const entity of entitiesMap.values()) {
            entitiesInfo.push(entity.getMinEntity());
            console.log(entity.getMinEntity());
        }

        return JSON.stringify({
            msg: 'gameState',
            entities: entitiesInfo
        });
    }

    createEntityMessage(entity: any) {
        return JSON.stringify({
            msg: 'createEntity',
            entity: entity.getFullEntity()
        });
    }

    deleteEntityMessage(entityId: string) {
        return JSON.stringify({
            msg: 'deleteEntity',
            entityId
        });
    }

    performActionMessage(actions: EntityActionCallbackParams[]) {
        return JSON.stringify({
            msg: 'performAction',
            actions
       });
    }
    
}
  
new NodeServer();