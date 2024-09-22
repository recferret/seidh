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
import { ControllerUser } from './controllers/controller.user';
import { ServiceAuth } from './services/service.auth';
import { ServiceBoost } from './services/service.boost';
import { ServiceFriends } from './services/service.friends';
import { ServiceGame } from './services/service.game';
import { ServiceGameplay } from './services/service.gameplay';
import { ServiceUser } from './services/service.user';
import { MicroserviceAuth } from '@app/seidh-common/microservice/microservice.auth';
import { MicroserviceBoost } from '@app/seidh-common/microservice/microservice.boost';
import { MicroserviceFriends } from '@app/seidh-common/microservice/microservice.friends';
import { MicroserviceGame } from '@app/seidh-common/microservice/microservice.game';
import { MicroserviceGameplay } from '@app/seidh-common/microservice/microservice.gameplay';
import { MicroserviceUser } from '@app/seidh-common/microservice/microservice.user';

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
    ControllerUser,
  ],
  providers: [
    MicroserviceAuth,
    MicroserviceBoost,
    MicroserviceFriends,
    MicroserviceGame,
    MicroserviceGameplay,
    MicroserviceUser,
    ServiceAuth,
    ServiceBoost,
    ServiceFriends,
    ServiceGame,
    ServiceGameplay,
    ServiceUser,
  ],
})
export class GatewayModule {}
