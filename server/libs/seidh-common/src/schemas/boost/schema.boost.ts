import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { HydratedDocument } from 'mongoose';

export type BoostDocument = HydratedDocument<Boost>;

export enum CurrencyType {
  Coins = 'Coins',
  Teeth = 'Teeth',
}

export enum BoostType {
  Rune = 'Rune',
  Scroll = 'Scroll',
  Artifact = 'Artifact',
}

@Schema()
export class Boost {
  @Prop({ required: true })
  order: number;

  @Prop({ required: true, type: String, enum: BoostType })
  boostType: BoostType;

  // Level one
  @Prop({ required: false })
  levelZeroName: string;

  // Level one
  @Prop({ required: true })
  levelOneId: string;

  @Prop({ required: true })
  levelOneName: string;

  @Prop({ required: true })
  levelOneDescription: string;

  @Prop({ required: true })
  levelOnePrice: number;

  @Prop({ required: true, type: String, enum: CurrencyType })
  levelOneCurrencyType: CurrencyType;

  // Level two

  @Prop()
  levelTwoId: string;

  @Prop()
  levelTwoName?: string;

  @Prop()
  levelTwoDescription?: string;

  @Prop()
  levelTwoPrice?: number;

  @Prop({ type: String, enum: CurrencyType })
  levelTwoCurrencyType?: CurrencyType;

  // Level three

  @Prop()
  levelThreeId: string;

  @Prop()
  levelThreeName?: string;

  @Prop()
  levelThreeDescription?: string;

  @Prop()
  levelThreePrice?: number;

  @Prop({ type: String, enum: CurrencyType })
  levelThreeCurrencyType?: CurrencyType;
}

export const BoostSchema = SchemaFactory.createForClass(Boost);
