import { CharactersServiceCreateRequest, CharactersServiceCreateResponse } from '@app/seidh-common/dto/characters/characters.create.msg';
import { CharactersServiceGetByUserIdRequest } from '@app/seidh-common/dto/characters/characters.get-by-user-id.msg';
import { CharactersServicelevelUpRequest } from '@app/seidh-common/dto/characters/characters.level-up.msg';
import { CharacterType, CharacterParams } from '@app/seidh-common/dto/types/types.character';
import { Character } from '@app/seidh-common/schemas/character/schema.character';
import { Injectable, Logger } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model } from 'mongoose';

@Injectable()
export class CharactersService {

  constructor(
    @InjectModel(Character.name) private characterModel: Model<Character>,
  ) {}

  async create(request: CharactersServiceCreateRequest) {
    const response: CharactersServiceCreateResponse = {
      success: false,
    };

    try {
      const charParams = this.getBasicCharacterParamsByType(request.characterType);
      const newCharacter = await this.characterModel.create({
        type: request.characterType,
        levelCurrent: charParams.levelCurrent,
        levelMax: charParams.levelMax,
        expCurrent: charParams.expCurrent,
        expTillNewLevel: charParams.expTillNewLevel,
        health: charParams.health,
        entityShape: charParams.entityShape,
        movement: charParams.movement,
        actionMain: charParams.actionMain,
      });

      response.characterId = newCharacter.id;
    } catch (error) {
      Logger.log({
        msg: 'CharactersService create',
        request,
        error,
      });
    }

    return response;
  }

  async getByUserId(request: CharactersServiceGetByUserIdRequest) {
    
  }

  async getMobParams() {

  }

  async levelUp(request: CharactersServicelevelUpRequest) {
    
  }

  private getBasicCharacterParamsByType(characterType: CharacterType): CharacterParams {
    switch(characterType) {
      case CharacterType.RagnarLoh:
        return {
          type: CharacterType.RagnarLoh,
          levelCurrent: 1,
          levelMax: 10,
          expCurrent: 0,
          expTillNewLevel: 1000,
          health: 100,
          entityShape: {
            width: 180,
            height: 260,
            rectOffsetX: 0,
            rectOffsetY: 0,
            radius: 150,
          },
          movement: {
            runSpeed: 40,
            speedFactor: 10,
            inputDelay: 0.100,
          },
          actionMain: {
            damage: 5,
            inputDelay: 1,
            meleeStruct: {
              aoe: true,
              shape: {
                width: 350,
                height: 260,
                rectOffsetX: 175 - 90,
                rectOffsetY: 0,
              },
            },
          },
        };
      case CharacterType.ZombieBoy:
        return {
          type: CharacterType.ZombieBoy,
          levelCurrent: 1,
          levelMax: 10,
          expCurrent: 0,
          expTillNewLevel: 1000,
          health: 100,
          entityShape: {
            width: 200,
            height: 260,
            rectOffsetX: 0,
            rectOffsetY: 0,
            radius: 0,
          },
          movement: {
            runSpeed: 3,
            speedFactor: 10,
            inputDelay: 0.100,
          },
          actionMain: {
            damage: 5,
            inputDelay: 1,
            meleeStruct: {
              aoe: true,
              shape: {
                width: 300,
                height: 400,
                rectOffsetX: 0,
                rectOffsetY: 0,
              },
            },
          },
        };
      case CharacterType.ZombieGirl:
        return {
          type: CharacterType.ZombieGirl,
          levelCurrent: 1,
          levelMax: 10,
          expCurrent: 0,
          expTillNewLevel: 1000,
          health: 100,
          entityShape: {
            width: 200,
            height: 260,
            rectOffsetX: 0,
            rectOffsetY: 0,
            radius: 0,
          },
          movement: {
            runSpeed: 3,
            speedFactor: 10,
            inputDelay: 0.100,
          },
          actionMain: {
            damage: 5,
            inputDelay: 1,
            meleeStruct: {
              aoe: true,
              shape: {
                width: 300,
                height: 400,
                rectOffsetX: 0,
                rectOffsetY: 0,
              },
            },
          }
        };
    }
  }
}
