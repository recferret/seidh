import { SeidhCommonBroadcasts, ServiceName } from '@app/seidh-common';
import {
  BoostsBuyBoostServiceRequest,
  BoostsBuyBoostServiceResponse,
} from '@app/seidh-common/dto/boost/boost.buy.boosts.msg';
import {
  BoostBody,
  BoostsGetServiceRequest,
  BoostsGetServiceResponse,
} from '@app/seidh-common/dto/boost/boost.get.boosts.msg';
import {
  Boost,
  BoostDocument,
  BoostType,
  CurrencyType,
} from '@app/seidh-common/schemas/boost/schema.boost';
import { BoostTransaction } from '@app/seidh-common/schemas/boost/schema.boost.transaction';
import { User } from '@app/seidh-common/schemas/user/schema.user';
import { Inject, Injectable, Logger, OnModuleInit } from '@nestjs/common';
import { ClientProxy } from '@nestjs/microservices';
import { InjectModel } from '@nestjs/mongoose';
import { Model } from 'mongoose';
import { BoostSeedService } from './boost.seed.service';

@Injectable()
export class BoostService {
  private readonly seidhCommonBroadcasts: SeidhCommonBroadcasts;

  constructor(
    @InjectModel(User.name) private userModel: Model<User>,
    @InjectModel(Boost.name) private boostModel: Model<Boost>,
    @InjectModel(BoostTransaction.name)
    private boostTransactionModel: Model<BoostTransaction>,
    @Inject(ServiceName.WsGateway) wsGatewayService: ClientProxy,
    private readonly boostSeedService: BoostSeedService,
  ) {
    this.seidhCommonBroadcasts = new SeidhCommonBroadcasts(
      userModel,
      wsGatewayService,
    );
  }

  async getBoosts(request: BoostsGetServiceRequest) {
    const response: BoostsGetServiceResponse = {
      success: false,
    };

    const user = await this.userModel.findById(request.userId);
    if (!user) {
      response.message = 'User not found';
      return response;
    }

    const boosts = this.boostSeedService.boosts
      .sort((a, b) => a.order - b.order)
      .map((boost) => {
        const boostBody: BoostBody = {
          order: boost.order,

          boostType: boost.boostType,

          levelZeroName: boost.levelZeroName,

          levelOneId: boost.levelOneId,
          levelOneName: boost.levelOneName,
          levelOneDescription1: boost.levelOneDescription1,
          levelOneDescription2: boost.levelOneDescription2,
          levelOnePrice: boost.levelOnePrice,
          levelOneCurrencyType: boost.levelOneCurrencyType,
          levelOneAccquired: false,

          levelTwoId: boost.levelTwoId,
          levelTwoName: boost.levelTwoName,
          levelTwoDescription1: boost.levelTwoDescription1,
          levelTwoDescription2: boost.levelTwoDescription2,
          levelTwoPrice: boost.levelTwoPrice,
          levelTwoCurrencyType: boost.levelTwoCurrencyType,
          levelTwoAccquired: false,

          levelThreeId: boost.levelThreeId,
          levelThreeName: boost.levelThreeName,
          levelThreeDescription1: boost.levelThreeDescription1,
          levelThreeDescription2: boost.levelThreeDescription2,
          levelThreePrice: boost.levelThreePrice,
          levelThreeCurrencyType: boost.levelThreeCurrencyType,
          levelThreeAccquired: false,
        };

        if (user.boostsOwned.includes(boostBody.levelOneId)) {
          boostBody.levelOneAccquired = true;
        }
        if (user.boostsOwned.includes(boostBody.levelTwoId)) {
          boostBody.levelTwoAccquired = true;
        }
        if (user.boostsOwned.includes(boostBody.levelThreeId)) {
          boostBody.levelThreeAccquired = true;
        }

        return boostBody;
      });

    response.success = true;
    response.boosts = boosts;

    return response;
  }

  async buyBoost(request: BoostsBuyBoostServiceRequest) {
    const response: BoostsBuyBoostServiceResponse = {
      success: false,
    };

    const boost = this.boostSeedService.boosts.find(
      (boost) =>
        boost.levelOneId == request.boostId ||
        boost.levelTwoId == request.boostId ||
        boost.levelThreeId == request.boostId,
    );

    // Has such boost
    if (!boost) {
      response.message = 'Boost not found';
      return response;
    }

    // Has such user
    const user = await this.userModel.findById(request.userId);
    if (!user) {
      response.message = 'User not found';
      return response;
    }

    // User has such boost
    if (user.boostsOwned.includes(request.boostId)) {
      response.message = 'Already owned';
      return response;
    }

    // Get a price and check availability
    let currencyType = CurrencyType.Coins;
    let price = 0;
    if (request.boostId.includes('1')) {
      currencyType = boost.levelOneCurrencyType;
      price = boost.levelOnePrice;
    } else if (request.boostId.includes('2')) {
      // Check if level 1 owned
      if (!user.boostsOwned.includes(boost.levelOneId)) {
        response.message = 'Need level 1 first';
        return response;
      }

      currencyType = boost.levelTwoCurrencyType;
      price = boost.levelTwoPrice;
    } else if (request.boostId.includes('3')) {
      // Check if level 2 owned
      if (!user.boostsOwned.includes(boost.levelTwoId)) {
        response.message = 'Need level 2 first';
        return response;
      }

      currencyType = boost.levelThreeCurrencyType;
      price = boost.levelThreePrice;
    }

    // Has enough coins
    if (
      (currencyType == CurrencyType.Coins && price > user.coins) ||
      (currencyType == CurrencyType.Teeth && price > user.teeth)
    ) {
      response.message = 'Not enough money';
      return response;
    }

    // OK flow, spent money
    if (currencyType == CurrencyType.Coins) {
      user.coins -= price;
    } else if (currencyType == CurrencyType.Teeth) {
      user.teeth -= price;
    }

    // add boost
    user.boostsOwned.push(request.boostId);

    // save and notify about balance change
    await user.save();
    await this.boostTransactionModel.create({
      boost,
      boostId: request.boostId,
      user,
    });

    await this.seidhCommonBroadcasts.notifyBalanceUpdate(user.id);

    response.success = true;
    response.boosts = await this.getBoostsByUserId(request.userId);

    return response;
  }

  private async getBoostsByUserId(userId: string) {
    const user = await this.userModel.findById(userId);

    const boosts = this.boostSeedService.boosts
      .sort((a, b) => a.order - b.order)
      .map((boost) => {
        const boostBody: BoostBody = {
          order: boost.order,

          boostType: boost.boostType,

          levelZeroName: boost.levelZeroName,

          levelOneId: boost.levelOneId,
          levelOneName: boost.levelOneName,
          levelOneDescription1: boost.levelOneDescription1,
          levelOneDescription2: boost.levelOneDescription2,
          levelOnePrice: boost.levelOnePrice,
          levelOneCurrencyType: boost.levelOneCurrencyType,
          levelOneAccquired: user.boostsOwned.includes(boost.levelOneId),

          levelTwoId: boost.levelTwoId,
          levelTwoName: boost.levelTwoName,
          levelTwoDescription1: boost.levelTwoDescription1,
          levelTwoDescription2: boost.levelTwoDescription2,
          levelTwoPrice: boost.levelTwoPrice,
          levelTwoCurrencyType: boost.levelTwoCurrencyType,
          levelTwoAccquired: user.boostsOwned.includes(boost.levelTwoId),

          levelThreeId: boost.levelThreeId,
          levelThreeName: boost.levelThreeName,
          levelThreeDescription1: boost.levelThreeDescription1,
          levelThreeDescription2: boost.levelThreeDescription2,
          levelThreePrice: boost.levelThreePrice,
          levelThreeCurrencyType: boost.levelThreeCurrencyType,
          levelThreeAccquired: user.boostsOwned.includes(boost.levelThreeId),
        };

        return boostBody;
      });

    return boosts;
  }
}
