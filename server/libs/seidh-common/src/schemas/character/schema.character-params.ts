import { HydratedDocument } from 'mongoose';

import { Schema, SchemaFactory } from '@nestjs/mongoose';

import { Character } from './schema.character';

export type CharacterParamsDocument = HydratedDocument<CharacterParams>;

@Schema()
export class CharacterParams extends Character {}

export const CharacterParamsSchema = SchemaFactory.createForClass(CharacterParams);
