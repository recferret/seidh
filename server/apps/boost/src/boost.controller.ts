import { Controller } from '@nestjs/common';
import { BoostService } from './boost.service';
import {
  BoostsBuyPattern,
  BoostsBuyBoostServiceRequest,
} from '@app/seidh-common/dto/boost/boost.buy.boosts.msg';
import {
  BoostsGetPattern,
  BoostsGetServiceRequest,
} from '@app/seidh-common/dto/boost/boost.get.boosts.msg';
import { MessagePattern } from '@nestjs/microservices';

@Controller()
export class BoostController {
  constructor(private readonly boostService: BoostService) {}

  @MessagePattern(BoostsGetPattern)
  async getBoosts(request: BoostsGetServiceRequest) {
    return this.boostService.getBoosts(request);
  }

  @MessagePattern(BoostsBuyPattern)
  async buyBoost(request: BoostsBuyBoostServiceRequest) {
    return this.boostService.buyBoost(request);
  }
}
