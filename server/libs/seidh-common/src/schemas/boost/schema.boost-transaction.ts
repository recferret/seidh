import { HydratedDocument, SchemaTypes, Types } from 'mongoose';

import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';

export type BoostTransactionDocument = HydratedDocument<BoostTransaction>;

@Schema()
export class BoostTransaction {
  @Prop({ type: SchemaTypes.Date, default: Date.now })
  createdAt: Date;

  @Prop({ type: SchemaTypes.ObjectId, ref: 'Boost' })
  boost: Types.ObjectId;

  @Prop({ required: true })
  boostId: string;

  @Prop({ required: true, default: 0 })
  coinsSpent: number;

  @Prop({ required: true, default: 0 })
  teethSpent: number;

  @Prop({ type: SchemaTypes.ObjectId, ref: 'User' })
  user: Types.ObjectId;
}

export const BoostTransactionSchema = SchemaFactory.createForClass(BoostTransaction);
