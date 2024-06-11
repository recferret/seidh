import { Module } from '@nestjs/common';
import { UsersController } from './users.controller';
import { UsersService } from './users.service';
import { MongooseModule } from '@nestjs/mongoose';
import { User, UserSchema } from '@app/seidh-common/schemas/schema.user';
import { JwtModule } from '@nestjs/jwt';
import { Character, CharacterSchema } from '@app/seidh-common/schemas/schema.character';

@Module({
  imports: [
    // TODO connect to mongodb inside container
    // MongooseModule.forRoot('mongodb://localhost/seidh'),
    MongooseModule.forRoot('mongodb://mongodb:27017'),
    MongooseModule.forFeature([
      { name: User.name, schema: UserSchema },
      { name: Character.name, schema: CharacterSchema }
    ]),
    JwtModule.register({
      global: true,
      secret: 'MY SUPER SECRET',
    }),
  ],
  controllers: [UsersController],
  providers: [UsersService],
})
export class UsersModule {}
