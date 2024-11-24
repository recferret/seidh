import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { HydratedDocument } from 'mongoose';

export type GameConfigDocument = HydratedDocument<GameConfig>;

@Schema()
export class GameConfig {
  // Mobs spawn

  @Prop({ required: true })
  mobsMaxAtTheSameTime: number;

  @Prop({ required: true })
  mobsMaxPerGame: number;

  @Prop({ required: true })
  mobSpawnDelayMs: number;

  // Exp boost

  @Prop({ required: true })
  expLevel1Multiplier: number;

  @Prop({ required: true })
  expLevel2Multiplier: number;

  @Prop({ required: true })
  expLevel3Multiplier: number;

  // Stats boost

  @Prop({ required: true })
  statsLevel1Multiplier: number;

  @Prop({ required: true })
  statsLevel2Multiplier: number;

  @Prop({ required: true })
  statsLevel3Multiplier: number;

  // Wealth boost

  @Prop({ required: true })
  wealthLevel1PickUpRangeMultiplier: number;

  @Prop({ required: true })
  wealthLevel2PickUpRangeMultiplier: number;

  @Prop({ required: true })
  wealthLevel3PickUpRangeMultiplier: number;

  @Prop({ required: true })
  wealthLevel1CoinsMultiplier: number;

  @Prop({ required: true })
  wealthLevel2CoinsMultiplier: number;

  @Prop({ required: true })
  wealthLevel3CoinsMultiplier: number;
}

export const GameConfigSchema = SchemaFactory.createForClass(GameConfig);
