import { Inject, Injectable } from '@nestjs/common';
import { ClientProxy } from '@nestjs/microservices';
import { ServiceName } from '../seidh-common.internal-protocol';
import { firstValueFrom } from 'rxjs';
import {
  BoostsBuyBoostServiceRequest,
  BoostsBuyBoostServiceResponse,
  BoostsBuyPattern,
} from '../dto/boost/boost.buy.boosts.msg';
import {
  BoostsGetServiceRequest,
  BoostsGetServiceResponse,
  BoostsGetPattern,
} from '../dto/boost/boost.get.boosts.msg';

@Injectable()
export class MicroserviceBoost {
  constructor(@Inject(ServiceName.Boost) private boostsService: ClientProxy) {}

  async getBoosts(request: BoostsGetServiceRequest) {
    const response: BoostsGetServiceResponse = await firstValueFrom(
      this.boostsService.send(BoostsGetPattern, request),
    );
    return response;
  }

  async buyBoost(request: BoostsBuyBoostServiceRequest) {
    const response: BoostsBuyBoostServiceResponse = await firstValueFrom(
      this.boostsService.send(BoostsBuyPattern, request),
    );
    return response;
  }
}
