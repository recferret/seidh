import { Controller } from '@nestjs/common';
import { CharactersService } from './characters.service';
import {
  CharactersServiceCreatePattern,
  CharactersServiceCreateRequest,
} from '@app/seidh-common/dto/characters/characters.create.msg';
import {
  CharactersServiceGetByIdsPattern,
  CharactersServiceGetByIdsRequest,
} from '@app/seidh-common/dto/characters/characters.get-by-ids.msg';
import {
  CharactersServicelevelUpPattern,
  CharactersServicelevelUpRequest,
} from '@app/seidh-common/dto/characters/characters.level-up.msg';
import { MessagePattern } from '@nestjs/microservices';
import { CharactersServiceGetDefaultParamsPattern } from '@app/seidh-common/dto/characters/characters.get-default-params.msg';

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

  @MessagePattern(CharactersServicelevelUpPattern)
  levelUp(request: CharactersServicelevelUpRequest) {
    return this.charactersService.levelUp(request);
  }
}
