import { Inject, Injectable } from '@nestjs/common';
import { ClientProxy } from '@nestjs/microservices';

import { MicroserviceWrapper } from './microservice.utils';

import {
  BoostsServiceBuyPattern,
  BoostsServiceBuyRequest,
  BoostsServiceBuyResponse,
} from '../dto/boosts/boosts.buy.msg';
import {
  BoostsServiceGetPattern,
  BoostsServiceGetRequest,
  BoostsServiceGetResponse,
} from '../dto/boosts/boosts.get.msg';

import { ServiceName } from '../seidh-common.internal-protocol';

@Injectable()
export class MicroserviceBoost {
  private readonly microserviceWrapper: MicroserviceWrapper;

  constructor(@Inject(ServiceName.Boost) boostsService: ClientProxy) {
    this.microserviceWrapper = new MicroserviceWrapper(boostsService);
  }

  async getBoosts(request: BoostsServiceGetRequest) {
    return this.microserviceWrapper.request<BoostsServiceGetRequest, BoostsServiceGetResponse>(
      BoostsServiceGetPattern,
      request,
    );
  }

  async buyBoost(request: BoostsServiceBuyRequest) {
    return this.microserviceWrapper.request<BoostsServiceBuyRequest, BoostsServiceBuyResponse>(
      BoostsServiceBuyPattern,
      request,
    );
  }
}
