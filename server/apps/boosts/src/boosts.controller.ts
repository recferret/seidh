import { Controller } from '@nestjs/common';
import { MessagePattern } from '@nestjs/microservices';

import { BoostsService } from './boosts.service';

import { BoostsServiceBuyPattern, BoostsServiceBuyRequest } from '@lib/seidh-common/dto/boosts/boosts.buy.msg';
import { BoostsServiceGetPattern, BoostsServiceGetRequest } from '@lib/seidh-common/dto/boosts/boosts.get.msg';

@Controller()
export class BoostsController {
  constructor(private readonly boostsService: BoostsService) {}

  @MessagePattern(BoostsServiceGetPattern)
  async getBoosts(request: BoostsServiceGetRequest) {
    return this.boostsService.getBoosts(request);
  }

  @MessagePattern(BoostsServiceBuyPattern)
  async buyBoost(request: BoostsServiceBuyRequest) {
    return this.boostsService.buyBoost(request);
  }
}
