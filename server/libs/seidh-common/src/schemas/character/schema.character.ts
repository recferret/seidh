import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { HydratedDocument } from 'mongoose';

export type CharacterDocument = HydratedDocument<Character>;

export enum CharacterType {
  RagnarLoh = 'RagnarLoh',
  ZombieBoy = 'ZombieBoy',
  ZombieGirl = 'ZombieGirl',
}

export type CharacterMovementStruct = {
  runSpeed: number;
  speedFactor: number;
  inputDelay: number;
};

export type CharacterActionStruct = {
  damage: number;
  inputDelay: number;
  meleeStruct: {
    aoe: boolean;
    shape: {
        width: number;
        height: number;
        rectOffsetX: number; 
        rectOffsetY: number;
    },
}
};

@Schema()
export class Character {
  @Prop({ required: true, type: String, enum: CharacterType })
  type: CharacterType;

  @Prop({ required: true, default: true })
  active: boolean;

  @Prop({ required: true, default: 1 })
  levelCurrent: number;

  @Prop({ required: true, default: 10 })
  levelMax: number;

  @Prop({ required: true, default: 0 })
  expCurrent: number;

  @Prop({ required: true, default: 0 })
  expTillNewLevel: number;

  @Prop({ required: true, default: 100 })
  health: number;

  @Prop({ required: true, type: { runSpeed: Number, speedFactor: Number, movementDelay: Number } })
  movement: CharacterMovementStruct;

  @Prop({ required: true, type: { damage: Number } })
  actionMain: CharacterActionStruct;
}

export const CharacterSchema = SchemaFactory.createForClass(Character);
