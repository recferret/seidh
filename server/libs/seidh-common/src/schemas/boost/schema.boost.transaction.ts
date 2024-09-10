import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { HydratedDocument, SchemaTypes, Types } from 'mongoose';

export type BoostTransactionDocument = HydratedDocument<BoostTransaction>;

@Schema()
export class BoostTransaction {
  @Prop({ type: SchemaTypes.Date, default: Date.now })
  createdAt: Date;

  @Prop({ type: SchemaTypes.ObjectId, ref: 'Boost' })
  boost: Types.ObjectId;

  @Prop()
  boostName: string;

  @Prop({ type: SchemaTypes.ObjectId, ref: 'User' })
  user: Types.ObjectId;
}

export const BoostTransactionSchema =
  SchemaFactory.createForClass(BoostTransaction);
