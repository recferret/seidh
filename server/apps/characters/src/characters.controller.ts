import { Controller } from '@nestjs/common';
import { MessagePattern } from '@nestjs/microservices';

import { CharactersService } from './characters.service';

import {
  CharactersServiceAddExpPattern,
  CharactersServiceAddExpRequest,
} from '@lib/seidh-common/dto/characters/characters.add-exp.msg';
import {
  CharactersServiceCreatePattern,
  CharactersServiceCreateRequest,
} from '@lib/seidh-common/dto/characters/characters.create.msg';
import {
  CharactersServiceGetByIdsPattern,
  CharactersServiceGetByIdsRequest,
} from '@lib/seidh-common/dto/characters/characters.get-by-ids.msg';
import { CharactersServiceGetDefaultParamsPattern } from '@lib/seidh-common/dto/characters/characters.get-default-params.msg';
import {
  CharactersServiceLevelUpPattern,
  CharactersServiceLevelUpRequest,
} from '@lib/seidh-common/dto/characters/characters.level-up.msg';

@Controller()
export class CharactersController {
  constructor(private readonly charactersService: CharactersService) {}

  @MessagePattern(CharactersServiceCreatePattern)
  create(request: CharactersServiceCreateRequest) {
    return this.charactersService.create(request);
  }

  @MessagePattern(CharactersServiceGetByIdsPattern)
  getByIds(request: CharactersServiceGetByIdsRequest) {
    return this.charactersService.getByIds(request);
  }

  @MessagePattern(CharactersServiceGetDefaultParamsPattern)
  getMobParams() {
    return this.charactersService.getDefaultParams();
  }

  @MessagePattern(CharactersServiceAddExpPattern)
  addExp(request: CharactersServiceAddExpRequest) {
    return this.charactersService.addExp(request);
  }

  @MessagePattern(CharactersServiceLevelUpPattern)
  levelUp(request: CharactersServiceLevelUpRequest) {
    return this.charactersService.levelUp(request);
  }
}
