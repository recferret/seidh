import { Controller, Get } from '@nestjs/common';
import { TgService } from './tg.service';

@Controller()
export class TgController {
  constructor(private readonly tgService: TgService) {}
}
