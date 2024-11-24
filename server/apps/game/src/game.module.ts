import { Module } from '@nestjs/common';
import { GameController } from './game.controller';
import { GameService } from './game.service';
import { InternalProtocol, ServiceName } from '@app/seidh-common';
import { MongooseModule } from '@nestjs/mongoose';
import { Game, GameSchema } from '@app/seidh-common/schemas/game/schema.game';
import {
  GameProgress,
  GameProgressSchema,
} from '@app/seidh-common/schemas/game/schema.game-progress';
import { ScheduleModule } from '@nestjs/schedule';
import { ClientsModule, Transport } from '@nestjs/microservices';
import { MicroserviceUser } from '@app/seidh-common/microservice/microservice.user';
import { GameConfig, GameConfigSchema } from '@app/seidh-common/schemas/game/schema.game-config';

@Module({
  imports: [
    ClientsModule.register([
      {
        name: ServiceName.Users,
        transport: Transport.NATS,
        options: {
          servers: [InternalProtocol.NatsUrl],
        },
      },
    ]),
    MongooseModule.forRoot(InternalProtocol.MongoUrl),
    MongooseModule.forFeature([
      { name: Game.name, schema: GameSchema },
      { name: GameProgress.name, schema: GameProgressSchema },
      { name: GameConfig.name, schema: GameConfigSchema },
    ]),
    ScheduleModule.forRoot(),
  ],
  controllers: [GameController],
  providers: [MicroserviceUser, GameService],
})
export class GameModule {}
