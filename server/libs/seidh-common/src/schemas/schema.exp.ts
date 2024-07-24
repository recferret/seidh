import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { HydratedDocument } from 'mongoose';
import { v4 as uuidv4 } from 'uuid';

export type ExpSettingsDocument = HydratedDocument<ExpSettings>;

@Schema()
export class ExpSettings {
  @Prop({ default: uuidv4() })
  id: string;

  @Prop({ default: 1 })
  expPerZombie: number;

  @Prop({ default: 25 })
  expOnlineMultiplierPercent: number;

  @Prop({ default: 100 })
  expTillLevel2: number;

  @Prop({ default: 200 })
  expTillLevel3: number;

  @Prop({ default: 300 })
  expTillLevel4: number;

  @Prop({ default: 500 })
  expTillLevel5: number;

  @Prop({ default: 800 })
  expTillLevel6: number;

  @Prop({ default: 1300 })
  expTillLevel7: number;

  @Prop({ default: 2100 })
  expTillLevel8: number;

  @Prop({ default: 3400 })
  expTillLevel9: number;

  @Prop({ default: 5500 })
  expTillLevel10: number;
}

export const ExpSettingsSchema = SchemaFactory.createForClass(ExpSettings);
