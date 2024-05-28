import { GameType } from "@app/seidh-common/dto/gameplay-lobby/gameplay-lobby.find.game.msg";
import * as Engine from "../js/SeidhGameEngine";
import { 
    EngineCharacterEntity,
    EngineProjectileEntity,
    CharacterEntityMinStruct,
    CharacterActionCallbackParams,
    PlayerInputCommand,
    CreateCharacterMinStruct,
    EntityType,
    CharacterEntityFullStruct, 
} from "@app/seidh-common/seidh-common.game-types";
import { EventEmitter2 } from "@nestjs/event-emitter";
import { EventGameGameState } from "../events/event.game.state";
import { EventGameCharacterActions } from "../events/event.game.character-actions";
import { EventGameCreateCharacter } from "../events/event.game.create-character";
import { EventGameCreateProjectile } from "../events/event.game.create-projectile";
import { EventGameDeleteCharacter } from "../events/event.game.delete-character";
import { EventGameDeleteProjectile } from "../events/event.game.delete-projectile";
import { Logger } from "@nestjs/common";

export class GameInstance {

    private readonly engine: Engine.SeidhGameEngine;
    private dummyCounter = 1;

    constructor(private eventEmitter: EventEmitter2, public gameId: string, public gameType: GameType) {
        this.engine = new Engine.engine.seidh.SeidhGameEngine();

        // -----------------------------------
        // Engine callbacks
        // -----------------------------------

        this.engine.createCharacterCallback = (characterEntity: EngineCharacterEntity) => {
            this.eventEmitter.emit(
                EventGameCreateCharacter.EventName, 
                new EventGameCreateCharacter(gameId, characterEntity.getEntityFullStruct())
            );
        };

        this.engine.deleteCharacterCallback = (characterEntity: EngineCharacterEntity) => {
            this.eventEmitter.emit(
                EventGameDeleteCharacter.EventName,
                new EventGameDeleteCharacter(gameId, characterEntity.getEntityMinStruct().id)
            );
        };

        this.engine.createProjectileCallback = (projectileEntity: EngineProjectileEntity) => {
            this.eventEmitter.emit(EventGameCreateProjectile.EventName, new EventGameCreateProjectile(gameId));
        };

        this.engine.deleteProjectileCallback = (projectileEntity: EngineProjectileEntity) => {
            this.eventEmitter.emit(EventGameDeleteProjectile.EventName, new EventGameDeleteProjectile(gameId));
        };

        this.engine.postLoopCallback = () => {
            const charactersMinStruct: CharacterEntityMinStruct[] = [];
            for (const entity of this.engine.getCharactersStruct({ changed: true, full: false })) {
                charactersMinStruct.push(entity);
            }

            const charactersFullStruct: CharacterEntityFullStruct[] = [];
            for (const entity of this.engine.getCharactersStruct({ changed: false, full: true })) {
                charactersFullStruct.push(entity);
            }

            if (charactersMinStruct.length > 0 || charactersFullStruct.length > 0) {
                this.eventEmitter.emit(
                    EventGameGameState.EventName, 
                    new EventGameGameState(
                        gameId,
                        charactersMinStruct,
                        charactersFullStruct
                    )
                );
            }
        };

        this.engine.characterActionCallbacks = (actions: CharacterActionCallbackParams[]) => {
            Logger.log('characterActionCallbacks', 'GameInstance');
            this.eventEmitter.emit(
                EventGameCharacterActions.EventName, 
                new EventGameCharacterActions(
                    gameId,
                    actions
                )
            );
        };
    }

    // Client commands

    input(input: PlayerInputCommand) {
        this.engine.addInputCommandServer(input);
    }

    // Common

    addPlayer(playerId: string) {
        const struct: CreateCharacterMinStruct = {
            id: 'entity_' + playerId,
            ownerId: playerId,
            x: 200 * this.dummyCounter++,
            y: 200,
            entityType: EntityType.KNIGHT,
        };
        this.engine.createCharacterEntityFromMinimalStruct(struct);
    }

    deletePlayer(playerId: string) {
        this.engine.deleteCharacterEntityByOwnerId(playerId);
    }

    // getters
    
    // getCharactersFullStruct() {
    //     const characters: CharacterEntityFullStruct[] = [];
    //     for (const entity of this.engine.getCharactersStruct({ changed: false, full: true })) {
    //         characters.push(entity);
    //     }
    //     return characters;
    // }
    
}