import { Controller } from '@nestjs/common';
import { CharactersService } from './characters.service';
import {
  CharactersServiceCreatePattern,
  CharactersServiceCreateRequest,
} from '@app/seidh-common/dto/characters/characters.create.msg';
import {
  CharactersServiceGetByUserIdPattern,
  CharactersServiceGetByUserIdRequest,
} from '@app/seidh-common/dto/characters/characters.get-by-user-id.msg';
import {
  CharactersServicelevelUpPattern,
  CharactersServicelevelUpRequest,
} from '@app/seidh-common/dto/characters/characters.level-up.msg';
import { MessagePattern } from '@nestjs/microservices';

@Controller()
export class CharactersController {
  constructor(private readonly charactersService: CharactersService) {}

  @MessagePattern(CharactersServiceCreatePattern)
  create(request: CharactersServiceCreateRequest) {
    return this.charactersService.create(request);
  }

  @MessagePattern(CharactersServiceGetByUserIdPattern)
  getByUserId(request: CharactersServiceGetByUserIdRequest) {
    return this.charactersService.getByUserId(request);
  }

  @MessagePattern(CharactersServicelevelUpPattern)
  levelUp(request: CharactersServicelevelUpRequest) {
    return this.charactersService.levelUp(request);
  }
}
