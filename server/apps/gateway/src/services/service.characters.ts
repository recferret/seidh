import { Injectable } from '@nestjs/common';
import { MicroserviceCharacters } from '@app/seidh-common/microservice/microservice.characters';
import { CharacterServiceGetDefaultParamsResponseDto } from '../dto/character/character.get-default-params.dto';

@Injectable()
export class ServiceCharacters {
  constructor(
    private microserviceCharacters: MicroserviceCharacters,
  ) {}

  async getDefaultParams() {
    const result = await this.microserviceCharacters.getDefaultParams();

    const response: CharacterServiceGetDefaultParamsResponseDto = {
      success: result.success,
      ragnarLoh: result.ragnarLoh,
      zombieBoy: result.zombieBoy,
      zombieGirl: result.zombieGirl,
    };

    return response;
  }

  async levelUp() {

  }
}
