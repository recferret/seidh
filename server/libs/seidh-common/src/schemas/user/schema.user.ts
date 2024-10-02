import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { HydratedDocument, SchemaTypes, Types } from 'mongoose';

export type UserDocument = HydratedDocument<User>;

@Schema()
export class User {
  @Prop()
  authToken: string;

  @Prop()
  privateRsaKey: string;

  @Prop({ default: false })
  online: boolean;

  // -----------------------
  // Telegram and login auth
  // -----------------------

  @Prop()
  telegramId: string;

  @Prop()
  telegramName: string;

  @Prop()
  telegramPremium: boolean;

  @Prop()
  login: string;

  // -----------------------
  // Boosts
  // -----------------------

  @Prop({ default: [] })
  boostsOwned: string[];

  // -----------------------
  // Stats
  // -----------------------

  @Prop({ default: 0 })
  coins: number;

  @Prop({ default: 0 })
  teeth: number;

  @Prop({ default: 0 })
  kills: number;

  // -----------------------
  // Referral
  // -----------------------

  @Prop([{ type: SchemaTypes.ObjectId, ref: 'User' }])
  friendsInvited: Types.ObjectId[];

  @Prop({ type: SchemaTypes.ObjectId, ref: 'User' })
  invitedBy: Types.ObjectId;

  @Prop({ default: 0 })
  totalReferralRewards: number;

  // -----------------------
  // Entities
  // -----------------------

  @Prop([{ type: SchemaTypes.ObjectId, ref: 'Character' }])
  characters: Types.ObjectId[];
}

export const UserSchema = SchemaFactory.createForClass(User);
