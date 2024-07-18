import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { HydratedDocument, Types } from 'mongoose';
import { v4 as uuidv4 } from 'uuid';

export type BoostDocument = HydratedDocument<Boost>;

@Schema()
export class Boost {
  @Prop({ default: uuidv4() })
  id: string;

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