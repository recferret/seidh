import { Module } from '@nestjs/common';
import { ReferralController } from './referral.controller';
import { ReferralService } from './referral.service';
import { PrometheusModule } from '@willsoto/nestjs-prometheus';
import { MongooseModule } from '@nestjs/mongoose';
import { InternalProtocol } from '@app/seidh-common';
import {
  ReferralConfig,
  ReferralConfigSchema,
} from '@app/seidh-common/schemas/schema.referral';

@Module({
  imports: [
    MongooseModule.forRoot(InternalProtocol.MongoUrl),
    MongooseModule.forFeature([
      { name: ReferralConfig.name, schema: ReferralConfigSchema },
    ]),
    PrometheusModule.register(),
  ],
  controllers: [ReferralController],
  providers: [ReferralService],
})
export class ReferralModule {}
