import { Module } from '@nestjs/common';
import { BoostController } from './boost.controller';
import { BoostService } from './boost.service';
import { PrometheusModule } from '@willsoto/nestjs-prometheus';
import { InternalProtocol } from '@app/seidh-common';
import { User, UserSchema } from '@app/seidh-common/schemas/schema.user';
import { MongooseModule } from '@nestjs/mongoose';
import { Boost, BoostSchema } from '@app/seidh-common/schemas/schema.boost';

@Module({
  imports: [
    PrometheusModule.register(),
    MongooseModule.forRoot(InternalProtocol.MongoUrl),
    MongooseModule.forFeature([
      { name: User.name, schema: UserSchema },
      { name: Boost.name, schema: BoostSchema },
    ]),
  ],
  controllers: [BoostController],
  providers: [BoostService],
})
export class BoostModule {}
