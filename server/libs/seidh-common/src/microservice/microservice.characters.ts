import { Inject, Injectable } from '@nestjs/common';
import { ClientProxy } from '@nestjs/microservices';

import { MicroserviceWrapper } from './microservice.utils';

import {
  CharactersServiceAddExpPattern,
  CharactersServiceAddExpRequest,
  CharactersServiceAddExpResponse,
} from '../dto/characters/characters.add-exp.msg';
import {
  CharactersServiceCreatePattern,
  CharactersServiceCreateRequest,
  CharactersServiceCreateResponse,
} from '../dto/characters/characters.create.msg';
import {
  CharactersServiceGetByIdsPattern,
  CharactersServiceGetByIdsRequest,
  CharactersServiceGetByIdsResponse,
} from '../dto/characters/characters.get-by-ids.msg';
import {
  CharactersServiceGetDefaultParamsPattern,
  CharactersServiceGetDefaultParamsResponse,
} from '../dto/characters/characters.get-default-params.msg';
import {
  CharactersServiceLevelUpPattern,
  CharactersServiceLevelUpRequest,
  CharactersServiceLevelUpResponse,
} from '../dto/characters/characters.level-up.msg';

import { ServiceName } from '../seidh-common.internal-protocol';

@Injectable()
export class MicroserviceCharacters {
  private readonly microserviceWrapper: MicroserviceWrapper;

  constructor(@Inject(ServiceName.Characters) charactersService: ClientProxy) {
    this.microserviceWrapper = new MicroserviceWrapper(charactersService);
  }

  async create(request: CharactersServiceCreateRequest) {
    return this.microserviceWrapper.request<CharactersServiceCreateRequest, CharactersServiceCreateResponse>(
      CharactersServiceCreatePattern,
      request,
    );
  }

  async getByIds(request: CharactersServiceGetByIdsRequest) {
    return this.microserviceWrapper.request<CharactersServiceGetByIdsRequest, CharactersServiceGetByIdsResponse>(
      CharactersServiceGetByIdsPattern,
      request,
    );
  }

  async getDefaultParams() {
    return this.microserviceWrapper.request<{}, CharactersServiceGetDefaultParamsResponse>(
      CharactersServiceGetDefaultParamsPattern,
      {},
    );
  }

  async addExp(request: CharactersServiceAddExpRequest) {
    return this.microserviceWrapper.request<CharactersServiceAddExpRequest, CharactersServiceAddExpResponse>(
      CharactersServiceAddExpPattern,
      request,
    );
  }

  async levelUp(request: CharactersServiceLevelUpRequest) {
    return this.microserviceWrapper.request<CharactersServiceLevelUpRequest, CharactersServiceLevelUpResponse>(
      CharactersServiceLevelUpPattern,
      request,
    );
  }
}
