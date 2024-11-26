import { Module } from '@nestjs/common';
import { CharacterController } from './character.controller';
import { CharacterService } from './character.service';
import { PrometheusModule } from '@willsoto/nestjs-prometheus';
import { InternalProtocol } from '@app/seidh-common';
import { GameConfig, GameConfigSchema } from '@app/seidh-common/schemas/game/schema.game-config';
import { MongooseModule } from '@nestjs/mongoose';

@Module({
  imports: [
    PrometheusModule.register(),
    MongooseModule.forRoot(InternalProtocol.MongoUrl),
    MongooseModule.forFeature([
      { name: GameConfig.name, schema: GameConfigSchema },
    ]),
  ],
  controllers: [CharacterController],
  providers: [CharacterService],
})
export class CharacterModule {}
