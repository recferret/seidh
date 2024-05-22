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
    CharacterEntity
} from "@app/seidh-common/seidh-common.game-types";
import { EventEmitter2 } from "@nestjs/event-emitter";
import { EventGameGameState } from "../events/event.game.state";
import { EventGameCharacterActions } from "../events/event.game.character-actions";
import { EventGameCreateCharacter } from "../events/event.game.create-character";
import { EventGameCreateProjectile } from "../events/event.game.create-projectile";
import { EventGameDeleteCharacter } from "../events/event.game.delete-character";
import { EventGameDeleteProjectile } from "../events/event.game.delete-projectile";

export class GameInstance {

    private readonly engine: Engine.SeidhGameEngine;

    constructor(private eventEmitter: EventEmitter2, public gameId: string, public gameType: GameType) {
        this.engine = new Engine.engine.seidh.SeidhGameEngine();

        // -----------------------------------
        // Engine callbacks
        // -----------------------------------

        this.engine.createCharacterCallback = (characterEntity: EngineCharacterEntity) => {
            this.eventEmitter.emit(
                EventGameCreateCharacter.EventName, 
                characterEntity
            );
        };

        this.engine.deleteCharacterCallback = (characterEntity: EngineCharacterEntity) => {
            this.eventEmitter.emit(
                EventGameDeleteCharacter.EventName,
                new EventGameDeleteCharacter(
                    gameId,
                    characterEntity.getMinEntity().id
                )
            );
        };

        this.engine.createProjectileCallback = (projectileEntity: EngineProjectileEntity) => {
            this.eventEmitter.emit(EventGameCreateProjectile.EventName, new EventGameCreateProjectile(gameId));
        };

        this.engine.deleteProjectileCallback = (projectileEntity: EngineProjectileEntity) => {
            this.eventEmitter.emit(EventGameDeleteProjectile.EventName, new EventGameDeleteProjectile(gameId));
        };

        this.engine.postLoopCallback = () => {
            const charactersMin: CharacterEntityMinStruct[] = [];
            for (const entity of this.engine.getCharacterEntitiesChangedArray()) {
                charactersMin.push(entity.getMinEntity());
            }

            const charactersFull: CharacterEntity[] = [];
            // for (const entity of entitiesMap.values())
            // TODO rmk to array ? or just rename this function?
            for (const entity of this.engine.getCharacterEntitiesArray()) {
                console.log(entity);
                charactersFull.push(entity);
            }

            this.eventEmitter.emit(
                EventGameGameState.EventName, 
                new EventGameGameState(
                    gameId,
                    charactersMin,
                    charactersFull
                )
            );
        };

        this.engine.characterActionCallbacks = (actions: CharacterActionCallbackParams[]) => {
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
            x: 200,
            y: 200,
            entityType: EntityType.KNIGHT,
        };
        this.engine.createCharacterEntityFromMinimalStruct(struct);
    }

    removePlayer(playerId: string) {
        this.engine.removeCharacterEntity(playerId);
    }

    // getters
    

    // WTF ?
    getCharacters() {
        const characters: CharacterEntity[] = [];
        console.log(this.engine);
        for (const entity of this.engine.getCharacterEntitiesArray()) {
            console.log(entity);
            characters.push(entity.getFullEntity());
        }
        return characters;
    }
}