import { NatsUrl, ServiceName } from '@lib/seidh-common/seidh-common.internal-protocol';

import { Module } from '@nestjs/common';
import { ClientsModule, Transport } from '@nestjs/microservices';

import { PrometheusModule } from '@willsoto/nestjs-prometheus';

import { MongoModule } from '@lib/seidh-common/mongo/mongo.module';

import { ProviderBoostsMongo } from './providers/provider.boosts-mongo';

import { BoostsController } from './boosts.controller';

import { BoostsDataService } from './boosts.data.service';
import { BoostsService } from './boosts.service';
import { MicroserviceUsers } from '@lib/seidh-common/microservice/microservice.users';

@Module({
  imports: [
    PrometheusModule.register(),
    MongoModule,
    ClientsModule.register([
      {
        name: ServiceName.Users,
        transport: Transport.NATS,
        options: {
          servers: [NatsUrl],
        },
      },
    ]),
  ],
  controllers: [BoostsController],
  providers: [MicroserviceUsers, BoostsDataService, BoostsService, ...ProviderBoostsMongo],
})
export class BoostsModule {}
