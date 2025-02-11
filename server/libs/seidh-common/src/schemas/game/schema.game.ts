import { HydratedDocument, SchemaTypes, Types } from 'mongoose';
import { v4 as uuidv4 } from 'uuid';

import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';

import { GameFinishReason, GameGainings, GameState, GameType } from '@lib/seidh-common/types/types.game';

export type GameDocument = HydratedDocument<Game>;

@Schema()
export class Game {
  @Prop({ type: String, required: true, enum: GameType })
  type: GameType;

  @Prop({
    type: String,
    required: true,
    enum: GameState,
    default: GameState.Playing,
  })
  state: GameState;

  @Prop({
    type: String,
    required: false,
    enum: GameFinishReason,
  })
  finishReason: GameFinishReason;

  @Prop({ type: SchemaTypes.Date, default: Date.now })
  createdAt: Date;

  @Prop({ type: SchemaTypes.Date })
  deletedAt: Date;

  @Prop({ default: uuidv4() })
  gameId: string;

  @Prop({ default: 0 })
  mobsSpawned: number;

  @Prop({ default: 0 })
  mobsKilled: number;

  @Prop({ required: false, type: Array<string> })
  userIds: string[];

  @Prop({ required: false, type: Map, of: Object })
  userGainings: Map<string, GameGainings>;

  @Prop({ required: false })
  gameplayInstance: string;

  @Prop([{ type: SchemaTypes.ObjectId, ref: 'GameProgress' }])
  gameProgress: Types.ObjectId[];
}

export const GameSchema = SchemaFactory.createForClass(Game);
