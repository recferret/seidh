import { Module } from '@nestjs/common';
import { UsersController } from './users.controller';
import { UsersService } from './users.service';
import { MongooseModule } from '@nestjs/mongoose';
import { User, UserSchema } from '@app/seidh-common/schemas/schema.user';
import { JwtModule } from '@nestjs/jwt';
import {
  Character,
  CharacterSchema,
} from '@app/seidh-common/schemas/schema.character';
import { InternalProtocol, ServiceName } from '@app/seidh-common';
import { PrometheusModule } from '@willsoto/nestjs-prometheus';
import { ConfigModule } from '@nestjs/config';
import { ClientsModule, Transport } from '@nestjs/microservices';

@Module({
  imports: [
    ConfigModule.forRoot(),
    MongooseModule.forRoot(InternalProtocol.MongoUrl),
    MongooseModule.forFeature([
      { name: User.name, schema: UserSchema },
      { name: Character.name, schema: CharacterSchema },
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
    ]),
  ],
  controllers: [UsersController],
  providers: [UsersService],
})
export class UsersModule {}
