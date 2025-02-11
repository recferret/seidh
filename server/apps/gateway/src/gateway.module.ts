import { NatsUrl, ServiceName } from '@lib/seidh-common/seidh-common.internal-protocol';

import { Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { JwtModule } from '@nestjs/jwt';
import { ClientsModule, Transport } from '@nestjs/microservices';

import { PrometheusModule } from '@willsoto/nestjs-prometheus';

import { ControllerAuth } from './controllers/controller.auth';
import { ControllerBoost } from './controllers/controller.boost';
import { ControllerCharacters } from './controllers/controller.characters';
import { ControllerFriends } from './controllers/controller.friends';
import { ControllerGame } from './controllers/controller.game';
import { ControllerGameplay } from './controllers/controller.gameplay';
import { ControllerTg } from './controllers/controller.tg';
import { ControllerUsers } from './controllers/controller.users';

import { ServiceBoost } from './services/service.boost';
import { ServiceCharacters } from './services/service.characters';
import { ServiceFriends } from './services/service.friends';
import { ServiceGame } from './services/service.game';
import { ServiceGameplay } from './services/service.gameplay';
import { ServiceTg } from './services/service.tg';
import { ServiceUsers } from './services/service.users';
import { MicroserviceBoost } from '@lib/seidh-common/microservice/microservice.boost';
import { MicroserviceCharacters } from '@lib/seidh-common/microservice/microservice.characters';
import { MicroserviceFriends } from '@lib/seidh-common/microservice/microservice.friends';
import { MicroserviceGame } from '@lib/seidh-common/microservice/microservice.game';
import { MicroserviceGameplay } from '@lib/seidh-common/microservice/microservice.gameplay';
import { MicroserviceTg } from '@lib/seidh-common/microservice/microservice.tg';
import { MicroserviceUsers } from '@lib/seidh-common/microservice/microservice.users';

@Module({
  imports: [
    ConfigModule.forRoot(),
    PrometheusModule.register({
      defaultLabels: {
        app: 'Gateway',
      },
    }),
    ClientsModule.register([
      {
        name: ServiceName.Game,
        transport: Transport.NATS,
        options: {
          servers: [NatsUrl],
        },
      },
      {
        name: ServiceName.GameplayLobby,
        transport: Transport.NATS,
        options: {
          servers: [NatsUrl],
        },
      },
      {
        name: ServiceName.Boost,
        transport: Transport.NATS,
        options: {
          servers: [NatsUrl],
        },
      },
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
      {
        name: ServiceName.TG,
        transport: Transport.NATS,
        options: {
          servers: [NatsUrl],
        },
      },
    ]),
    JwtModule.register({
      global: true,
      secret: process.env.JWT_SECRET,
    }),
  ],
  controllers: [
    ControllerAuth,
    ControllerBoost,
    ControllerFriends,
    ControllerGame,
    ControllerGameplay,
    ControllerUsers,
    ControllerCharacters,
    ControllerTg,
  ],
  providers: [
    MicroserviceBoost,
    MicroserviceFriends,
    MicroserviceGame,
    MicroserviceGameplay,
    MicroserviceUsers,
    MicroserviceCharacters,
    MicroserviceTg,
    ServiceBoost,
    ServiceFriends,
    ServiceGame,
    ServiceGameplay,
    ServiceUsers,
    ServiceCharacters,
    ServiceTg,
  ],
})
export class GatewayModule {}
