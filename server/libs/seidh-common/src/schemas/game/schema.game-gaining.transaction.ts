import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { HydratedDocument, SchemaTypes, Types } from 'mongoose';

export type GameGainingTransactionDocument =
  HydratedDocument<GameGainingTransaction>;

@Schema()
export class GameGainingTransaction {
  @Prop({ type: SchemaTypes.Date, default: Date.now })
  createdAt: Date;

  @Prop({ required: true })
  gameId: string;

  @Prop({ default: 0, required: true })
  exp: number;

  @Prop({ default: 0, required: true })
  kills: number;

  @Prop({ default: 0, required: true })
  tokens: number;

  @Prop({ type: SchemaTypes.ObjectId, ref: 'User', required: true })
  user: Types.ObjectId;
}

export const GameGainingTransactionSchema = SchemaFactory.createForClass(
  GameGainingTransaction,
);
