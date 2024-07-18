import { Controller } from '@nestjs/common';
import { BoostService } from './boost.service';
import { BoostsGetPattern, BoostsGetMessageRequest } from '@app/seidh-common/dto/boost/boost.buy.boosts.msg';
import { BoostsBuyBoostPattern, BoostsBuyBoostMessageRequest } from '@app/seidh-common/dto/boost/boost.get.boosts.msg';
import { MessagePattern } from '@nestjs/microservices';

@Controller()
export class BoostController {
  constructor(private readonly boostService: BoostService) {}

  @MessagePattern(BoostsGetPattern)
  async getBoosts(message: BoostsGetMessageRequest) {
    return this.boostService.getBoosts(message);
  }

  @MessagePattern(BoostsBuyBoostPattern)
  async buyBoost(message: BoostsBuyBoostMessageRequest) {
    return this.boostService.buyBoost(message);
  }

}
