import { CharacterParams } from '@lib/seidh-common/schemas/character/schema.character-params';
import { ExpSettings, ExpSettingsDocument } from '@lib/seidh-common/schemas/character/schema.exp-settings';
import {
  LevelingSettings,
  LevelingSettingsDocument,
} from '@lib/seidh-common/schemas/character/schema.leveling-settings';
import { Model } from 'mongoose';

import { Injectable, OnModuleInit } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';

import {
  CharacterActionType,
  CharacterEntityParams,
  CharacterLevelEffectType,
  CharacterType,
} from '@lib/seidh-common/types/types.character';

@Injectable()
export class CharactersDataService implements OnModuleInit {
  private characterParamsByType = new Map<CharacterType, CharacterEntityParams>();
  private levelingSettingsByLevel = new Map<Number, LevelingSettingsDocument>();
  private expSettings: ExpSettingsDocument;

  constructor(
    @InjectModel(CharacterParams.name) private characterParamsModel: Model<CharacterParams>,
    @InjectModel(ExpSettings.name) private expSettingsModel: Model<ExpSettings>,
    @InjectModel(LevelingSettings.name) private levelingSettingsModel: Model<LevelingSettings>,
  ) {}

  async onModuleInit() {
    const expSettings = await this.expSettingsModel.findOne();
    if (!expSettings) {
      this.expSettings = await this.expSettingsModel.create({
        expPerPlayer: 100,
        expPerZombie: 1,
      });
    } else {
      this.expSettings = expSettings;
    }

    const levelingSettings = await this.levelingSettingsModel.find();
    if (!levelingSettings || levelingSettings.length == 0) {
      async function createAndSetLevelingSetting(
        context: any,
        level: number,
        expTillNextLevel: number,
        type: CharacterLevelEffectType,
        coinsPrice: number,
        teethPrice: number,
      ) {
        context.levelingSettingsByLevel.set(
          level,
          await context.levelingSettingsModel.create({
            type,
            level,
            expTillNextLevel,
            coinsPrice,
            teethPrice,
          }),
        );
      }

      await createAndSetLevelingSetting(this, 2, 100, CharacterLevelEffectType.DefensiveSkill, 50, 0);
      await createAndSetLevelingSetting(this, 3, 100, CharacterLevelEffectType.PassiveTrait, 100, 0);
      await createAndSetLevelingSetting(this, 4, 100, CharacterLevelEffectType.PassiveSkill, 200, 0);
      await createAndSetLevelingSetting(this, 5, 100, CharacterLevelEffectType.ConsumableSlot, 200, 100);
      await createAndSetLevelingSetting(this, 6, 100, CharacterLevelEffectType.ActiveSkill, 300, 200);
      await createAndSetLevelingSetting(this, 7, 100, CharacterLevelEffectType.PassiveTrait, 400, 300);
      await createAndSetLevelingSetting(this, 8, 100, CharacterLevelEffectType.ConsumableSlot, 500, 400);
      await createAndSetLevelingSetting(this, 9, 100, CharacterLevelEffectType.PassiveSkill, 600, 500);
      await createAndSetLevelingSetting(this, 10, 100, CharacterLevelEffectType.ActiveSkill, 600, 500);
    } else {
      levelingSettings.forEach((f) => {
        this.levelingSettingsByLevel.set(f.level, f);
      });
    }

    const characterParams = await this.characterParamsModel.find();
    if (!characterParams || characterParams.length == 0) {
      await this.characterParamsModel.insertMany([
        {
          ...this.getBasicCharacterParamsByType(CharacterType.RagnarLoh),
        },
        {
          ...this.getBasicCharacterParamsByType(CharacterType.ZombieBoy),
        },
        {
          ...this.getBasicCharacterParamsByType(CharacterType.ZombieGirl),
        },
      ]);
    }
    (await this.characterParamsModel.find()).forEach((f) => {
      this.characterParamsByType.set(f.type, {
        type: f.type,
        levelCurrent: f.levelCurrent,
        levelMax: f.levelMax,
        expCurrent: f.expCurrent,
        expTillNextLevel: this.levelingSettingsByLevel.get(2).expTillNextLevel,
        health: f.health,
        entityShape: {
          width: f.entityShape.width,
          height: f.entityShape.height,
          rectOffsetX: f.entityShape.rectOffsetX,
          rectOffsetY: f.entityShape.rectOffsetY,
          radius: f.entityShape.radius,
        },
        movement: {
          runSpeed: f.movement.runSpeed,
          speedFactor: f.movement.speedFactor,
          inputDelay: f.movement.inputDelay,
        },
        actionMain: {
          damage: f.actionMain.damage,
          inputDelay: f.actionMain.inputDelay,
          animDurationMs: f.actionMain.animDurationMs,
          actionType: f.actionMain.actionType,
          meleeStruct: {
            aoe: f.actionMain.meleeStruct.aoe,
            shape: {
              width: f.actionMain.meleeStruct.shape.width,
              height: f.actionMain.meleeStruct.shape.height,
              rectOffsetX: f.actionMain.meleeStruct.shape.rectOffsetX,
              rectOffsetY: f.actionMain.meleeStruct.shape.rectOffsetY,
            },
          },
        },
      });
    });
  }

  getCharacterParamsByType(characterType: CharacterType) {
    return this.characterParamsByType.get(characterType);
  }

  getExpPerZombieKill() {
    return this.expSettings.expPerZombie;
  }

  getExpPerPlayerKill() {
    return this.expSettings.expPerPlayer;
  }

  getNextLevelData(level: number) {
    const setting = this.levelingSettingsByLevel.get(level);
    const effectType = setting.type;
    const coinsPrice = setting.coinsPrice;
    const teethPrice = setting.teethPrice;
    const expTillNextLevel = setting.expTillNextLevel;

    return {
      effectType,
      coinsPrice,
      teethPrice,
      expTillNextLevel,
    };
  }

  private getBasicCharacterParamsByType(characterType: CharacterType): CharacterEntityParams {
    switch (characterType) {
      case CharacterType.RagnarLoh:
        return {
          type: CharacterType.RagnarLoh,
          levelCurrent: 1,
          levelMax: 10,
          expCurrent: 0,
          expTillNextLevel: 0,
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
            inputDelay: 0.1,
          },
          actionMain: {
            damage: 5,
            inputDelay: 1,
            animDurationMs: 200,
            actionType: CharacterActionType.Attack,
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
          expTillNextLevel: 0,
          health: 10,
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
            inputDelay: 0.1,
          },
          actionMain: {
            damage: 5,
            inputDelay: 1,
            animDurationMs: 200,
            actionType: CharacterActionType.Attack,
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
          expTillNextLevel: 0,
          health: 10,
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
            inputDelay: 0.1,
          },
          actionMain: {
            damage: 5,
            inputDelay: 1,
            animDurationMs: 200,
            actionType: CharacterActionType.Attack,
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
    }
  }
}
