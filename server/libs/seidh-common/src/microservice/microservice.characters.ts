import { Inject, Injectable } from '@nestjs/common';
import { ClientProxy } from '@nestjs/microservices';
import { ServiceName } from '../seidh-common.internal-protocol';
import { firstValueFrom } from 'rxjs';
import {
  CharactersServiceCreateRequest,
  CharactersServiceCreateResponse,
  CharactersServiceCreatePattern,
} from '../dto/characters/characters.create.msg';
import {
  CharactersServiceGetByIdsRequest,
  CharactersServiceGetByIdsResponse,
  CharactersServiceGetByIdsPattern,
} from '../dto/characters/characters.get-by-ids.msg';
import {
  CharactersServicelevelUpRequest,
  CharactersServicelevelUpResponse,
  CharactersServicelevelUpPattern,
} from '../dto/characters/characters.level-up.msg';
import {
  CharactersServiceGetDefaultParamsResponse,
  CharactersServiceGetDefaultParamsPattern,
} from '../dto/characters/characters.get-default-params.msg';

@Injectable()
export class MicroserviceCharacters {
  constructor(
    @Inject(ServiceName.Characters) private charactersService: ClientProxy,
  ) {}

  async create(request: CharactersServiceCreateRequest) {
    const response: CharactersServiceCreateResponse = await firstValueFrom(
      this.charactersService.send(CharactersServiceCreatePattern, request),
    );
    return response;
  }

  async getByIds(request: CharactersServiceGetByIdsRequest) {
    const response: CharactersServiceGetByIdsResponse = await firstValueFrom(
      this.charactersService.send(CharactersServiceGetByIdsPattern, request),
    );
    return response;
  }

  async getDefaultParams() {
    const response: CharactersServiceGetDefaultParamsResponse =
      await firstValueFrom(
        this.charactersService.send(
          CharactersServiceGetDefaultParamsPattern,
          {},
        ),
      );
    return response;
  }

  async levelUp(request: CharactersServicelevelUpRequest) {
    const response: CharactersServicelevelUpResponse = await firstValueFrom(
      this.charactersService.send(CharactersServicelevelUpPattern, request),
    );
    return response;
  }
}
