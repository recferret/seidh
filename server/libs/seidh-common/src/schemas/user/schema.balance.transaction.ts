import { HydratedDocument, SchemaTypes, Types } from 'mongoose';

import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';

import { BalanceOperationType, BalanceUpdateReason } from '@lib/seidh-common/types/types.user';

export type UserBalanceTransactionDocument = HydratedDocument<UserBalanceTransaction>;

@Schema()
export class UserBalanceTransaction {
  @Prop({ type: SchemaTypes.Date, default: Date.now })
  createdAt: Date;

  @Prop({ default: 0, required: true })
  teeth: number;

  @Prop({ default: 0, required: true })
  coins: number;

  @Prop({ default: 0, required: true })
  currentWealthLevel: number;

  @Prop({
    type: String,
    required: true,
    enum: BalanceUpdateReason,
  })
  balanceUpdateReason: BalanceUpdateReason;

  @Prop({
    type: String,
    required: true,
    enum: BalanceOperationType,
  })
  balanceOperationType: BalanceOperationType;

  @Prop({ type: SchemaTypes.ObjectId, ref: 'User', required: true })
  user: Types.ObjectId;
}

export const UserBalanceTransactionSchema = SchemaFactory.createForClass(UserBalanceTransaction);
