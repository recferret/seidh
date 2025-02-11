import { AddExpTransaction } from '@lib/seidh-common/schemas/character/schema.add-exp-transaction';
import { Character } from '@lib/seidh-common/schemas/character/schema.character';
import { CharacterParams } from '@lib/seidh-common/schemas/character/schema.character-params';
import { LevelUpTransaction } from '@lib/seidh-common/schemas/character/schema.level-up-transaction';
import { User } from '@lib/seidh-common/schemas/user/schema.user';
import { Model } from 'mongoose';

import { Injectable, Logger } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';

import { CharactersDataService } from './characters.data.service';

import { SeidhCommonBoostsUtils } from '@lib/seidh-common/seidh-common.boosts-utils';

import {
  CharactersServiceAddExpRequest,
  CharactersServiceAddExpResponse,
} from '@lib/seidh-common/dto/characters/characters.add-exp.msg';
import {
  CharactersServiceCreateRequest,
  CharactersServiceCreateResponse,
} from '@lib/seidh-common/dto/characters/characters.create.msg';
import {
  CharactersServiceGetByIdsRequest,
  CharactersServiceGetByIdsResponse,
} from '@lib/seidh-common/dto/characters/characters.get-by-ids.msg';
import { CharactersServiceGetDefaultParamsResponse } from '@lib/seidh-common/dto/characters/characters.get-default-params.msg';
import {
  CharactersServiceLevelUpRequest,
  CharactersServiceLevelUpResponse,
} from '@lib/seidh-common/dto/characters/characters.level-up.msg';

import { CharacterType } from '@lib/seidh-common/types/types.character';

@Injectable()
export class CharactersService {
  constructor(
    private readonly charactersDataService: CharactersDataService,
    @InjectModel(Character.name) private characterModel: Model<Character>,
    @InjectModel(AddExpTransaction.name) private addExpTransactionModel: Model<AddExpTransaction>,
    @InjectModel(LevelUpTransaction.name) private levelUpTransactionModel: Model<LevelUpTransaction>,
    @InjectModel(User.name) private userModel: Model<User>,
  ) {}

  async create(request: CharactersServiceCreateRequest) {
    const response: CharactersServiceCreateResponse = {
      success: false,
    };

    try {
      const charParams = this.charactersDataService.getCharacterParamsByType(request.characterType);
      const newCharacter = await this.characterModel.create({
        type: request.characterType,
        levelCurrent: charParams.levelCurrent,
        levelMax: charParams.levelMax,
        expCurrent: charParams.expCurrent,
        expTillNextLevel: charParams.expTillNextLevel,
        health: charParams.health,
        entityShape: charParams.entityShape,
        movement: charParams.movement,
        actionMain: charParams.actionMain,
      });

      response.characterId = newCharacter.id;
      response.success = true;
    } catch (error) {
      Logger.error(
        {
          msg: 'CharactersService create',
          request,
        },
        error,
      );
    }

    return response;
  }

  async getByIds(request: CharactersServiceGetByIdsRequest) {
    const response: CharactersServiceGetByIdsResponse = {
      success: false,
    };

    try {
      const chars = await this.characterModel.find().where('_id').in(request.ids).exec();
      response.characterParams = chars.map((char) => {
        const params: CharacterParams = {
          type: char.type,
          levelCurrent: char.levelCurrent,
          levelMax: char.levelMax,
          expCurrent: char.expCurrent,
          expTillNextLevel: char.expTillNextLevel,
          health: char.health,
          entityShape: char.entityShape,
          movement: char.movement,
          actionMain: char.actionMain,
        };
        return params;
      });
      response.success = true;
    } catch (error) {
      Logger.log({
        msg: 'CharactersService getByIds',
        request,
        error,
      });
    }

    return response;
  }

  async getDefaultParams() {
    const response: CharactersServiceGetDefaultParamsResponse = {
      success: false,
    };

    try {
      response.ragnarLoh = this.charactersDataService.getCharacterParamsByType(CharacterType.RagnarLoh);
      response.zombieBoy = this.charactersDataService.getCharacterParamsByType(CharacterType.ZombieBoy);
      response.zombieGirl = this.charactersDataService.getCharacterParamsByType(CharacterType.ZombieGirl);
      response.success = true;
    } catch (error) {
      Logger.log({
        msg: 'CharactersService getDefaultParams',
        error,
      });
    }

    return response;
  }

  async addExp(request: CharactersServiceAddExpRequest) {
    const response: CharactersServiceAddExpResponse = {
      success: false,
    };

    try {
      const user = await this.userModel.findById(request.userId);
      const character = await this.characterModel.findById(user.activeCharacter);

      if (character.levelCurrent < character.levelMax) {
        const expLevel = SeidhCommonBoostsUtils.GetUserExpLevel(user.boostsOwned);
        const expMultiplier = SeidhCommonBoostsUtils.GetExpMultiplierByLevel(expLevel);
        const expToAdd = request.zombiesKilled * this.charactersDataService.getExpPerZombieKill() * expMultiplier;

        await this.addExpTransactionModel.create({
          user,
          character,
          expToAdd,
          currentExp: character.expCurrent,
        });

        character.expCurrent += expToAdd;

        if (character.expCurrent >= character.expTillNextLevel) {
          character.expCurrent = character.expTillNextLevel;
        }

        await character.save();
        response.success = true;
      }
    } catch (error) {
      Logger.error(
        {
          msg: 'CharactersService addExp',
          request,
        },
        error,
      );
    }

    return response;
  }

  async levelUp(request: CharactersServiceLevelUpRequest) {
    const response: CharactersServiceLevelUpResponse = {
      success: false,
    };

    try {
      const user = await this.userModel.findById(request.userId);
      const character = await this.characterModel.findById(user.activeCharacter);

      if (character.levelCurrent < character.levelMax && character.expCurrent >= character.expTillNextLevel) {
        const nextLevelData = this.charactersDataService.getNextLevelData(character.levelCurrent + 1);

        if (user.coins >= nextLevelData.coinsPrice && user.teeth >= nextLevelData.teethPrice) {
          character.expCurrent = 0;
          character.levelCurrent++;
          character.expTillNextLevel = this.charactersDataService.getNextLevelData(
            character.levelCurrent,
          ).expTillNextLevel;

          await character.save();
          await this.levelUpTransactionModel.create({
            user,
            character,
            level: character.levelCurrent,
            coinsSpent: request.coins,
            teethSpent: request.coins,
          });

          response.success = true;
        } else {
          Logger.error({
            msg: 'CharactersService levelUp error, not enough coins or teeth',
            request,
            character: {
              id: character.id,
              currentLevel: character.levelCurrent,
              expCurrent: character.expCurrent,
              expTillNextLevel: character.expTillNextLevel,
            },
          });
        }
      } else {
        Logger.error({
          msg: 'CharactersService levelUp error, not enough exp',
          request,
          character: {
            id: character.id,
            currentLevel: character.levelCurrent,
            expCurrent: character.expCurrent,
            expTillNextLevel: character.expTillNextLevel,
          },
        });
      }
    } catch (error) {
      Logger.log({
        msg: 'CharactersService levelUp',
        request,
        error,
      });
    }

    return response;
  }
}
