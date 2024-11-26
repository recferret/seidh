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
  CharactersServiceGetByUserIdRequest,
  CharactersServiceGetByUserIdResponse,
  CharactersServiceGetByUserIdPattern,
} from '../dto/characters/characters.get-by-user-id.msg';
import {
  CharactersServicelevelUpRequest,
  CharactersServicelevelUpResponse,
  CharactersServicelevelUpPattern,
} from '../dto/characters/characters.level-up.msg';

@Injectable()
export class MicroserviceCharacter {
  constructor(
    @Inject(ServiceName.Characters) private charactersService: ClientProxy,
  ) {}

  async create(request: CharactersServiceCreateRequest) {
    const response: CharactersServiceCreateResponse = await firstValueFrom(
      this.charactersService.send(CharactersServiceCreatePattern, request),
    );
    return response;
  }

  async get(request: CharactersServiceGetByUserIdRequest) {
    const response: CharactersServiceGetByUserIdResponse = await firstValueFrom(
      this.charactersService.send(CharactersServiceGetByUserIdPattern, request),
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
