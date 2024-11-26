import {
  CharacterType,
  CharacterEntityShape,
  CharacterActionStruct,
  CharacterMovementStruct,
} from '@app/seidh-common/dto/types/types.character';
import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { HydratedDocument } from 'mongoose';

export type CharacterDocument = HydratedDocument<Character>;

@Schema()
export class Character {
  @Prop({ required: true, type: String, enum: CharacterType })
  type: CharacterType;

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

  @Prop({
    required: true,
    type: {
      width: Number,
      height: Number,
      rectOffsetX: Number,
      rectOffsetY: Number,
      radius: Number,
    },
  })
  entityShape: CharacterEntityShape;

  @Prop({
    required: true,
    type: {
      runSpeed: Number,
      speedFactor: Number,
      movementDelay: Number,
    },
  })
  movement: CharacterMovementStruct;

  @Prop({
    required: true,
    type: {
      damage: Number,
      inputDelay: Number,
      meleeStruct: {
        aoe: Boolean,
        shape: {
          width: Number,
          height: Number,
          rectOffsetX: Number,
          rectOffsetY: Number,
        },
      },
    },
  })
  actionMain: CharacterActionStruct;
}

export const CharacterSchema = SchemaFactory.createForClass(Character);
