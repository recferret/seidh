import { HydratedDocument } from 'mongoose';

import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';

export type GameConfigDocument = HydratedDocument<GameConfig>;

@Schema()
export class GameConfig {
  // Mobs spawn

  @Prop({ required: true })
  mobsMaxAtTheSameTime: number;

  @Prop({ required: true })
  mobsMaxPerGame: number;

  @Prop({ required: true })
  mobSpawnDelayMs: number;
}

export const GameConfigSchema = SchemaFactory.createForClass(GameConfig);
