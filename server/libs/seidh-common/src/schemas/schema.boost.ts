import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { HydratedDocument } from 'mongoose';

export type BoostDocument = HydratedDocument<Boost>;

@Schema()
export class Boost {
  @Prop()
  order: number;

  @Prop()
  name: string;

  @Prop()
  description: string;

  @Prop({ default: 100 })
  price: number;
}

export const BoostSchema = SchemaFactory.createForClass(Boost);
