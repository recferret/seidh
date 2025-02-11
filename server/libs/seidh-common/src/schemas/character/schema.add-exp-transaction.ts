import { HydratedDocument, SchemaTypes, Types } from 'mongoose';

import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';

export type AddExpTransactionDocument = HydratedDocument<AddExpTransaction>;

@Schema()
export class AddExpTransaction {
  @Prop({ type: SchemaTypes.Date, default: Date.now })
  createdAt: Date;

  @Prop({ required: true })
  expToAdd: number;

  @Prop({ required: true })
  currentExp: number;

  @Prop({ type: SchemaTypes.ObjectId, ref: 'User' })
  user: Types.ObjectId;

  @Prop({ type: SchemaTypes.ObjectId, ref: 'Character' })
  character: Types.ObjectId;
}

export const AddExpTransactionSchema = SchemaFactory.createForClass(AddExpTransaction);
