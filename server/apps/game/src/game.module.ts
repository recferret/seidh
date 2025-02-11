import { NatsUrl, ServiceName } from '@lib/seidh-common/seidh-common.internal-protocol';

import { Module } from '@nestjs/common';
import { ClientsModule, Transport } from '@nestjs/microservices';
import { ScheduleModule } from '@nestjs/schedule';

import { PrometheusModule } from '@willsoto/nestjs-prometheus';

import { MongoModule } from '@lib/seidh-common/mongo/mongo.module';

import { ProviderGameMongo } from './providers/provider.game-mongo';

import { GameController } from './game.controller';

import { GameService } from './game.service';
import { MicroserviceCharacters } from '@lib/seidh-common/microservice/microservice.characters';
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
      {
        name: ServiceName.Characters,
        transport: Transport.NATS,
        options: {
          servers: [NatsUrl],
        },
      },
    ]),
    ScheduleModule.forRoot(),
  ],
  controllers: [GameController],
  providers: [MicroserviceUsers, MicroserviceCharacters, GameService, ...ProviderGameMongo],
})
export class GameModule {}
