import { Controller, Get } from '@nestjs/common';

import { CollectionService } from './collection.service';

@Controller()
export class CollectionController {
  constructor(private readonly collectionService: CollectionService) {}

  @Get()
  getHello(): string {
    return this.collectionService.getHello();
  }
}
