import { HydratedDocument } from 'mongoose';

import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';

export type SkillPassiveDocument = HydratedDocument<SkillPassive>;

@Schema()
export class SkillPassive {
  @Prop({ required: true })
  name: string;

  @Prop({ required: true })
  levelOneDescription: string;

  @Prop({ required: true })
  levelTwoDescription: string;

  @Prop({ required: true })
  levelThreeDescription: string;
}

export const SkillPassiveSchema = SchemaFactory.createForClass(SkillPassive);
