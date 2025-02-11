import { BoostTransaction } from '@lib/seidh-common/schemas/boost/schema.boost-transaction';
import { User } from '@lib/seidh-common/schemas/user/schema.user';
import { Model } from 'mongoose';

import { Injectable, Logger } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';

import { BoostsDataService } from './boosts.data.service';
import { MicroserviceUsers } from '@lib/seidh-common/microservice/microservice.users';

import { BoostsServiceBuyRequest, BoostsServiceBuyResponse } from '@lib/seidh-common/dto/boosts/boosts.buy.msg';
import {
  BoostBody,
  BoostsServiceGetRequest,
  BoostsServiceGetResponse,
} from '@lib/seidh-common/dto/boosts/boosts.get.msg';
import { UsersServiceUpdateBalanceRequest } from '@lib/seidh-common/dto/users/users.update-balance.msg';

import { BalanceOperationType, BalanceUpdateReason, CurrencyType } from '@lib/seidh-common/types/types.user';

@Injectable()
export class BoostsService {
  constructor(
    private readonly boostsDataService: BoostsDataService,
    private readonly microserviceUsers: MicroserviceUsers,

    @InjectModel(User.name) private userModel: Model<User>,

    @InjectModel(BoostTransaction.name)
    private boostTransactionModel: Model<BoostTransaction>,
  ) {}

  async getBoosts(request: BoostsServiceGetRequest) {
    const response: BoostsServiceGetResponse = {
      success: false,
    };

    const user = await this.userModel.findById(request.userId);
    if (!user) {
      response.message = 'User not found';
      return response;
    }

    const boosts = this.boostsDataService.boosts
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

  async buyBoost(request: BoostsServiceBuyRequest) {
    const response: BoostsServiceBuyResponse = {
      success: false,
    };

    try {
      const boost = this.boostsDataService.boosts.find(
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
      let currencyType = CurrencyType.COINS;
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
        (currencyType == CurrencyType.COINS && price > user.coins) ||
        (currencyType == CurrencyType.TEETH && price > user.teeth)
      ) {
        response.message = 'Not enough money';
        return response;
      }

      const balanceUpdateRequest: UsersServiceUpdateBalanceRequest = {
        userId: user.id,
        operation: BalanceOperationType.SUBTRACT,
        reason: BalanceUpdateReason.BUY_BOOST,
      };

      if (currencyType == CurrencyType.COINS) {
        balanceUpdateRequest.coins = price;
      } else if (CurrencyType.TEETH) {
        balanceUpdateRequest.teeth = price;
      }

      const balanceUpdateResponse = await this.microserviceUsers.updateBalance(balanceUpdateRequest);
      if (balanceUpdateResponse.success) {
        user.boostsOwned.push(request.boostId);
        await user.save();

        await this.boostTransactionModel.create({
          boost,
          boostId: request.boostId,
          user,
          coinsSpent: currencyType == CurrencyType.COINS ? price : 0,
          teethSpent: currencyType == CurrencyType.TEETH ? price : 0,
        });

        response.success = true;
        response.boosts = await this.getBoostsByUserId(request.userId);
      } else {
        response.message = 'Unable to update user balance';
      }
    } catch (error) {
      Logger.error(
        {
          message: 'buyBoost error',
          request,
        },
        error,
      );
    }

    return response;
  }

  private async getBoostsByUserId(userId: string) {
    const user = await this.userModel.findById(userId);

    const boosts = this.boostsDataService.boosts
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
