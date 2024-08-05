import { Controller } from '@nestjs/common';
import { BoostService } from './boost.service';
import {
  BoostsBuyPattern,
  BoostsBuyRequest,
} from '@app/seidh-common/dto/boost/boost.buy.boosts.msg';
import {
  BoostsGetPattern,
  BoostsGetRequest,
} from '@app/seidh-common/dto/boost/boost.get.boosts.msg';
import { MessagePattern } from '@nestjs/microservices';

@Controller()
export class BoostController {
  constructor(private readonly boostService: BoostService) {}

  @MessagePattern(BoostsGetPattern)
  async getBoosts(message: BoostsGetRequest) {
    return this.boostService.getBoosts(message);
  }

  @MessagePattern(BoostsBuyPattern)
  async buyBoost(message: BoostsBuyRequest) {
    return this.boostService.buyBoost(message);
  }
}
