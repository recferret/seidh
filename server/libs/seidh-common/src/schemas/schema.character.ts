import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { HydratedDocument } from 'mongoose';
import { v4 as uuidv4 } from 'uuid';

export type CharacterDocument = HydratedDocument<Character>;

export enum CharacterType {
  Ragnar = 'Ragnar'
}

export type CharacterMovementStruct =  {
  runSpeed: number;
  walkSpeed: number;
}

export type CharacterActionStruct =  {
  damage: number;
}

@Schema()
export class Character {

  @Prop({ default: uuidv4() })
  id: string;

  @Prop({ type: String, enum: CharacterType })
  type: CharacterType

  @Prop({ default: true })
  active: boolean;

  @Prop({ default: 1 })
  levelCurrent: number;

  @Prop({ default: 10 })
  levelMax: number;

  @Prop({ default: 0 })
  expCurrent: number;

  @Prop({ default: 0 })
  expTillNewLevel: number;

  @Prop({ default: 100 })
  health: number;

  @Prop({ type: { runSpeed: Number, walkSpeed: Number } })
  movement: CharacterMovementStruct;

  @Prop({ type: { damage: Number } })
  actionMain: CharacterActionStruct;

}

export const CharacterSchema = SchemaFactory.createForClass(Character);