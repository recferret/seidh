import { Module } from '@nestjs/common';

import { PrometheusModule } from '@willsoto/nestjs-prometheus';

import { CollectionController } from './collection.controller';

import { CollectionService } from './collection.service';

@Module({
  imports: [PrometheusModule.register()],
  controllers: [CollectionController],
  providers: [CollectionService],
})
export class CollectionModule {}
