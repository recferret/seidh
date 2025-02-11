import { HydratedDocument, SchemaTypes, Types } from 'mongoose';

import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { Platform } from '@lib/seidh-common/types/types.user';

export type UserDocument = HydratedDocument<User>;

@Schema({
  timestamps: {
    createdAt: 'created_at',
    updatedAt: 'updated_at',
  },
})
export class User {
  @Prop()
  authToken: string;

  @Prop()
  privateRsaKey: string;

  // -----------------------
  // Telegram and VK
  // -----------------------

  @Prop({
    type: String,
    required: true,
    enum: Platform,
  })
  platform: Platform;

  @Prop()
  tgId: number;

  @Prop()
  tgPremium: boolean;

  @Prop()
  vkId: number;

  @Prop()
  userName: string;

  // -----------------------
  // Boosts
  // -----------------------

  @Prop({ default: [] })
  boostsOwned: string[];

  // -----------------------
  // Stats
  // -----------------------

  @Prop({ type: Number, default: 0 })
  coins: number;

  @Prop({ type: Number, default: 0 })
  teeth: number;

  @Prop({ type: Number, default: 0 })
  monsterKills: number;

  @Prop({ type: Number, default: 0 })
  playerKills: number;

  // -----------------------
  // Referral
  // -----------------------

  @Prop([{ type: SchemaTypes.ObjectId, ref: 'User' }])
  friendsInvited: Types.ObjectId[];

  @Prop({ type: SchemaTypes.ObjectId, ref: 'User' })
  invitedBy: Types.ObjectId;

  @Prop({ type: Number, default: 0 })
  totalReferralRewards: Number;

  // -----------------------
  // Entities
  // -----------------------

  @Prop({ type: SchemaTypes.ObjectId, ref: 'Character' })
  activeCharacter: Types.ObjectId;

  @Prop([{ type: SchemaTypes.ObjectId, ref: 'Character' }])
  characters: Types.ObjectId[];
}

export const UserSchema = SchemaFactory.createForClass(User);
