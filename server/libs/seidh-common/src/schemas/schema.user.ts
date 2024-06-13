import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { HydratedDocument, SchemaTypes, Types } from 'mongoose';
import { v4 as uuidv4 } from 'uuid';

export type UserDocument = HydratedDocument<User>;

@Schema()
export class User {
  @Prop({ default: uuidv4() })
  id: string;

  @Prop()
  telegramId: string;

  @Prop()
  telegramName: string;

  @Prop()
  telegramPremium: boolean;

  @Prop({ default: 0 })
  virtualTokenBalance: number;

  @Prop({ default: 0 })
  kills: number;

  @Prop({ default: true })
  online: boolean;

  @Prop([{ type: SchemaTypes.ObjectId, ref: 'Character' }])
  characters: Types.ObjectId[];

  @Prop([{ type: SchemaTypes.ObjectId, ref: 'User' }])
  friendsInvited: Types.ObjectId[];

  @Prop({ type: SchemaTypes.ObjectId, ref: 'User' })
  invitedBy: Types.ObjectId;
}

export const UserSchema = SchemaFactory.createForClass(User);