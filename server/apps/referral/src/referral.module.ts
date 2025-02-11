import { ReferralConfig, ReferralConfigSchema } from '@lib/seidh-common/schemas/user/schema.referral';

import { Module } from '@nestjs/common';
import { MongooseModule } from '@nestjs/mongoose';

import { PrometheusModule } from '@willsoto/nestjs-prometheus';

import { MongoModule } from '@lib/seidh-common/mongo/mongo.module';

import { ReferralController } from './referral.controller';

import { ReferralService } from './referral.service';

@Module({
  imports: [
    MongoModule,
    MongooseModule.forFeature([{ name: ReferralConfig.name, schema: ReferralConfigSchema }]),
    PrometheusModule.register(),
  ],
  controllers: [ReferralController],
  providers: [ReferralService],
})
export class ReferralModule {}
