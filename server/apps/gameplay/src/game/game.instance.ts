import { GameType } from '@app/seidh-common/dto/gameplay-lobby/gameplay-lobby.find.game.msg';
import * as Engine from '../js/SeidhGameEngine';
import {
  EngineCharacterEntity,
  CharacterEntityMinStruct,
  CharacterActionCallbackParams,
  PlayerInputCommand,
  CreateCharacterMinStruct,
  EntityType,
  CharacterEntityFullStruct,
  GameState,
  EngineMode,
  EngineConsumableEntity,
  DeleteConsumableEntityTask,
  ConsumableEntityStruct,
} from '@app/seidh-common/seidh-common.game-types';
import { EventEmitter2 } from '@nestjs/event-emitter';
import { EventGameCharacterActions } from '../events/event.game.character-actions';
import { EventGameCreateCharacter } from '../events/event.game.create-character';
import { EventGameCreateProjectile } from '../events/event.game.create-projectile';
import { EventGameDeleteCharacter } from '../events/event.game.delete-character';
import { EventGameDeleteProjectile } from '../events/event.game.delete-projectile';
import { EventGameLoopState } from '../events/event.game.loop-state';
import { EventGameGameState } from '../events/event.game.game-state';
import { EventGameDeleteConsumable } from '../events/event.game.delete-consumable';
import { EventGameCreateConsumable } from '../events/event.game.create-consumable';
import { Logger } from '@nestjs/common';
import { EventGameInit } from '../events/event.game.init';

export class GameInstance {
  private readonly engine: Engine.SeidhGameEngine;

  constructor(
    private eventEmitter: EventEmitter2,
    public gameId: string,
    public gameType: GameType,
  ) {
    // By default winCondition is WinCondition.INFINITE
    // this.engine = new Engine.engine.seidh.SeidhGameEngine(EngineMode.SERVER, WinCondition.KILL_MOBS);
    // this.engine = new Engine.engine.seidh.SeidhGameEngine(EngineMode.SERVER, WinCondition.INFINITE);
    this.engine = new Engine.engine.seidh.SeidhGameEngine(EngineMode.SERVER);

    // -----------------------------------
    // Engine callbacks
    // -----------------------------------

    this.engine.createCharacterCallback = (
      characterEntity: EngineCharacterEntity,
    ) => {
      this.eventEmitter.emit(
        EventGameCreateCharacter.EventName,
        new EventGameCreateCharacter(
          gameId,
          characterEntity.getEntityFullStruct(),
        ),
      );

      // Stop mobs from spwawning if there is no more players
      if (this.engine.getPlayersCount() > 0) {
        this.engine.allowMobsSpawn(true);
      }

      // Notify every new player about the game state
      if (characterEntity.isPlayer()) {
        const charactersFullStruct: CharacterEntityFullStruct[] = [];
        for (const entity of this.engine.getCharactersStruct({
          changed: false,
          full: true,
        })) {
          charactersFullStruct.push(entity);
        }

        if (charactersFullStruct.length > 0) {
          this.eventEmitter.emit(
            EventGameInit.EventName,
            new EventGameInit(gameId, charactersFullStruct),
          );
        }
      }
    };

    this.engine.deleteCharacterCallback = (
      characterEntity: EngineCharacterEntity,
    ) => {
      if (characterEntity.isPlayer()) {
        Logger.log(this.engine.getPlayerGainings(characterEntity.getId()));
      }

      this.eventEmitter.emit(
        EventGameDeleteCharacter.EventName,
        new EventGameDeleteCharacter(
          gameId,
          characterEntity.getEntityMinStruct().id,
        ),
      );
    };

    this.engine.createProjectileCallback = () => {
      this.eventEmitter.emit(
        EventGameCreateProjectile.EventName,
        new EventGameCreateProjectile(gameId),
      );
    };

    this.engine.deleteProjectileCallback = () => {
      this.eventEmitter.emit(
        EventGameDeleteProjectile.EventName,
        new EventGameDeleteProjectile(gameId),
      );
    };

    this.engine.createConsumableCallback = (
      consumableEntity: EngineConsumableEntity,
    ) => {
      const consumableEntityStruct: ConsumableEntityStruct = {
        baseEntityStruct: consumableEntity.getEntityBaseStruct(),
        amount: consumableEntity.amount,
      };
      this.eventEmitter.emit(
        EventGameCreateConsumable.EventName,
        new EventGameCreateConsumable(gameId, consumableEntityStruct),
      );
    };

    this.engine.deleteConsumableCallback = (
      callbackBody: DeleteConsumableEntityTask,
    ) => {
      this.eventEmitter.emit(
        EventGameDeleteConsumable.EventName,
        new EventGameDeleteConsumable(
          gameId,
          callbackBody.entityId,
          callbackBody.takenByCharacterId,
        ),
      );
    };

    this.engine.postLoopCallback = () => {
      const charactersMinStruct: CharacterEntityMinStruct[] = [];
      for (const entity of this.engine.getCharactersStruct({
        changed: true,
        full: false,
      })) {
        charactersMinStruct.push(entity);
      }

      if (charactersMinStruct.length > 0) {
        this.eventEmitter.emit(
          EventGameLoopState.EventName,
          new EventGameLoopState(gameId, charactersMinStruct),
        );
      }
    };

    this.engine.characterActionCallbacks = (
      actions: CharacterActionCallbackParams[],
    ) => {
      this.eventEmitter.emit(
        EventGameCharacterActions.EventName,
        new EventGameCharacterActions(gameId, actions),
      );
    };

    this.engine.gameStateCallback = (gameState: GameState) => {
      this.eventEmitter.emit(
        EventGameGameState.EventName,
        new EventGameGameState(gameId, gameState),
      );
    };

    setInterval(() => {
      if (this.engine.getPlayersCount() == 0) {
        this.engine.allowMobsSpawn(false);
        this.engine.cleanAllMobs();
      }
    }, 2500);
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
      x: this.engine.getPlayersSpawnPoints()[0].x,
      y: this.engine.getPlayersSpawnPoints()[0].y,
      entityType: EntityType.RAGNAR_LOH,
    };
    this.engine.createCharacterEntityFromMinimalStruct(struct);
  }

  deletePlayer(playerId: string) {
    this.engine.deleteCharacterEntityByOwnerId(playerId);
  }
}
