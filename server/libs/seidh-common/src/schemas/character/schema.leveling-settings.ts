import { HydratedDocument } from 'mongoose';

import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';

import { CharacterLevelEffectType } from '@lib/seidh-common/types/types.character';

export type LevelingSettingsDocument = HydratedDocument<LevelingSettings>;

@Schema()
export class LevelingSettings {
  @Prop({ required: true, type: String, enum: CharacterLevelEffectType })
  type: CharacterLevelEffectType;

  @Prop({ required: true })
  level: number;

  @Prop({ required: true })
  expTillNextLevel: number;

  @Prop({ required: true })
  coinsPrice: number;

  @Prop({ required: true })
  teethPrice: number;
}

export const LevelingSettingsSchema = SchemaFactory.createForClass(LevelingSettings);
