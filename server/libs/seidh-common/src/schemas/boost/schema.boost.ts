import { HydratedDocument } from 'mongoose';

import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';

import { BoostType } from '@lib/seidh-common/types/types.boost';
import { CurrencyType } from '@lib/seidh-common/types/types.user';

export type BoostDocument = HydratedDocument<Boost>;

@Schema()
export class Boost {
  @Prop({ required: true })
  order: number;

  @Prop({ required: true, type: String, enum: BoostType })
  boostType: BoostType;

  // Level one
  @Prop()
  levelZeroName?: string;

  // Level one
  @Prop({ required: true })
  levelOneId: string;

  @Prop({ required: true })
  levelOneName: string;

  @Prop({ required: true })
  levelOneDescription1: string;

  @Prop()
  levelOneDescription2?: string;

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
  levelTwoDescription1?: string;

  @Prop()
  levelTwoDescription2?: string;

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
  levelThreeDescription1?: string;

  @Prop()
  levelThreeDescription2?: string;

  @Prop()
  levelThreePrice?: number;

  @Prop({ type: String, enum: CurrencyType })
  levelThreeCurrencyType?: CurrencyType;
}

export const BoostSchema = SchemaFactory.createForClass(Boost);
