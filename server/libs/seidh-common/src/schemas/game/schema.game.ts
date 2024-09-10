import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { HydratedDocument, SchemaTypes } from 'mongoose';

export type GameDocument = HydratedDocument<Game>;

@Schema()
export class Game {
  @Prop({ type: SchemaTypes.Date, default: Date.now })
  createdAt: Date;

  @Prop({ type: SchemaTypes.Date })
  deletedAt: Date;

  @Prop()
  gameId: string;

  @Prop()
  gameInstance: string;

  @Prop()
  mobsSpawned: number;

  @Prop()
  mobsKilled: number;
}

export const GameSchema = SchemaFactory.createForClass(Game);
