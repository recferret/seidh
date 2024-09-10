import { Module } from '@nestjs/common';
import { BoostController } from './boost.controller';
import { BoostService } from './boost.service';
import { PrometheusModule } from '@willsoto/nestjs-prometheus';
import { InternalProtocol, ServiceName } from '@app/seidh-common';
import { User, UserSchema } from '@app/seidh-common/schemas/user/schema.user';
import { MongooseModule } from '@nestjs/mongoose';
import { Boost, BoostSchema } from '@app/seidh-common/schemas/boost/schema.boost';
import {
  BoostTransaction,
  BoostTransactionSchema,
} from '@app/seidh-common/schemas/boost/schema.boost.transaction';
import { ClientsModule, Transport } from '@nestjs/microservices';

@Module({
  imports: [
    PrometheusModule.register(),
    MongooseModule.forRoot(InternalProtocol.MongoUrl),
    MongooseModule.forFeature([
      { name: User.name, schema: UserSchema },
      { name: Boost.name, schema: BoostSchema },
      { name: BoostTransaction.name, schema: BoostTransactionSchema },
    ]),
    ClientsModule.register([
      {
        name: ServiceName.WsGateway,
        transport: Transport.NATS,
        options: {
          servers: [InternalProtocol.NatsUrl],
        },
      },
    ]),
  ],
  controllers: [BoostController],
  providers: [BoostService],
})
export class BoostModule {}
