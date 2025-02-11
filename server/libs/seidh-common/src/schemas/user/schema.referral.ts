import { HydratedDocument } from 'mongoose';

import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';

export type ReferralConfigDocument = HydratedDocument<ReferralConfig>;

@Schema()
export class ReferralConfig {
  @Prop({ default: 1000 })
  referrerPremiumRewardTokens: number;

  @Prop({ default: 200 })
  referrerNoPremiumRewardTokens: number;

  @Prop({ default: 200 })
  referralPremiumRewardTokens: number;

  @Prop({ default: 50 })
  referralNoPremiumRewardTokens: number;
}

export const ReferralConfigSchema = SchemaFactory.createForClass(ReferralConfig);
