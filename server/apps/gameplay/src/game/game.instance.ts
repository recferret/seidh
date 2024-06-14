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
    GameState,
    EngineMode,
    EngineCoinEntity,
    CoinEntityStruct, 
} from "@app/seidh-common/seidh-common.game-types";
import { EventEmitter2 } from "@nestjs/event-emitter";
import { EventGameCharacterActions } from "../events/event.game.character-actions";
import { EventGameCreateCharacter } from "../events/event.game.create-character";
import { EventGameCreateProjectile } from "../events/event.game.create-projectile";
import { EventGameDeleteCharacter } from "../events/event.game.delete-character";
import { EventGameDeleteProjectile } from "../events/event.game.delete-projectile";
import { EventGameLoopState } from "../events/event.game.loop-state";
import { EventGameGameState } from "../events/event.game.game-state";
import { EventGameDeleteCoin } from "../events/event.game.delete-coin";
import { EventGameCreateCoin } from "../events/event.game.create-coin";

export class GameInstance {

    private readonly engine: Engine.SeidhGameEngine;

    constructor(private eventEmitter: EventEmitter2, public gameId: string, public gameType: GameType) {
        this.engine = new Engine.engine.seidh.SeidhGameEngine(EngineMode.SERVER);

        // -----------------------------------
        // Engine callbacks
        // -----------------------------------

        this.engine.createCharacterCallback = (characterEntity: EngineCharacterEntity) => {
            this.eventEmitter.emit(
                EventGameCreateCharacter.EventName, 
                new EventGameCreateCharacter(gameId, characterEntity.getEntityFullStruct())
            );

            // Stop mobs from spwawning if there is no more players
            if (this.engine.getPlayersCount() > 0)  {
                this.engine.allowMobsSpawn(true);
            }
        };

        this.engine.deleteCharacterCallback = (characterEntity: EngineCharacterEntity) => {
            this.eventEmitter.emit(
                EventGameDeleteCharacter.EventName,
                new EventGameDeleteCharacter(gameId, characterEntity.getEntityMinStruct().id)
            );

            // Stop mobs from spwawning if there is no more players
            if (this.engine.getPlayersCount() == 0)  {
                this.engine.allowMobsSpawn(false);
                this.engine.cleanAllMobs();
            }
        };

        this.engine.createProjectileCallback = (projectileEntity: EngineProjectileEntity) => {
            this.eventEmitter.emit(EventGameCreateProjectile.EventName, new EventGameCreateProjectile(gameId));
        };

        this.engine.deleteProjectileCallback = (projectileEntity: EngineProjectileEntity) => {
            this.eventEmitter.emit(EventGameDeleteProjectile.EventName, new EventGameDeleteProjectile(gameId));
        };

        this.engine.createCoinCallback = (coinEntity: EngineCoinEntity) => {
            const coinEntityStruct: CoinEntityStruct = {
                baseEntityStruct: coinEntity.getEntityBaseStruct(),
                amount: coinEntity.amount,
            };
            this.eventEmitter.emit(
                EventGameCreateCoin.EventName,
                new EventGameCreateCoin(gameId, coinEntityStruct)
            );
        };

        this.engine.deleteCoinCallback = (coinEntity: EngineCoinEntity) => {
            this.eventEmitter.emit(
                EventGameDeleteCoin.EventName,
                new EventGameDeleteCoin(gameId, coinEntity.getEntityBaseStruct().id)
            );
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
                    EventGameLoopState.EventName, 
                    new EventGameLoopState(
                        gameId,
                        charactersMinStruct,
                        charactersFullStruct
                    )
                );
            }
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

        this.engine.gameStateCallback = (gameState: GameState) => {
            this.eventEmitter.emit(
                EventGameGameState.EventName, 
                new EventGameGameState(
                    gameId,
                    gameState
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
            x: 2000,
            y: 2000,
            entityType: EntityType.RAGNAR_LOH,
        };
        this.engine.createCharacterEntityFromMinimalStruct(struct);
    }

    deletePlayer(playerId: string) {
        this.engine.deleteCharacterEntityByOwnerId(playerId);
    }
    
}