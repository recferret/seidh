import { Module } from '@nestjs/common';
import { InternalProtocol, ServiceName } from '@app/seidh-common';
import { ClientsModule, Transport } from '@nestjs/microservices';
import { JwtModule } from '@nestjs/jwt';
import { PrometheusModule } from '@willsoto/nestjs-prometheus';
import { ConfigModule } from '@nestjs/config';
import { ControllerGame } from './controllers/controller.game';
import { ControllerGameplay } from './controllers/controller.gameplay';
import { ControllerAuth } from './controllers/controller.auth';
import { ControllerBoost } from './controllers/controller.boost';
import { ControllerFriends } from './controllers/controller.friends';
import { ControllerUsers } from './controllers/controller.users';
import { ServiceBoost } from './services/service.boost';
import { ServiceFriends } from './services/service.friends';
import { ServiceGame } from './services/service.game';
import { ServiceGameplay } from './services/service.gameplay';
import { ServiceUsers } from './services/service.users';
import { MicroserviceBoost } from '@app/seidh-common/microservice/microservice.boost';
import { MicroserviceFriends } from '@app/seidh-common/microservice/microservice.friends';
import { MicroserviceGame } from '@app/seidh-common/microservice/microservice.game';
import { MicroserviceGameplay } from '@app/seidh-common/microservice/microservice.gameplay';
import { MicroserviceUsers } from '@app/seidh-common/microservice/microservice.users';
import { ControllerCharacters } from './controllers/controller.characters';
import { ServiceCharacters } from './services/service.characters';
import { MicroserviceCharacters } from '@app/seidh-common/microservice/microservice.characters';

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
          servers: [InternalProtocol.NatsUrl],
        },
      },
      {
        name: ServiceName.GameplayLobby,
        transport: Transport.NATS,
        options: {
          servers: [InternalProtocol.NatsUrl],
        },
      },
      {
        name: ServiceName.Boost,
        transport: Transport.NATS,
        options: {
          servers: [InternalProtocol.NatsUrl],
        },
      },
      {
        name: ServiceName.Users,
        transport: Transport.NATS,
        options: {
          servers: [InternalProtocol.NatsUrl],
        },
      },
      {
        name: ServiceName.Characters,
        transport: Transport.NATS,
        options: {
          servers: [InternalProtocol.NatsUrl],
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
  ],
  providers: [
    MicroserviceBoost,
    MicroserviceFriends,
    MicroserviceGame,
    MicroserviceGameplay,
    MicroserviceUsers,
    MicroserviceCharacters,
    ServiceBoost,
    ServiceFriends,
    ServiceGame,
    ServiceGameplay,
    ServiceUsers,
    ServiceCharacters,
  ],
})
export class GatewayModule {}
