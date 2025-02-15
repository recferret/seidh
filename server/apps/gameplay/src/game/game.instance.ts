import { EventEmitter2 } from '@nestjs/event-emitter';

import { GameplayType } from '@lib/seidh-common/dto/gameplay-lobby/gameplay-lobby.find-game.msg';
import {
  CharacterActionCallbackParams,
  CharacterEntityFullStruct,
  CharacterEntityMinStruct,
  CharacterMinStruct,
  ConsumableEntityStruct,
  DeleteConsumableCallback,
  EngineCharacterEntity,
  EngineConsumableEntity,
  EngineMode,
  EntityType,
  PlayerInputCommand,
  WinCondition,
} from '@lib/seidh-common/types/types.engine';

import * as Engine from '../js/SeidhGameEngine';
import { EventGameCharacterActions } from '../events/event.game.character-actions';
import { EventGameCreateCharacter } from '../events/event.game.create-character';
import { EventGameCreateConsumable } from '../events/event.game.create-consumable';
import { EventGameCreateProjectile } from '../events/event.game.create-projectile';
import { EventGameDeleteCharacter } from '../events/event.game.delete-character';
import { EventGameDeleteConsumable } from '../events/event.game.delete-consumable';
import { EventGameDeleteProjectile } from '../events/event.game.delete-projectile';
import { EventGameGameState } from '../events/event.game.game-state';
import { EventGameInit } from '../events/event.game.init';
import { EventGameLoopState } from '../events/event.game.loop-state';
import { EventGameUserGainings } from '../events/event.game.user-gainings';
import { GameGainings, GameState } from '@lib/seidh-common/types/types.game';

export class GameInstance {
  private readonly engine: Engine.SeidhGameEngine;

  constructor(
    private eventEmitter: EventEmitter2,
    public gameId: string,
    public gameplayType: GameplayType,
  ) {
    this.engine = new Engine.engine.seidh.SeidhGameEngine(
      EngineMode.SERVER,
      gameplayType == GameplayType.TestGame ? WinCondition.INFINITE : WinCondition.KILL_MOBS,
    );

    // TODO move to config
    this.engine.setZombieDamage(0);

    // -----------------------------------
    // Engine callbacks
    // -----------------------------------

    this.engine.createCharacterCallback = (characterEntity: EngineCharacterEntity) => {
      this.eventEmitter.emit(
        EventGameCreateCharacter.EventName,
        new EventGameCreateCharacter(gameId, characterEntity.getEntityFullStruct()),
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
          this.eventEmitter.emit(EventGameInit.EventName, new EventGameInit(gameId, charactersFullStruct));
        }
      }
    };

    this.engine.deleteCharacterCallback = (characterEntity: EngineCharacterEntity) => {
      if (characterEntity.isPlayer()) {
        const userId = characterEntity.getOwnerId();
        const gainings = this.engine.getPlayerGainings(userId);
        const playerGainings: GameGainings = {
          zombiesKilled: gainings.zombiesKilled,
          coinsGained: gainings.coinsGained,
        };
        this.eventEmitter.emit(EventGameUserGainings.EventName, new EventGameUserGainings(gameId, playerGainings));
        this.engine.clearPlayerGainings(userId);
      }

      this.eventEmitter.emit(
        EventGameDeleteCharacter.EventName,
        new EventGameDeleteCharacter(gameId, characterEntity.getEntityMinStruct().id),
      );
    };

    this.engine.createProjectileCallback = () => {
      this.eventEmitter.emit(EventGameCreateProjectile.EventName, new EventGameCreateProjectile(gameId));
    };

    this.engine.deleteProjectileCallback = () => {
      this.eventEmitter.emit(EventGameDeleteProjectile.EventName, new EventGameDeleteProjectile(gameId));
    };

    this.engine.createConsumableCallback = (consumableEntity: EngineConsumableEntity) => {
      const consumableEntityStruct: ConsumableEntityStruct = {
        baseEntityStruct: consumableEntity.getEntityBaseStruct(),
        amount: consumableEntity.amount,
      };
      this.eventEmitter.emit(
        EventGameCreateConsumable.EventName,
        new EventGameCreateConsumable(gameId, consumableEntityStruct),
      );
    };

    this.engine.deleteConsumableCallback = (callbackBody: DeleteConsumableCallback) => {
      this.eventEmitter.emit(
        EventGameDeleteConsumable.EventName,
        new EventGameDeleteConsumable(gameId, callbackBody.entityId, callbackBody.takenByCharacterId),
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
        this.eventEmitter.emit(EventGameLoopState.EventName, new EventGameLoopState(gameId, charactersMinStruct));
      }
    };

    this.engine.characterActionCallbacks = (actions: CharacterActionCallbackParams[]) => {
      this.eventEmitter.emit(EventGameCharacterActions.EventName, new EventGameCharacterActions(gameId, actions));
    };

    this.engine.gameStateCallback = (gameState: GameState) => {
      this.eventEmitter.emit(EventGameGameState.EventName, new EventGameGameState(gameId, gameState));
    };

    setInterval(() => {
      if (this.engine.getPlayersCount() == 0) {
        this.engine.allowMobsSpawn(false);
        this.engine.cleanAllMobs();
      }
    }, 2500);
  }

  // ---------------------
  // Client commands
  // ---------------------

  input(input: PlayerInputCommand) {
    this.engine.addInputCommandServer(input);
  }

  // ---------------------
  // Common
  // ---------------------

  addPlayer(playerId: string) {
    const struct: CharacterMinStruct = {
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

  // ---------------------
  // Getters
  // ---------------------

  getLastDt() {
    return this.engine.getLastDt();
  }

  getPlayersCount() {
    return this.engine.getPlayersCount();
  }

  getMobsCount() {
    return this.engine.getMobsCount();
  }
}
