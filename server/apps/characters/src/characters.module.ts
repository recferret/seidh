import { Module } from '@nestjs/common';
import { CharactersController } from './characters.controller';
import { CharactersService } from './characters.service';
import { PrometheusModule } from '@willsoto/nestjs-prometheus';
import { InternalProtocol } from '@app/seidh-common';
import { MongooseModule } from '@nestjs/mongoose';
import {
  Character,
  CharacterSchema,
} from '@app/seidh-common/schemas/character/schema.character';

@Module({
  imports: [
    PrometheusModule.register(),
    MongooseModule.forRoot(InternalProtocol.MongoUrl),
    MongooseModule.forFeature([
      { name: Character.name, schema: CharacterSchema },
    ]),
  ],
  controllers: [CharactersController],
  providers: [CharactersService],
})
export class CharactersModule {}
