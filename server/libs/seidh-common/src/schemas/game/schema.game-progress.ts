import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { HydratedDocument, SchemaTypes } from 'mongoose';

export type GameProgressDocument = HydratedDocument<GameProgress>;

@Schema()
export class GameProgress {
  @Prop({ type: SchemaTypes.Date, default: Date.now })
  createdAt: Date;

  @Prop({ required: true })
  userId: string;

  @Prop({ default: 0 })
  mobsSpawned: number;

  @Prop({ default: 0 })
  mobsKilled: number;

  @Prop({ default: 0 })
  tokensGained: number;
}

export const GameProgressSchema = SchemaFactory.createForClass(GameProgress);
