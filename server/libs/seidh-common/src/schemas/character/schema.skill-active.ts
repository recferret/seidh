import { HydratedDocument } from 'mongoose';

import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';

export type SkillActiveDocument = HydratedDocument<SkillActive>;

@Schema()
export class SkillActive {
  @Prop({ required: true })
  name: string;

  @Prop({ required: true })
  levelOneDescription: string;

  @Prop({ required: true })
  levelTwoDescription: string;

  @Prop({ required: true })
  levelThreeDescription: string;
}

export const SkillActiveSchema = SchemaFactory.createForClass(SkillActive);
