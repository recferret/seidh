import { NatsUrl, ServiceName } from '@lib/seidh-common/seidh-common.internal-protocol';

import { Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { JwtModule } from '@nestjs/jwt';
import { ClientsModule, Transport } from '@nestjs/microservices';

import { PrometheusModule } from '@willsoto/nestjs-prometheus';

import { MongoModule } from '@lib/seidh-common/mongo/mongo.module';

import { ProviderCrypto } from './providers/provider.crypto';
import { ProviderUsersMongo } from './providers/provider.users-mongo';

import { ControllerAuth } from './api/nats/controller.auth';
import { ControllerFriends } from './api/nats/controller.friends';
import { ControllerUser } from './api/nats/controller.user';

import { ServiceAuth } from './services/service.auth';
import { ServiceFriends } from './services/service.friends';
import { ServiceUser } from './services/service.user';
import { MicroserviceCharacters } from '@lib/seidh-common/microservice/microservice.characters';

@Module({
  imports: [
    ConfigModule.forRoot(),
    MongoModule,
    PrometheusModule.register(),
    JwtModule.register({
      global: true,
      secret: process.env.JWT_SECRET,
    }),
    ClientsModule.register([
      {
        name: ServiceName.Referral,
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
        name: ServiceName.WsGateway,
        transport: Transport.NATS,
        options: {
          servers: [NatsUrl],
        },
      },
    ]),
  ],
  controllers: [ControllerAuth, ControllerFriends, ControllerUser],
  providers: [...ProviderUsersMongo, MicroserviceCharacters, ProviderCrypto, ServiceAuth, ServiceFriends, ServiceUser],
})
export class UsersModule {}
