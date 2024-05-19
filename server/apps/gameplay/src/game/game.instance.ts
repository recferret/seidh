import { GameType } from "@app/seidh-common/dto/gameplay-lobby/gameplay-lobby.find.game.msg.js";
import * as Engine from "../js/SeidhGameEngine.js";
import { 
    CharacterActionCallbackParams,
    CreateCharacterMinStruct,
    EngineCharacterEntity, 
    EngineProjectileEntity,
    EntityType,
    PlayerInputCommand
} from "./game.types.js";
import { EventEmitter2 } from "@nestjs/event-emitter";
import { EventGameGameState } from "../events/event.game.state.js";
import { EventGameCharacterActions } from "../events/event.game.character-actions.js";
import { EventGameCreateCharacter } from "../events/event.game.create-character.js";
import { EventGameCreateProjectile } from "../events/event.game.create-projectile.js";
import { EventGameDeleteCharacter } from "../events/event.game.delete-character.js";
import { EventGameDeleteProjectile } from "../events/event.game.delete-projectile.js";

export class GameInstance {

    private readonly engine: Engine.SeidhGameEngine;

    constructor(private eventEmitter: EventEmitter2, public gameId: string, public gameType: GameType) {
        this.engine = new Engine.engine.seidh.SeidhGameEngine;

        // -----------------------------------
        // Engine callbacks
        // -----------------------------------

        this.engine.createCharacterCallback = (characterEntity:EngineCharacterEntity) => {
            this.eventEmitter.emit(
                EventGameCreateCharacter.EventName, 
                characterEntity
            );
        };

        this.engine.deleteCharacterCallback = (characterEntity:EngineCharacterEntity) => {
            this.eventEmitter.emit(EventGameDeleteCharacter.EventName, new EventGameDeleteCharacter(gameId));
        };

        this.engine.createProjectileCallback = (projectileEntity:EngineProjectileEntity) => {
            this.eventEmitter.emit(EventGameCreateProjectile.EventName, new EventGameCreateProjectile(gameId));
        };

        this.engine.deleteProjectileCallback = (projectileEntity:EngineProjectileEntity) => {
            this.eventEmitter.emit(EventGameDeleteProjectile.EventName, new EventGameDeleteProjectile(gameId));
        };

        this.engine.postLoopCallback = () => {
            this.eventEmitter.emit(EventGameGameState.EventName, new EventGameGameState(gameId));
        };

        this.engine.characterActionCallbacks = (params:CharacterActionCallbackParams[]) => {
            this.eventEmitter.emit(EventGameCharacterActions.EventName, new EventGameCharacterActions(gameId));
        };
    }

    input(input: PlayerInputCommand) {
        this.engine.addInputCommandServer(input);
    }

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
}