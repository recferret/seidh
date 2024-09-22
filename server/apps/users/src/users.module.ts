import { Module } from '@nestjs/common';
import { MongooseModule } from '@nestjs/mongoose';
import { User, UserSchema } from '@app/seidh-common/schemas/user/schema.user';
import { JwtModule } from '@nestjs/jwt';
import {
  Character,
  CharacterSchema,
} from '@app/seidh-common/schemas/character/schema.character';
import { InternalProtocol, ServiceName } from '@app/seidh-common';
import { PrometheusModule } from '@willsoto/nestjs-prometheus';
import { ConfigModule } from '@nestjs/config';
import { ClientsModule, Transport } from '@nestjs/microservices';
import {
  GameGainingTransaction,
  GameGainingTransactionSchema,
} from '@app/seidh-common/schemas/game/schema.game-gaining.transaction';
import { ControllerAuth } from './controllers/controller.auth';
import { ControllerFriends } from './controllers/controller.friends';
import { ControllerUser } from './controllers/controller.user';
import { ServiceAuth } from './services/service.auth';
import { ServiceFriends } from './services/service.friends';
import { ServiceUser } from './services/service.user';
import { ProviderCrypto } from './providers/provider.crypto';

@Module({
  imports: [
    ConfigModule.forRoot(),
    MongooseModule.forRoot(InternalProtocol.MongoUrl),
    MongooseModule.forFeature([
      { name: User.name, schema: UserSchema },
      { name: Character.name, schema: CharacterSchema },
      {
        name: GameGainingTransaction.name,
        schema: GameGainingTransactionSchema,
      },
    ]),
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
          servers: [InternalProtocol.NatsUrl],
        },
      },
      {
        name: ServiceName.WsGateway,
        transport: Transport.NATS,
        options: {
          servers: [InternalProtocol.NatsUrl],
        },
      },
    ]),
  ],
  controllers: [ControllerAuth, ControllerFriends, ControllerUser],
  providers: [ProviderCrypto, ServiceAuth, ServiceFriends, ServiceUser],
})
export class UsersModule {}
