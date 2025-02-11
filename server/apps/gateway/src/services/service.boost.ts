import { Injectable } from '@nestjs/common';

import { MicroserviceBoost } from '@lib/seidh-common/microservice/microservice.boost';

import { BoostsGetResponseDto } from '../dto/boost/boosts.get.dto';

@Injectable()
export class ServiceBoost {
  constructor(private microserviceBoost: MicroserviceBoost) {}

  async getBoosts(userId: string) {
    const result = await this.microserviceBoost.getBoosts({
      userId,
    });
    const response: BoostsGetResponseDto = {
      success: result.success,
      boosts: result.boosts,
    };
    return response;
  }

  async buyBoost(userId: string, boostId: string) {
    const result = await this.microserviceBoost.buyBoost({
      userId,
      boostId,
    });
    const response: BoostsGetResponseDto = {
      success: result.success,
      message: result.message,
      boosts: result.boosts,
    };
    return response;
  }
}
