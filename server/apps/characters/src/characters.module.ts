import { Module } from '@nestjs/common';

import { PrometheusModule } from '@willsoto/nestjs-prometheus';

import { MongoModule } from '@lib/seidh-common/mongo/mongo.module';

import { ProviderCharactersMongo } from './providers/provider.characters-mongo';

import { CharactersController } from './characters.controller';

import { CharactersDataService } from './characters.data.service';
import { CharactersService } from './characters.service';

@Module({
  imports: [PrometheusModule.register(), MongoModule],
  controllers: [CharactersController],
  providers: [CharactersService, CharactersDataService, ...ProviderCharactersMongo],
})
export class CharactersModule {}
