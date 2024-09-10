import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { HydratedDocument } from 'mongoose';

export type CharacterDocument = HydratedDocument<Character>;

export enum CharacterType {
  RagnarLoh = 'RagnarLoh',
}

export type CharacterMovementStruct = {
  runSpeed: number;
  walkSpeed: number;
};

export type CharacterActionStruct = {
  damage: number;
};

@Schema()
export class Character {
  @Prop({ type: String, enum: CharacterType })
  type: CharacterType;

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
