import { HydratedDocument, SchemaTypes, Types } from 'mongoose';

import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';

export type LevelUpTransactionDocument = HydratedDocument<LevelUpTransaction>;

@Schema()
export class LevelUpTransaction {
  @Prop({ type: SchemaTypes.Date, default: Date.now })
  createdAt: Date;

  @Prop({ required: true })
  level: number;

  @Prop({ required: true, default: 0 })
  coinsSpent: number;

  @Prop({ required: true, default: 0 })
  teethSpent: number;

  @Prop({ type: SchemaTypes.ObjectId, ref: 'User' })
  user: Types.ObjectId;

  @Prop({ type: SchemaTypes.ObjectId, ref: 'Character' })
  character: Types.ObjectId;
}

export const LevelUpTransactionSchema = SchemaFactory.createForClass(LevelUpTransaction);
