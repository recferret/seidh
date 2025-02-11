import { HydratedDocument } from 'mongoose';

import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';

import {
  CharacterActionStruct,
  CharacterActionType,
  CharacterEntityShape,
  CharacterMovementStruct,
  CharacterType,
} from '@lib/seidh-common/types/types.character';

export type CharacterDocument = HydratedDocument<Character>;

@Schema()
export class Character {
  @Prop({ required: true, type: String, enum: CharacterType })
  type: CharacterType;

  @Prop({ type: Number, required: true, default: 1 })
  levelCurrent: number;

  @Prop({ type: Number, required: true, default: 10 })
  levelMax: number;

  @Prop({ type: Number, required: true, default: 0 })
  expCurrent: number;

  @Prop({ type: Number, required: true, default: 0 })
  expTillNextLevel: number;

  @Prop({ type: Number, required: true, default: 100 })
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
      inputDelay: Number,
    },
  })
  movement: CharacterMovementStruct;

  @Prop({
    required: true,
    type: {
      damage: Number,
      inputDelay: Number,
      animDurationMs: Number,
      actionType: { type: String, enum: CharacterActionType },
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

  // @Prop({
  //   required: true,
  //   type: {
  //     damage: Number,
  //     inputDelay: Number,
  //     actionType: CharacterActionType,
  //     meleeStruct: {
  //       aoe: Boolean,
  //       shape: {
  //         width: Number,
  //         height: Number,
  //         rectOffsetX: Number,
  //         rectOffsetY: Number,
  //       },
  //     },
  //   },
  // })
  // action1: CharacterActionStruct;
}

export const CharacterSchema = SchemaFactory.createForClass(Character);
