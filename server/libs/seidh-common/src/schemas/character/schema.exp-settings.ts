import { HydratedDocument } from 'mongoose';

import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';

export type ExpSettingsDocument = HydratedDocument<ExpSettings>;

@Schema()
export class ExpSettings {
  @Prop({ default: 1 })
  expPerZombie: number;

  @Prop({ default: 1 })
  expPerPlayer: number;
}

export const ExpSettingsSchema = SchemaFactory.createForClass(ExpSettings);
